local state = ...

modtest.loadfile("minetest_api", "core", "mapgen", "biome")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "decoration")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "mapgen")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "noise", "init")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "ore")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "params")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "schematic")(state)
modtest.loadfile("minetest_api", "core", "mapgen", "tree")(state)
