modtest.dofile("faketest", "classes", "init")
modtest.dofile("faketest", "core", "init")

INIT = "game"

modtest.doexternal(modtest.args.builtin, "init")
