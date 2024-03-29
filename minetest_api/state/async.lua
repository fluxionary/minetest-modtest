local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.async_env = nil
	self.async_jobs = modtest.util.Deque()
	self.async_results = {}
end, function(self, other)
	self.async_env = deepcopy(other.async_env)
	self.async_jobs = deepcopy(other.async_jobs)
	self.async_results = deepcopy(other.async_results)
end)

function State:_build_initial_async_env()
	local env = {
		assert = assert,
		bit = bit,
		collectgarbage = collectgarbage,
		core = {
			colorspec_to_bytes = core.colorspec_to_bytes,
			colorspec_to_colorstring = core.colorspec_to_colorstring,
			compress = core.compress,
			cpdir = core.cpdir,
			decode_base64 = core.decode_base64,
			decompress = core.decompress,
			encode_base64 = core.encode_base64,
			encode_png = core.encode_png,
			get_all_craft_recipes = core.get_all_craft_recipes,
			get_builtin_path = core.get_builtin_path,
			get_content_id = core.get_content_id,
			get_craft_recipe = core.get_craft_recipe,
			get_craft_result = core.get_craft_result,
			get_current_modname = core.get_current_modname,
			get_dir_list = core.get_dir_list,
			get_last_run_mod = core.get_last_run_mod,
			get_modnames = core.get_modnames,
			get_modpath = core.get_modpath,
			get_name_from_content_id = core.get_name_from_content_id,
			get_user_path = core.get_user_path,
			get_us_time = core.get_us_time,
			get_version = core.get_version,
			get_worldpath = core.get_worldpath,
			is_singleplayer = core.is_singleplayer,
			is_yes = core.is_yes,
			log = core.log,
			mkdir = core.mkdir,
			mvdir = core.mvdir,
			parse_json = core.parse_json,
			request_insecure_environment = core.request_insecure_environment,
			rmdir = core.rmdir,
			safe_file_write = core.safe_file_write,
			set_last_run_mod = core.set_last_run_mod,
			settings = core.settings,
			sha1 = core.sha1,
			write_json = core.write_json,
			transferred_globals = {
				registered_aliases = core.registered_aliases,
				registered_items = core.registered_items,
			},
		},
		coroutine = coroutine,
		debug = debug,
		DIR_DELIM = DIR_DELIM,
		dofile = dofile,
		error = error,
		getfenv = getfenv,
		getmetatable = getmetatable,
		INIT = "async_game",
		io = io,
		ipairs = ipairs,
		ItemStack = ItemStack,
		jit = jit,
		loadfile = loadfile,
		load = load,
		loadstring = loadstring,
		math = math,
		next = next,
		os = os,
		package = package,
		pairs = pairs,
		pcall = pcall,
		PcgRandom = PcgRandom,
		PerlinNoise = PerlinNoise,
		PerlinNoiseMap = PerlinNoiseMap,
		print = print,
		PseudoRandom = PseudoRandom,
		rawequal = rawequal,
		rawget = rawget,
		rawset = rawset,
		require = require,
		SecureRandom = SecureRandom,
		select = select,
		setfenv = setfenv,
		setmetatable = setmetatable,
		Settings = Settings,
		string = string,
		table = table,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		unpack = unpack,
		vector = vector,
		_VERSION = _VERSION,
		VoxelManip = VoxelManip,
		xpcall = xpcall,
	}
	env._G = env
	setfenv(1, env)

	dofile(core.get_builtin_path() .. DIR_DELIM .. "init.lua")

	return env
end

function State:get_async_env()
	local env = self.async_env
	if not env then
		env = self:_build_initial_async_env()
		self.async_env = env
	end
	return env
end

function State:_run_job_in_env(func, args)
	local env = table.copy(self.get_async_env())
	env.func = func
	env.args = args
	setfenv(1, env)
	return func(args)
end

function State:run_next_async_job()
	local job = self.async_jobs:pop_front()
	if job then
		local job_id, func, args = unpack(job) -- also has mod_origin
		local retval = self:_run_job_in_env(func, args)
		table.insert(self.async_results, { job_id, retval })
	end
end
