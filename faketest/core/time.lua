modtest.api.us_time = 0

function modtest.api.step_us_time(us)
	modtest.api.us_time = modtest.api.us_time + us
end

function core.get_us_time()
	return modtest.api.us_time
end

function core.get_day_count()
	error("TODO: implement")
end

function core.get_gametime()
	error("TODO: implement")
end

function core.get_server_uptime()
	error("TODO: implement")
end

function core.get_timeofday()
	error("TODO: implement")
end

function core.get_us_time()
	error("TODO: implement")
end

function core.set_timeofday()
	error("TODO: implement")
end
