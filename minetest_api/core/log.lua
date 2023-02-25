local state = ...

local f = string.format

local chat_log_level = core.settings:get("chat_log_level")
local debug_log_level = core.settings:get("debug_log_level")
local debug_log_size_max = tonumber(core.settings:get("debug_log_size_max"))
local deprecated_lua_api_handling = core.settings:get("deprecated_lua_api_handling")

local log_levels = {
	none = 0,
	error = 1,
	warning = 2,
	action = 3,
	info = 4,
	verbose = 5,
	trace = 6,
	max = 7,
}

function core.log(level, message)
	if not message then
		level, message = "none", message
	end

	if level == "deprecated" then
		message = "deprecated call: " .. message
		if deprecated_lua_api_handling == "log" then
			core.log("warning", message)
		elseif deprecated_lua_api_handling == "error" then
			error(message)
		end
		return
	end

	if (log_levels[level] or log_levels.max) == log_levels.max then
		core.log("warning", f('Tried to log at unknown level %q.  Defaulting to "none".', level))
		level = "none"
	end

	if log_levels[level] <= log_levels[debug_log_level] then
		state.log_messages:push_back({ level = level, message = message })
	end
	local log_message = f("[%s] %s", level:upper(), message)
	if modtest.debug then
		print(log_message)
	end
	if log_levels[level] <= log_levels[chat_log_level] then
		core.chat_send_all(log_message)
	end
end

-- TODO: how to define this so that busted's output doesn't get mangled???
-- this is used by the builtin code to override _G.print
local print = _G.print
function core.print(message)
	print(message)
	state.log_messages:push_back(message or "")
	if debug_log_size_max and debug_log_size_max > 0 then
		while state.log_messages:size() > debug_log_size_max do
			state.log_messages:pop_front()
		end
	end
end
