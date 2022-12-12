function modtest.core.trigger_globalstep(dtime)
	-- disconnect timed out clients
	-- update active blocks, run callbacks
	-- run node timers

	local registered_globalsteps = core.registered_globalsteps
	for i = 1, #registered_globalsteps do
		registered_globalsteps[i](dtime)
	end
end
