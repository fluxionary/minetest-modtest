local concat_path = modtest.util.concat_path
local file_exists = modtest.util.file_exists
local iterate_tree = modtest.util.iterate_tree

function modtest.with_environment(description, callback)
	insulate(description, function()
		modtest.initialize_environment()
		modtest.load_mods()

		local setup_file = concat_path(modtest.args.mod_to_test, "modtest", "init.lus")

		if file_exists(setup_file) then
			dofile(setup_file)
		end

		return callback()
	end)
end

for file in iterate_tree(concat_path(modtest.args.mod_to_test, "modtest", "tests")) do
	if file:match("%.lua$") then
		modtest.log({ debug, 1 }, "running tests in " .. file)
		dofile(file)
	end
end

local busted = require("busted.core")()
local filterLoader = require("busted.modules.filter_loader")()
local helperLoader = require("busted.modules.helper_loader")()
local outputHandlerLoader = require("busted.modules.output_handler_loader")()

require("busted")(busted)
local exit = require("busted.compatibility").exit

local luacov = require("luacov.runner")
luacov(luacov_config)

-- require("busted.runner")()
