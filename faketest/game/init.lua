

-- Shared between builtin files, but
-- not exposed to outer context
local builtin_shared = {}

modtest.dofile("faketest", "game", "constants")
assert(modtest.loadfile("faketest", "game", "item"))(builtin_shared)
modtest.dofile("faketest", "game", "register")
modtest.dofile("faketest", "common", "after")
modtest.dofile("faketest", "game", "item_entity")
modtest.dofile("faketest", "game", "deprecated")
modtest.dofile("faketest", "game", "misc")
modtest.dofile("faketest", "game", "privileges")
modtest.dofile("faketest", "game", "auth")
modtest.dofile("faketest", "common", "chatcommands")
modtest.dofile("faketest", "game", "chat")
modtest.dofile("faketest", "common", "information_formspecs")
modtest.dofile("faketest", "game", "static_spawn")
modtest.dofile("faketest", "game", "detached_inventory")
assert(modtest.loadfile("faketest", "game", "falling"))(builtin_shared)
modtest.dofile("faketest", "game", "features")
modtest.dofile("faketest", "game", "voxelarea")
modtest.dofile("faketest", "game", "forceloading")
modtest.dofile("faketest", "game", "statbars")
modtest.dofile("faketest", "game", "knockback")
