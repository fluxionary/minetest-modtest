local State = ...

State._register_initializers(function(self)
	self.max_lag = 0.1
	self.time_of_last_globalstep = 0
end, function(self, other)
	self.max_lag = other.max_lag
	self.time_of_last_globalstep = other.time_of_last_globalstep
end)

function State:trigger_globalstep()
	local current_time = core.get_us_time()
	local dtime = current_time - self.time_of_last_globalstep
	self.time_of_last_globalstep = current_time

	self.max_lag = self.max_lag * 0.9998
	if dtime > self.max_lag then
		self.max_lag = dtime
	end

	-- TODO: wait before disconnecting?
	for _, player in core.get_connected_players() do
		if player:_is_timed_out() then
			player:_disconnect()
		end
	end

	-- TODO:
	-- active block management
	-- LBMs
	-- ABMs
	-- run node timers

	local registered_globalsteps = core.registered_globalsteps
	for i = 1, #registered_globalsteps do
		registered_globalsteps[i](dtime)
	end

	-- handle async results
	for _, result in ipairs(self.async_results) do
		local job_id, retval = unpack(result)
		core.async_event_handler(job_id, retval)
	end
	self.async_results = {}

	-- TODO:
	-- step active objects
end
