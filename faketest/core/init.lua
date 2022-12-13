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

modtest.dofile("faketest", "core", "helpers", "init")

modtest.dofile("faketest", "core", "async")
modtest.dofile("faketest", "core", "entity")
modtest.dofile("faketest", "core", "globalstep")
modtest.dofile("faketest", "core", "inventory")
modtest.dofile("faketest", "core", "item", "init")
modtest.dofile("faketest", "core", "mod_storage")
modtest.dofile("faketest", "core", "player")
modtest.dofile("faketest", "core", "state")
modtest.dofile("faketest", "core", "time")
modtest.dofile("faketest", "core", "world")
