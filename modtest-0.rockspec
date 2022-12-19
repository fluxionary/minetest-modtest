package = "modtest"
version = "20220412"
source = {
	url = "git+https://github.com/fluxionary/modtest.git",
}
description = {
	summary = "Testing framework for minetest",
	homepage = "https://github.com/fluxionary/modtest",
	license = "AGPL"
}
dependencies = {
	"luajit >= 2.1.0",
	"busted >= 2.0",
	"luacov >= 0.14"
}
build = {
	type = 'make',
	build_variables = {
		INSTALL="1",
		BINDIR="$(BINDIR)",
		LUADIR="$(LUADIR)/modtest",
		CFLAGS="$(CFLAGS)"
	},
}
