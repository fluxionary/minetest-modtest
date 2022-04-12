
ItemStackMetaRef = modtest.util.make_class(MetaDataRef)

function ItemStackMetaRef:set_tool_capabilities(tool_caps)
	error("this can't use core.serialize, i don't think")
	self.__table.tool_capabilities = core.serialize(tool_caps)
end

local DESERIALIZE_START = "\x01"
local DESERIALIZE_KV_DELIM = "\x02"
local DESERIALIZE_PAIR_DELIM = "\x03"

function ItemStackMetaRef:_serialize()
	local parts = {}
	table.insert(parts, DESERIALIZE_START)
	for k, v in pairs(self.__table) do
		if k ~= "" or v ~= "" then
			table.insert(parts, k)
			table.insert(parts, DESERIALIZE_KV_DELIM)
			table.insert(parts, v)
			table.insert(parts, DESERIALIZE_PAIR_DELIM)
		end
	end

	return modtest.serialization.serialize_json_string_if_needed(table.concat(parts, ""))
end

local DESERIALIZE_START_STR = "\x01"
local DESERIALIZE_KV_DELIM_STR = "\x02"
local DESERIALIZE_PAIR_DELIM_STR = "\x03"
function ItemStack:_deserialize()

end
