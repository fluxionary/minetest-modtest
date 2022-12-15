local function parse(fh, filepath)
	local linenum = 0
	local values = {}

	local state = "normal"
	local multikey
	local multiline

	for line in fh:lines() do
		linenum = linenum + 1
		line = line:trim()
		if state == "group" then
			if line:sub(-1) == "}" then
				table.insert(multiline, line)
				values[multikey] = table.concat(multiline, "\n"):trim()
				multikey = nil
				multiline = nil
				state = "normal"
			else
				table.insert(multiline, line)
			end
		elseif state == "multiline" then
			if line:sub(-3) == '"""' then
				table.insert(multiline, line:sub(1, -4))
				values[multikey] = table.concat(multiline, "\n"):trim()
				multikey = nil
				multiline = nil
				state = "normal"
			end
		elseif state == "normal" then
			if #line > 0 and line:sub(1, 1) ~= "#" then
				local key, value = line:match("^([^=]+)=(.*)$")
				if not (key and value) then
					error(("invalid conf file %q line %i"):format(filepath, linenum))
				end

				key = key:trim()
				value = value:trim()

				if key == "" then
					error(("blank key in %q line %i"):format(filepath, linenum))
				end

				if value:sub(1, 1) == "{" and value:sub(-1) ~= "}" then
					state = "group"
					multikey = key
					multiline = { value }
				elseif value:sub(1, 3) == '"""' and (value:sub(-3) ~= '"""' or #value < 6) then
					state = "multiline"
					multikey = key
					multiline = { value:sub(4) }
				else
					values[key] = value
				end
			end
		else
			error(("somehow in invalid state %q line %i"):format(state, linenum))
		end
	end

	return values
end

local function load_settings(filename, defaults)
	local settings
	if defaults then
		settings = table.copy(defaults)
	else
		settings = {}
	end

	if modtest.util.file_exists(filename) then
		local fh = io.open(filename)
		local changes = parse(fh, filename)
		io.close(fh)

		modtest.util.set_all(settings, changes)
	end

	return settings
end

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
