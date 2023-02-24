local state = ...

local f = string.format

local deepcopy = modtest.util.deepcopy

function core.get_builtin_path()
	return modtest.args.builtin .. DIR_DELIM
end

function core.get_current_modname()
	return state.current_modname
end

function core.get_last_run_mod()
	return state.last_run_mod
end

function core.get_modnames()
	return deepcopy(state.all_modnames)
end

function core.get_modpath(name)
	return state.all_modpaths[name]
end

function core.get_server_max_lag()
	return state.max_lag
end

function core.get_server_status()
	local player_names = {}
	for name in pairs(state.connected_players) do
		table.insert(player_names, name)
	end
	table.sort(player_names)
	return f(
		"version: %s | null_game: %s | uptime: %s | max lag: %.03fs | clients: %s",
		core.get_version(),
		modtest.args.game_name,
		core.get_server_uptime(),
		core.get_server_max_lag(),
		table.concat(player_names, ", ")
	)
end

function core.get_user_path()
	if modtest.args.mods then
		return modtest.util.concat_path(modtest.args.mods, "..")
	else
		return modtest.util.concat_path(os.getenv("HOME"), ".minetest")
	end
end

function core.get_version()
	return "faketest"
end

function core.get_worldpath()
	return modtest.args.world
end

function core.is_singleplayer()
	-- TODO: allow specifying whether or not it is
	return false
end

function core.set_last_run_mod(mod)
	state.last_run_mod = mod
end

function core.request_shutdown()
	for _, callback in ipairs(core.registered_on_shutdown) do
		callback()
	end
end
