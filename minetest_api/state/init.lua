local State = modtest.util.class1()

State._initializers = {}
State._copiers = {}

function State._register_initializers(initializer, copier)
	table.insert(State._initializers, initializer)
	table.insert(State._copiers, copier)
end

function State:_init()
	for _, initializer in ipairs(State._initializers) do
		initializer(self)
	end
end

modtest.loadfile("minetest_api", "state", "async")(State)
modtest.loadfile("minetest_api", "state", "globalstep")(State)
modtest.loadfile("minetest_api", "state", "inventory")(State)
modtest.loadfile("minetest_api", "state", "item")(State)
modtest.loadfile("minetest_api", "state", "log")(State)
modtest.loadfile("minetest_api", "state", "map")(State)
modtest.loadfile("minetest_api", "state", "mod_storage")(State)
modtest.loadfile("minetest_api", "state", "mods")(State)
modtest.loadfile("minetest_api", "state", "object")(State)
modtest.loadfile("minetest_api", "state", "os")(State)
modtest.loadfile("minetest_api", "state", "particle")(State)
modtest.loadfile("minetest_api", "state", "player")(State)
modtest.loadfile("minetest_api", "state", "rollback")(State)
modtest.loadfile("minetest_api", "state", "time")(State)

return State
