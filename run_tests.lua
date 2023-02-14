local concat_path = modtest.util.concat_path
local file_exists = modtest.util.file_exists

local busted = require("busted.core")()
local filterLoader = require("busted.modules.filter_loader")()
local outputHandlerLoader = require("busted.modules.output_handler_loader")()

require("busted")(busted)

local luacov = require("luacov.runner")
local luacov_defaults = require("luacov.defaults")
local luacov_config = {}

modtest.util.set_all(luacov_config, luacov_defaults)
modtest.util.set_all(luacov_config, {
	includeuntestedfiles = true,
	include = {},
	exclude = {
		"spec/",
		"/%.?luarocks/",
		"/share/lua/",
		"busted_bootstrap$",
		"busted%.",
		"luassert%.",
		"say%.",
		"pl%.",
	},
})

luacov(luacov_config)
luacov.configuration = luacov_config

-- watch for test errors and failures
local failures = 0
local errors = 0

busted.subscribe({ "error", "output" }, function(element, parent, message)
	io.stderr:write(
		(appName or "??") .. ": error: Cannot load output library: " .. element.name .. "\n" .. message .. "\n"
	)
	return nil, true
end)

busted.subscribe({ "error", "helper" }, function(element, parent, message)
	io.stderr:write(
		(appName or "??") .. ": error: Cannot load helper script: " .. element.name .. "\n" .. message .. "\n"
	)
	return nil, true
end)

busted.subscribe({ "error" }, function(element, parent, message)
	errors = errors + 1
	busted.skipAll = false
	return nil, true
end)

busted.subscribe({ "failure" }, function(element, parent, message)
	if element.descriptor == "it" then
		failures = failures + 1
	else
		errors = errors + 1
	end
	busted.skipAll = false
	return nil, true
end)

-- Set up randomization options
busted.randomseed = os.time()

-- Set up output handler to listen to events
outputHandlerLoader(busted, "utfTerminal", {
	defaultOutput = "utfTerminal",
	enableSound = false,
	verbose = true,
	suppressPending = false,
	language = "en",
	deferPrint = false,
	arguments = {},
})

-- Load tag and test filters
filterLoader(busted, {
	tags = nil,
	excludeTags = nil,
	filter = nil,
	filterOut = nil,
	list = nil,
	nokeepgoing = false,
	suppressPending = false,
})

function modtest.with_environment(description, callback)
	return busted.api.insulate(description, function()
		modtest.initialize_environment()
		modtest.load_mods()

		local setup_file = concat_path(modtest.args.mod_to_test, "modtest", "init.lus")

		if file_exists(setup_file) then
			dofile(setup_file)
		end

		return callback()
	end)
end

local test_root = concat_path(modtest.args.mod_to_test, "modtest", "tests")

-- Load test directories/files
local testFileLoader = require("busted.modules.test_file_loader")(busted, { "lua" })
testFileLoader({ test_root }, { "lua" }, {
	excludes = {},
	verbose = true,
	recursive = nil,
})

local execute = require("busted.execute")(busted)
execute(1, {
	seed = nil,
	shuffle = false,
	sort = false,
})

busted.publish({ "exit" })

require("luacov.runner").shutdown()

local exit = require("busted.compatibility").exit
if failures > 0 or errors > 0 then
	exit(failures + errors, forceExit)
end
