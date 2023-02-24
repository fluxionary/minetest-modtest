local state = ...

modtest.loadfile("minetest_api", "core", "mapgen", "noise", "noise")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "noise", "perlin")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "noise", "perlin_map")(state)
