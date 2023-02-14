-- from minetest/builtin/misc_helpers.lua
function string:split(delim, include_empty, max_splits, sep_is_pattern)
	delim = delim or ","
	max_splits = max_splits or -2
	local items = {}
	local pos, len = 1, #self
	local plain = not sep_is_pattern
	max_splits = max_splits + 1
	repeat
		local np, npe = self:find(delim, pos, plain)
		np, npe = (np or (len + 1)), (npe or (len + 1))
		if (not np) or (max_splits == 1) then
			np = len + 1
			npe = np
		end
		local s = self:sub(pos, np - 1)
		if include_empty or (s ~= "") then
			max_splits = max_splits - 1
			items[#items + 1] = s
		end
		pos = npe + 1
	until (max_splits == 0) or (pos > (len + 1))
	return items
end

function string:trim()
	return self:match("^%s*(.-)%s*$")
end
