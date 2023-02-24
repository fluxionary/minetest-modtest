local state = ...

core = {
	log = function(level, message)
		message = ("[%s] %s"):format(level, message)
		modtest.log({ "debug", 1 }, message)
		self.log_messages:push_back(message)
	end,

	debug = function(...)
		core.log(table.concat({ ... }, "\t"))
	end,

	settings = Settings(modtest.args.conf or "", modtest.default_minetest_settings),

	get_builtin_path = function()
		return modtest.args.builtin .. DIR_DELIM
	end,
}

modtest.loadfile("minetest_api", "core", "helpers", "init")(state) -- provides some dependencies

modtest.loadfile("minetest_api", "core", "async")(state)
modtest.loadfile("minetest_api", "core", "entity")(state)
modtest.loadfile("minetest_api", "core", "inventory")(state)
modtest.loadfile("minetest_api", "core", "log")(state)
modtest.loadfile("minetest_api", "core", "item", "init")(state)
modtest.loadfile("minetest_api", "core", "map")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "init")(state)
modtest.loadfile("minetest_api", "core", "mod_channel")(state)
modtest.loadfile("minetest_api", "core", "mod_storage")(state)
modtest.loadfile("minetest_api", "core", "os", "init")(state)
modtest.loadfile("minetest_api", "core", "particle")(state)
modtest.loadfile("minetest_api", "core", "player", "init")(state)
modtest.loadfile("minetest_api", "core", "rollback")(state)
modtest.loadfile("minetest_api", "core", "state")(state)
modtest.loadfile("minetest_api", "core", "time")(state)

-- this is some sort of debugging callback, i'm unsure where it would belong in the above breakup
function core.serialize_roundtrip()
	error("TODO: implement")
end
