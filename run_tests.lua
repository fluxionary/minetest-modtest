local concat_path = modtest.util.concat_path
local file_exists = modtest.util.file_exists
local iterate_tree = modtest.util.iterate_tree

require("busted.runner")()

local setup_file = concat_path(modtest.args.mod_to_test, "modtest", "init.lus")

if file_exists(setup_file) then
	dofile(setup_file)
end

for file in iterate_tree(concat_path(modtest.args.mod_to_test, "modtest", "tests")) do
	if file:match("*.lua$") then
		dofile(file)
	end
end
