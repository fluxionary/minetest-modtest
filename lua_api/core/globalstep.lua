modtest.api.max_lag = 0.1
modtest.api.time_of_last_globalstep = 0

function modtest.api.trigger_globalstep()
	local current_time = core.get_us_time()
	local dtime = current_time - modtest.api.time_of_last_globalstep
	modtest.api.time_of_last_globalstep = current_time

	modtest.api.max_lag = modtest.api.max_lag * 0.9998
	if dtime > modtest.api.max_lag then
		modtest.api.max_lag = dtime
	end

	-- TODO: wait before disconnecting?
	for _, player in core.get_connected_players() do
		if player:_is_timed_out() then
			player:_disconnect()
		end
	end

	-- active block management
	-- LBMs
	-- ABMs
	-- run node timers

	local registered_globalsteps = core.registered_globalsteps
	for i = 1, #registered_globalsteps do
		registered_globalsteps[i](dtime)
	end

	-- handle async results
	for _, result in ipairs(modtest.api.async_results) do
		local job_id, retval = unpack(result)
		core.async_event_handler(job_id, retval)
	end
	modtest.api.async_results = {}

	-- TODO:
	-- step active objects
end
