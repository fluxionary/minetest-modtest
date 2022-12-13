modtest.api.current_modname = nil -- i think it's nil by default?
modtest.api.last_run_mod = nil

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

function core.get_worldpath()
	return modtest.args.world
end

modtest.api.all_modpaths = {}
function modtest.api.set_all_modpaths(modpaths)
	modtest.api.all_modpaths = modpaths
end

function core.get_modpath(name)
	return modtest.api.all_modpaths[name]
end

function core.get_builtin_path()
	error("TODO: implement")
end

function core.get_current_modname()
	error("TODO: implement")
end

function core.get_last_run_mod()
	error("TODO: implement")
end

function core.get_modnames()
	error("TODO: implement")
end

function core.get_modpath()
	error("TODO: implement")
end

function core.get_server_max_lag()
	error("TODO: implement")
end

function core.get_server_status()
	error("TODO: implement")
end

function core.get_user_path()
	error("TODO: implement")
end

function core.get_version()
	error("TODO: implement")
end

function core.get_worldpath()
	error("TODO: implement")
end

function core.is_singleplayer()
	error("TODO: implement")
end

function core.set_last_run_mod()
	error("TODO: implement")
end

function core.request_shutdown()
	error("TODO: implement")
end
