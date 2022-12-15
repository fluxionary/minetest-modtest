MetaDataRef = modtest.util.class1()

function MetaDataRef:_init()
	self.__table = {}
end

function MetaDataRef:contains(key)
	return self.__table[key] ~= nil
end

function MetaDataRef:get(key)
	return self.__table[key]
end

function MetaDataRef:set_string(key, value)
	if type(value) ~= "string" then
		error("invalid value type")
	end
	if value == "" then
		self.__table[key] = nil
	else
		self.__table[key] = tostring(value)
	end
end

function MetaDataRef:get_string(key)
	return self.__table[key]
end

function MetaDataRef:set_int(key, value)
	if type(value) ~= "number" then
		error("invalid value type")
	end
	self:set_string(tostring(math.floor(value)))
end

function MetaDataRef:get_int(key)
	return tonumber(self.__table[key]) or 0
end

function MetaDataRef:set_float(key, value)
	if type(value) ~= "number" then
		error("invalid value type")
	end
	self:set_string(tostring(value))
end

function MetaDataRef:get_float(key)
	return tonumber(self.__table[key]) or 0
end

function MetaDataRef:to_table()
	local t = { fields = {} }
	for key, value in pairs(self.__table) do
		t.fields[key] = value
	end
	return t
end

function MetaDataRef:from_table(t)
	for key, _ in pairs(self.__table) do
		self.__table[key] = nil
	end
	if type(t) == "table" and type(t.fields) == "table" then
		for key, value in pairs(t.fields) do
			self.__table[key] = value
		end
	end
end

function MetaDataRef:equals(other)
	return modtest.util.equals(self.__table, other.__table)
end
