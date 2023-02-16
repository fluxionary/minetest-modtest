local util = modtest.util

function util.iterate_area(minp, maxp)
	minp, maxp = vector.sort(minp, maxp)
	local min_x = minp.x
	local min_z = minp.z

	local x = min_x - 1
	local y = minp.y
	local z = min_z

	local max_x = maxp.x
	local max_y = maxp.y
	local max_z = maxp.z

	local v_new = vector.new
	return function()
		if y > max_y then
			return
		end

		x = x + 1
		if x > max_x then
			x = min_x
			z = z + 1
		end

		if z > max_z then
			z = min_z
			y = y + 1
		end

		if y <= max_y then
			return v_new(x, y, z)
		end
	end
end

function util.volume(p1, p2)
	p1, p2 = vector.sort(p1, p2)
	return (p2.x - p1.x + 1) * (p2.y - p1.y + 1) * (p2.z - p1.z + 1)
end

function util.vector_in_bounds(v_min, v, v_max)
	return util.in_bounds(v_min.x, v.x, v_max.x)
		and util.in_bounds(v_min.y, v.y, v_max.y)
		and util.in_bounds(v_min.z, v.z, v_max.z)
end

local mapblock_size = 16

function util.get_blockpos(pos)
	return vector.new(
		math.floor(pos.x / mapblock_size),
		math.floor(pos.y / mapblock_size),
		math.floor(pos.z / mapblock_size)
	)
end
