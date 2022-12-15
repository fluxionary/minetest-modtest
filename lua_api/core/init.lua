local minetest_log_messages = {}

core = {
	log = function(level, message)
		message = ("[%s] %s"):format(level, message)
		modtest.log({ "debug", 1 }, message)
		table.insert(minetest_log_messages, message)
	end,

	debug = function(...)
		core.log(table.concat({ ... }, "\t"))
	end,

	settings = Settings(modtest.args.conf or "", modtest.default_minetest_settings),

	get_builtin_path = function()
		return modtest.args.builtin .. DIR_DELIM
	end,
}

modtest.api = {}

modtest.dofile("lua_api", "core", "helpers", "init") -- provides some dependencies

modtest.dofile("lua_api", "core", "async")
modtest.dofile("lua_api", "core", "entity")
modtest.dofile("lua_api", "core", "globalstep")
modtest.dofile("lua_api", "core", "inventory")
modtest.dofile("lua_api", "core", "item", "init")
modtest.dofile("lua_api", "core", "mapgen", "init")
modtest.dofile("lua_api", "core", "mod_channel")
modtest.dofile("lua_api", "core", "mod_storage")
modtest.dofile("lua_api", "core", "os", "init")
modtest.dofile("lua_api", "core", "particle")
modtest.dofile("lua_api", "core", "player", "init")
modtest.dofile("lua_api", "core", "rollback")
modtest.dofile("lua_api", "core", "state")
modtest.dofile("lua_api", "core", "time")
modtest.dofile("lua_api", "core", "world")

-- this is some sort of debugging callback
function core.serialize_roundtrip()
	error("TODO: implement")
end
