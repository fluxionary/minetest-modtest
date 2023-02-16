local util = modtest.util

function util.is_empty(t)
	return next(t) == nil
end

function util.set_all(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
end

-- generalized equality, not just for tables
function util.equals(a, b)
	local type_a = type(a)
	if type_a ~= type(b) then
		return false
	end
	if type_a ~= "table" then
		return a == b
	elseif a == b then
		return true
	end

	local size_a = 0

	for key, value in pairs(a) do
		if not util.equals(value, b[key]) then
			return false
		end
		size_a = size_a + 1
	end

	local size_b = 0
	for _ in pairs(b) do
		size_b = size_b + 1
		if size_b > size_a then
			return false
		end
	end

	return size_a == size_b
end

function util.table_copy(t, seen)
	if type(t) ~= "table" then
		return t
	end
	seen = seen or {}
	local t_copy = {}
	seen[t] = t_copy
	for k in pairs(t) do
		local v = rawget(t, k)

		if type(k) == "table" then
			k = seen[k] or util.table_copy(k, seen)
		end
		if type(v) == "table" then
			v = seen[v] or util.table_copy(v, seen)
		end

		rawset(t_copy, k, v)
	end

	setmetatable(t_copy, util.table_copy(getmetatable(t)))

	return t_copy
end
