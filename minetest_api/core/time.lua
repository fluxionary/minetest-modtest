local state = ...

function core.get_day_count()
	return state.day_count
end

function core.get_gametime()
	return state.gametime
end

function core.get_server_uptime()
	return state.us_time / 1e6
end

function core.get_timeofday()
	return math.floor(24000 * state.gametime)
end

function core.get_us_time()
	return state.us_time
end

function core.set_timeofday(value)
	state.gametime = value % 1
	state.day_count = state.day_count + math.floor(value)
end

-- this leads to infinite loop ...
--os.actual_time = os.time
--
--function os.time(...)
--	if #{ ... } > 0 then
--		return os.actual_time(...)
--	end
--	return state.start_time + core.get_server_uptime()
--end
