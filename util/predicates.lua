local util = modtest.util

function util.is_yes(value)
	return (value == "y" or value == "yes" or value == "true" or value == true or (tonumber(value) or 0) ~= 0)
end

function util.in_bounds(min, v, max)
	return min <= v and v <= max
end

function util.is_valid_colorspec(v)
	if type(v) == "table" then
		return util.in_bounds(0, v.r, 255)
			and util.in_bounds(0, v.g, 255)
			and util.in_bounds(0, v.b, 255)
			and (not v.a or util.in_bounds(0, v.a, 255))
	elseif type(v) == "string" then
		return v:match("^#%x%x%x$")
			or v:match("#%x%x%x%x$")
			or v:match("#%x%x%x%x%x%x$")
			or v:match("#%x%x%x%x%x%x%x%x$")
	elseif type(v) == "number" then
		return v == math.floor(v) and util.in_bounds(0, v, (2 ^ 32) - 1)
	end

	return false
end

function util.is_non_negative_number(x)
	return type(x) == "number" and x >= 0
end

function util.is_non_negative_integer(x)
	return type(x) == "number" and math.floor(x) == x and x >= 0
end

function util.is_frame_index(thing)
	return type(thing) == "table" and util.is_non_negative_integer(thing.x) and util.is_non_negative_integer(thing.y)
end
