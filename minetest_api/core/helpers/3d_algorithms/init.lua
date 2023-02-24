local state = ...

modtest.loadfile("minetest_api", "core", "helpers", "3d_algorithms", "find_path")(state)
modtest.loadfile("minetest_api", "core", "helpers", "3d_algorithms", "line_of_sight")(state)
modtest.loadfile("minetest_api", "core", "helpers", "3d_algorithms", "raycast")(state)
