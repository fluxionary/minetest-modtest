local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

example_mod = {
	version = os.time({ year = 2022, month = 11, day = 14 }),
	author = "fluxionary",
	license = "AGPLv3+",

	modname = modname,
	modpath = modpath,

	log = function(level, message, ...)
		message = message:format(...)
		minetest.log(level, ("[%s] %s"):format(modname, message))
	end,

	dofile = function(...)
		dofile(table.concat({ modpath, ... }, DIR_DELIM) .. ".lua")
	end,
}

minetest.register_node("example_mod:node", {})
minetest.register_tool("example_mod:tool", {})
