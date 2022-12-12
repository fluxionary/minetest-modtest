local function load_settings(filename)
	local settings = {}
	if filename then
		for line in io.lines(filename) do
			local key, value = modtest.util.parse_config_line(line)
			if key and value then
				settings[key] = value
			end
		end
	end
	return settings
end

Settings = modtest.util.make_class()

function Settings:_init(conf_file)
	self.__table = load_settings(conf_file)
end

function Settings:get(key)
	return self.__table[key]
end

function Settings:get_bool(key, default)
	local value = self.__table[key]
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
	self.__table[key] = tostring(value)
end

function Settings:set_bool(key, value)
	if value == true then
		self.__table[key] = "true"
	elseif value == false then
		self.__table[key] = "false"
	elseif value == nil then
		self.__table[key] = nil
	end
end

function Settings:set_np_group(key, value)
	error("Settings:set_np_group: TODO") -- TODO
end

function Settings:remove(key)
	self.__table[key] = nil
end

function Settings:get_names()
	local names = {}
	for key, _ in pairs(self.__table) do
		table.insert(names, key)
	end
	return names
end

function Settings:write()
	return false
end

function Settings:to_table()
	local t = {}
	for key, value in pairs(self.__table) do
		t[key] = value
	end
	return t
end
