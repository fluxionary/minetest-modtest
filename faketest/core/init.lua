local minetest_log_messages = {}

core = {
	log = function(level, message)
		message = ("[%s] %s"):format(level, message)
		modtest.log({"debug", 1}, message)
		table.insert(minetest_log_messages, message)
	end,

	debug = function(...)
		core.log(table.concat({...}, "\t"))
	end,

	settings = Settings(modtest.conf)
}

modtest.dofile("faketest", "core", "register_raw")
modtest.dofile("faketest", "core", "getters")
modtest.dofile("faketest", "core", "http_api")
modtest.dofile("faketest", "core", "crafting")
