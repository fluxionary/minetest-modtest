-- 72 = 20min, 360 = 4min, 1 = 24hour, 0 = day/night/whatever stays unchanged
local time_speed = tonumber(core.settings:get("time_speed"))

local api = modtest.api

function api.add_us_time(us)
	api.us_time = api.us_time + us
	local gametime = api.gametime
	gametime = gametime + (us * time_speed / 1e6)
	api.day_count = api.day_count + math.floor(gametime)
	api.gametime = gametime % 1
end

function core.get_day_count()
	return api.day_count
end

function core.get_gametime()
	return api.gametime
end

function core.get_server_uptime()
	return api.us_time / 1e6
end

function core.get_timeofday()
	return math.floor(24000 * api.gametime)
end

function core.get_us_time()
	return api.us_time
end

function core.set_timeofday(value)
	api.gametime = value % 1
	api.day_count = api.day_count + math.floor(value)
end

os.actual_time = os.time

function os.time(...)
	if #{ ... } > 0 then
		return os.actual_time(...)
	end
	return api.start_time + core.get_server_uptime()
end
