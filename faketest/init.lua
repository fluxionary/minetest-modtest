--
-- This file contains built-in stuff in Minetest implemented in Lua.
--
-- It is always loaded and executed after registration of the C API,
-- before loading and running any mods.
--

modtest.dofile("faketest", "classes", "init")
modtest.dofile("faketest", "core", "init")

-- Initialize some very basic things
math.randomseed(os.time())

modtest.dofile("faketest", "common", "init")
modtest.dofile("faketest", "game", "init")

minetest = core
