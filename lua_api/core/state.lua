local f = string.format

modtest.api.current_modname = nil -- i think it's nil by default?
modtest.api.last_run_mod = nil

modtest.api.all_modnames = {}
modtest.api.all_modpaths = {}

function core.get_builtin_path()
	return modtest.args.builtin
end

function modtest.api.set_current_modname(name)
	modtest.api.current_modname = name
end

function core.get_current_modname()
	return modtest.api.current_modname
end

function modtest.api.set_last_run_mod(name)
	modtest.api.last_run_mod = name
end

function core.get_last_run_mod()
	return modtest.api.last_run_mod
end

function modtest.api.set_all_modpaths(modpaths)
	modtest.api.all_modpaths = modpaths
	for modname in pairs(modpaths) do
		table.insert(modtest.api.all_modnames, modname)
	end
end

function core.get_modnames()
	return table.copy(modtest.api.all_modnames)
end

function core.get_modpath(name)
	return modtest.api.all_modpaths[name]
end

function core.get_server_max_lag()
	return modtest.api.max_lag
end

function core.get_server_status()
	local player_names = {}
	for name in pairs(modtest.api.connected_players) do
		table.insert(player_names, name)
	end
	table.sort(player_names)
	return f(
		"version: %s | game: %s | uptime: %s | max lag: %.03fs | clients: %s",
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
	modtest.api.last_run_mod = mod
end

function core.request_shutdown()
	for _, callback in ipairs(core.registered_on_shutdown) do
		callback()
	end
end
