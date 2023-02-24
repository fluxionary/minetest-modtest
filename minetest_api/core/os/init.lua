local state = ...

modtest.loadfile("minetest_api", "core", "os", "insecure")(state)
modtest.loadfile("minetest_api", "core", "os", "os")(state)
