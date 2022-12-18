local load_settings = modtest.util.load_settings

Settings = modtest.util.class1()

function Settings:_init(conf_file, defaults)
	if not conf_file then
		error("Settings requires a filename argument")
	end
	self._table = load_settings(conf_file, defaults)
end

function Settings:get(key)
	return self._table[key]
end

function Settings:get_bool(key, default)
	local value = self._table[key]
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	else
		return default
	end
end

function Settings:get_np_group(key)
	error("Settings:get_np_group: TODO") -- TODO
end

function Settings:get_flags(key)
	error("Settings:get_flags: TODO") -- TODO
end

function Settings:set(key, value)
	self._table[key] = tostring(value)
end

function Settings:set_bool(key, value)
	if value == true then
		self._table[key] = "true"
	elseif value == false then
		self._table[key] = "false"
	elseif value == nil then
		self._table[key] = nil
	end
end

function Settings:set_np_group(key, value)
	error("Settings:set_np_group: TODO") -- TODO
end

function Settings:remove(key)
	self._table[key] = nil
end

function Settings:get_names()
	local names = {}
	for key, _ in pairs(self._table) do
		table.insert(names, key)
	end
	return names
end

function Settings:write()
	-- TODO: possibly fake it, parameterize behavior, or something
	modtest.log({ "warning", 1 }, "warning: writing settings is disabled")
	return false
end

function Settings:to_table()
	local t = {}
	for key, value in pairs(self._table) do
		t[key] = value
	end
	return t
end

local function load_default_settings()
	local settingtypes_path = modtest.util.concat_path(modtest.args.builtin, "settingtypes.txt")
	if not modtest.util.file_exists(settingtypes_path) then
		error("cannot locate settingtypes.txt in the built path")
	end

	local default_settings = {}

	for line in io.lines(settingtypes_path) do
		local key, value = modtest.util.parse_settingtypes_line(line)
		if key and value then
			default_settings[key] = value
		end
	end

	return default_settings
end

modtest.default_minetest_settings = load_default_settings()
