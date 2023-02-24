local state = ...

modtest.loadfile("minetest_api", "core", "player", "auth")(state)
modtest.loadfile("minetest_api", "core", "player", "ban")(state)
modtest.loadfile("minetest_api", "core", "player", "chat")(state)
modtest.loadfile("minetest_api", "core", "player", "player")(state)
modtest.loadfile("minetest_api", "core", "player", "sound")(state)
