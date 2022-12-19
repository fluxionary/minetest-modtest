local f = string.format

ItemStackMetaRef = modtest.util.class1(MetaDataRef)

function ItemStackMetaRef:_init(serialized_data)
	MetaDataRef._init(self)
	if serialized_data then
		self._deserialize(serialized_data)
	end
end

function ItemStackMetaRef:set_tool_capabilities(tool_caps)
	self:set_string("tool_capabilities", core.write_json(tool_caps))
end

local DESERIALIZE_START = "\x01"
local DESERIALIZE_KV_DELIM = "\x02"
local DESERIALIZE_PAIR_DELIM = "\x03"

function ItemStackMetaRef:_serialize()
	local parts = {}
	table.insert(parts, DESERIALIZE_START)
	for k, v in pairs(self._table) do
		if k ~= "" or v ~= "" then
			table.insert(parts, k)
			table.insert(parts, DESERIALIZE_KV_DELIM)
			table.insert(parts, v)
			table.insert(parts, DESERIALIZE_PAIR_DELIM)
		end
	end

	return modtest.serialization.serialize_json_string_if_needed(table.concat(parts, ""))
end

function ItemStackMetaRef:_deserialize(data)
	if type(data) ~= "string" then
		error(f("serialized item stack meta must be a string, not %s", type(data)))
	end
	data = modtest.serialization.deserialize_json_string(data)
	if data:sub(1, #DESERIALIZE_START) ~= DESERIALIZE_START then
		error(f("invalid serialized ItemStackMeta %q", data))
	end
	local parts = data:sub(#DESERIALIZE_START + 1):split(DESERIALIZE_PAIR_DELIM)
	local t = self._table
	for i = 1, #parts do
		local key, value = unpack(parts[i]:split(DESERIALIZE_KV_DELIM))
		t[key] = value
	end
end
