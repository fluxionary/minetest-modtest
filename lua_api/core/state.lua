local f = string.format

local api = modtest.api

function core.get_builtin_path()
	return modtest.args.builtin .. DIR_DELIM
end

function api.set_current_modname(name)
	api.current_modname = name
end

function core.get_current_modname()
	return api.current_modname
end

function api.set_last_run_mod(name)
	api.last_run_mod = name
end

function core.get_last_run_mod()
	return api.last_run_mod
end

function api.set_all_modpaths(modpaths)
	api.all_modpaths = modpaths
	for modname in pairs(modpaths) do
		table.insert(api.all_modnames, modname)
	end
end

function core.get_modnames()
	return table.copy(api.all_modnames)
end

function core.get_modpath(name)
	return api.all_modpaths[name]
end

function core.get_server_max_lag()
	return api.max_lag
end

function core.get_server_status()
	local player_names = {}
	for name in pairs(api.connected_players) do
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
	api.last_run_mod = mod
end

function core.request_shutdown()
	for _, callback in ipairs(core.registered_on_shutdown) do
		callback()
	end
end
