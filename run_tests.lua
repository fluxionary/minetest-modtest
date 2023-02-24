local f = string.format

local concat_path = modtest.util.concat_path
local deepcopy = modtest.util.deepcopy
local file_exists = modtest.util.file_exists

local busted = require("busted.core")()
require("busted")(busted)

-- Set up randomization options
busted.randomseed = os.time()

--local luacov = require("luacov.runner")
--local luacov_defaults = require("luacov.defaults")
--local luacov_config = {}
--
--modtest.util.set_all(luacov_config, luacov_defaults)
--modtest.util.set_all(luacov_config, {
--	includeuntestedfiles = true,
--	include = {},
--	exclude = {
--		-- TODO what should be excluded?
--		"spec/",
--	},
--})
--
--luacov(luacov_config)
--luacov.configuration = luacov_config

-- watch for test errors and failures
local failures = 0
local errors = 0

busted.subscribe({ "error", "output" }, function(element, parent, message)
	io.stderr:write(f("%s: error: Cannot load output library: %s\n%s\n", appName or "??", element.name, message))
	return nil, true
end)

busted.subscribe({ "error", "helper" }, function(element, parent, message)
	io.stderr:write(f("%s: error: Cannot load helper script: %s\n%s\n", appName or "??", element.name, message))
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

-- Set up output handler to listen to events
local output_handler_loader = require("busted.modules.output_handler_loader")()
output_handler_loader(busted, "utfTerminal", {
	defaultOutput = "utfTerminal",
	enableSound = false,
	verbose = true,
	suppressPending = false,
	language = "en",
	deferPrint = false,
	arguments = {},
})

-- Load tag and test filters
local filter_loader = require("busted.modules.filter_loader")()
filter_loader(busted, {
	tags = nil,
	excludeTags = nil,
	filter = nil,
	filterOut = nil,
	list = nil,
	nokeepgoing = false,
	suppressPending = false,
})

function modtest.build_environment()
	local env = {
		modtest = modtest,

		assert = assert,
		bit = bit,
		collectgarbage = collectgarbage,
		coroutine = coroutine,
		debug = debug, -- todo limit
		DIR_DELIM = DIR_DELIM,
		dofile = dofile, -- todo limit
		error = error,
		getfenv = getfenv,
		getmetatable = getmetatable,
		io = io, -- todo limit
		ipairs = ipairs,
		jit = jit,
		loadfile = loadfile, -- todo limit
		load = load,
		loadstring = loadstring,
		math = math,
		next = next,
		os = os,
		package = package,
		pairs = pairs,
		pcall = pcall,
		print = print,
		rawequal = rawequal,
		rawget = rawget,
		rawset = rawset,
		require = require,
		select = select,
		setfenv = setfenv,
		setmetatable = setmetatable,
		string = string,
		table = table,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		unpack = unpack,
		_VERSION = _VERSION,
		xpcall = xpcall,
	}

	env._G = env

	setfenv(1, env)

	local state = modtest.initialize_environment()
	env.state = state
	modtest.load_mods(state)

	local setup = modtest.loadexternal(modtest.args.mod_to_test, "modtest", "init")

	if setup then
		setup(state)
	else
		modtest.log("debug", "can't find setup file " .. concat_path(modtest.args.mod_to_test, "modtest", "init.lua"))
	end

	return env
end

--local environment = modtest.build_environment()

function modtest.with_environment(description, callback)
	return busted.api.insulate(description, function()
		local env = modtest.build_environment()
		setfenv(1, env)

		return callback(env.state)
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

--require("luacov.runner").shutdown()

local exit = require("busted.compatibility").exit
if failures > 0 or errors > 0 then
	exit(failures + errors, forceExit)
end
