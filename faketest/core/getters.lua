local current_modname = nil  -- i think it's nil by default?
local last_run_mod = nil

function modtest.set_current_modname(name)
	current_modname = name
end

function core.get_current_modname()
	return current_modname
end

function modtest.set_last_run_mod(name)
	last_run_mod = last_run_mod
end

function core.get_last_run_mod()
	return last_run_mod
end

function core.get_worldpath()
	return modtest.args.world
end

local all_modpaths = {}
function modtest.set_all_modpaths(modpaths)
	all_modpaths = modpaths
end

function core.get_modpath(name)
	return all_modpaths[name]
end
