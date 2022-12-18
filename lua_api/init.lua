modtest.api = {}

modtest.dofile("lua_api", "classes", "init")
modtest.dofile("lua_api", "core", "init")

INIT = "game"

modtest.doexternal(modtest.args.builtin, "init")
