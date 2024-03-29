local f = string.format

local forward_translation = {
	['"'] = '\\"',
	["\\"] = "\\\\",
	["/"] = "\\/",
	["\b"] = "\\b",
	["\f"] = "\\f",
	["\n"] = "\\n",
	["\r"] = "\\r",
	["\t"] = "\\t",
}

local reverse_translation = {
	['"'] = '"',
	["\\"] = "\\",
	["/"] = "/",
	["b"] = "\b",
	["f"] = "\f",
	["n"] = "\n",
	["r"] = "\r",
	["t"] = "\t",
}

function modtest.util.serialize_json_string_if_needed(s)
	for i = 1, #s do
		local c = s:sub(i, i)
		if c == " " or c == '"' then
			return modtest.util.serialize_json_string(s)
		end
		local b = string.byte(c)
		if b <= 0x1f or b >= 0x7f then
			return modtest.util.serialize_json_string(s)
		end
	end

	return s
end

function modtest.util.serialize_json_string(s)
	local parts = {}
	table.insert(parts, '"')
	for i = 1, #s do
		local c = s:sub(i, i)
		local b = string.byte(c)
		if forward_translation[c] then
			c = forward_translation[c]
		elseif 32 > b or b > 126 then
			c = f("\\u%x", b)
		end
		table.insert(parts, c)
	end
	table.insert(parts, '"')
	return table.concat(parts, "")
end

function modtest.util.deserialize_json_string(s)
	local parts = {}

	local i = 1
	while i <= #s do
		local c = s:sub(i, i)
		if i == 1 and c ~= '"' then
			error("JSON string must start with doublequote")
		elseif i == #s and c ~= '"' then
			error("JSON string ended prematurely")
		else
			if c == "\\" then
				i = i + 1
				local c2 = s:sub(i, i)
				table.insert(parts, reverse_translation[c2])
			else
				table.insert(parts, c)
			end
		end
		i = i + 1
	end
end
