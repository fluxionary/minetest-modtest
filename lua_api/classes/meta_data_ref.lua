local f = string.format

MetaDataRef = modtest.util.class1()

function MetaDataRef:_init()
	self._contents = {}
end

function MetaDataRef:_is_empty()
	return modtest.util.is_empty(self._contents)
end

function MetaDataRef:contains(key)
	return self._contents[key] ~= nil
end

function MetaDataRef:get(key)
	return self._contents[key]
end

function MetaDataRef:get_string(key)
	return self._contents[key] or ""
end

function MetaDataRef:set_string(key, value)
	assert(type(value) == "string", f("value must be a string, is a %s", type(value)))
	if value == "" then
		self._contents[key] = nil
	else
		self._contents[key] = tostring(value)
	end
end

function MetaDataRef:get_int(key)
	return tonumber(self._contents[key]) or 0
end

function MetaDataRef:set_int(key, value)
	assert(type(value) == "number", f("value must be a number, is a %s", type(value)))
	local ipart = math.modf(value)
	if ipart == 0 then
		self._contents[key] = nil
	else
		self._contents[key] = ipart
	end
end

function MetaDataRef:get_float(key)
	return tonumber(self._contents[key]) or 0
end

function MetaDataRef:set_float(key, value)
	assert(type(value) == "number", f("value must be a number, is a %s", type(value)))
	self:set_string(tostring(value))
end

function MetaDataRef:to_table()
	return { fields = table.copy(self._contents) }
end

function MetaDataRef:from_table(t)
	assert(type(t) == "table" and type(t.fields) == "table")
	self._contents = table.copy(t.fields)
end

function MetaDataRef:equals(other)
	return modtest.util.equals(self._contents, other._contents)
end

function MetaDataRef:__equals(other)
	return modtest.util.equals(self._contents, other._contents)
end
