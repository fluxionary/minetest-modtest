local State = modtest.dofile("minetest_api", "state", "init")

function modtest.initialize_environment()
	local state = State()

	modtest.loadfile("minetest_api", "classes", "init")(state)
	modtest.loadfile("minetest_api", "core", "init")(state)

	INIT = "game"

	modtest.doexternal(modtest.args.builtin, "init")

	return state
end
