-- 72 = 20min, 360 = 4min, 1 = 24hour, 0 = day/night/whatever stays unchanged
local time_speed = tonumber(core.settings:get("time_speed"))
local world_start_time = tonumber(core.settings:get("world_start_time"))

modtest.api.us_time = 0
modtest.api.gametime = world_start_time / 24000 -- in [0, 1)
modtest.api.day_count = 0

function modtest.api.add_us_time(us)
	modtest.api.us_time = modtest.api.us_time + us
	local gametime = modtest.api.gametime
	gametime = gametime + (us * time_speed / 1e6)
	modtest.api.day_count = modtest.api.day_count + math.floor(gametime)
	modtest.api.gametime = gametime % 1
end

function core.get_day_count()
	return modtest.api.day_count
end

function core.get_gametime()
	return modtest.api.gametime
end

function core.get_server_uptime()
	return modtest.api.us_time / 1e6
end

function core.get_timeofday()
	return math.floor(24000 * modtest.api.gametime)
end

function core.get_us_time()
	return modtest.api.us_time
end

function core.set_timeofday(value)
	modtest.api.gametime = value % 1
	modtest.api.day_count = modtest.api.day_count + math.floor(value)
end
