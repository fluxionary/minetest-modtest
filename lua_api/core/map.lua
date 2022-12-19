--local m_min = math.min
--local m_max = math.max
--local m_floor = math.floor
--
--local in_bounds = modtest.util.in_bounds
--local bound = modtest.util.bound
--
--local mapblock_size = 16
--local chunksize = m_floor(tonumber(core.settings:get("chunksize")) or 5)
--local max_mapgen_limit = 31007
--local mapgen_limit = m_floor(tonumber(core.settings:get("mapgen_limit")) or max_mapgen_limit)
--local mapgen_limit_b = m_floor(bound(0, mapgen_limit, max_mapgen_limit) / mapblock_size)
--local mapgen_limit_min = -mapgen_limit_b * mapblock_size
--local mapgen_limit_max = (mapgen_limit_b + 1) * mapblock_size - 1
--
--local map_min_i = mapgen_limit_min + (mapblock_size * chunksize)
--local map_max_i = mapgen_limit_max - (mapblock_size * chunksize)
--
--local v_add = vector.add
--local v_copy = vector.copy
--local v_new = vector.new
--local v_sort = vector.sort
--local v_sub = vector.subtract
--
--local map_min_p = v_new(map_min_i, map_min_i, map_min_i)
--local map_max_p = v_new(map_max_i, map_max_i, map_max_i)

modtest.api.map = {}
modtest.api.active_mapblocks = {}

function modtest.api.clear_map()
	modtest.api.map = {}
end

local Mapblock = modtest.util.class1()

function Mapblock._init(blockpos)
	self.blockpos = blockpos

	for x = 1, 16 do
		local panel = {}
		for y = 1, 16 do
			local column = {}
			for z = 1, 16 do
				column[z] = {
					node = {
						name = core.CONTENT_UNKNOWN,
						param1 = 0,
						param2 = 0,
					},
					meta = NodeMetaRef(),
					timer = NodeTimerRef(),
				}
			end
			panel[y] = column
		end
		self[x] = panel
	end

	self.active = false
end

function Mapblock:get_node(pos)
	local relative = pos - (self.blockpos * 16)
	return self[relative.x][relative.y][relative.z].node
end

function Mapblock:set_node(pos, node)
	local relative = pos - (self.blockpos * 16)
	self[relative.x][relative.y][relative.z].node = node
end

function Mapblock:iter_nodes(filter)
	local p1 = self.blockpos * 16
	local p2 = p1 + 15
	local va = VoxelArea(p1, p2)
	local i = 0
	return function()
		while i < (16 ^ 3) do
			i = i + 1
			local pos = va:position(i)
			local node = self:get_node(pos)
			if (not filter) or filter(node) then
				return pos, node
			end
		end
	end
end

function modtest.api.get_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	return modtest.api.map[index]
end

function modtest.api.emerge_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = modtest.api.map[index]

	if not mapblock then
		mapblock = Mapblock(blockpos)
		modtest.api.map[index] = mapblock
	end

	return mapblock
end

function modtest.api.activate_mapblock(blockpos)
	local mapblock = modtest.api.emerge_mapblock(blockpos)
	mapblock.active = true
	for _, def in ipairs(core.registered_lbms) do
		error("TODO: implement")
		--for
	end
end

function modtest.api.deactivate_mapblock(blockpos)
	local mapblock = modtest.api.emerge_mapblock(blockpos)
	mapblock.active = false
end

function core.add_node(pos, node)
	local blockpos = vector.floor(pos / 16)
	local mapblock = modtest.api.emerge_mapblock(blockpos)
	mapblock:set_node(pos, node)
end

--[[
* `minetest.add_node_level(pos, level)`
    * increase level of leveled node by level, default `level` equals `1`
    * if `totallevel > maxlevel`, returns rest (`total-max`)
    * `level` must be between -127 and 127
]]
function core.add_node_level(pos, level)
	error("TODO: implement")
end

function core.bulk_set_node(poss, node)
	for _, pos in ipairs(poss) do
		core.set_node(pos, node)
	end
end

function core.compare_block_status(pos, condition)
	if not (condition == "unknown" or condition == "emerging" or condition == "loaded" or condition == "active") then
		return
	end

	local blockpos = vector.floor(pos / 16)
	local mapblock = modtest.api.get_mapblock(blockpos)
	if not mapblock then
		return condition == "unknown"
	else
		if condition == "loaded" then
			return true
		elseif condition == "active" then
			return mapblock.active
		end
	end

	return false
end

function core.delete_area(pos1, pos2)
	error("TODO: implement")
end

function core.dig_node(pos)
	error("TODO: implement")
end

function core.find_node_near(pos, radius, nodenames, search_center)
	error("TODO: implement")
end

function core.find_nodes_in_area(pos1, pos2, nodenames, grouped)
	error("TODO: implement")
end

function core.find_nodes_in_area_under_air(pos1, pos2, nodenames)
	error("TODO: implement")
end

function core.find_nodes_with_meta()
	error("TODO: implement")
end

function core.fix_light()
	error("TODO: implement")
end

function core.forceload_block()
	error("TODO: implement")
end

function core.forceload_free_block()
	error("TODO: implement")
end

function core.get_meta()
	error("TODO: implement")
end

function core.get_natural_light()
	error("TODO: implement")
end

function core.get_node()
	error("TODO: implement")
end

function core.get_node_level()
	error("TODO: implement")
end

function core.get_node_light()
	error("TODO: implement")
end

function core.get_node_max_level()
	error("TODO: implement")
end

function core.get_node_or_nil()
	error("TODO: implement")
end

function core.get_node_timer()
	error("TODO: implement")
end

function core.get_voxel_manip()
	error("TODO: implement")
end

function core.load_area()
	error("TODO: implement")
end

function core.place_node()
	error("TODO: implement")
end

function core.punch_node()
	error("TODO: implement")
end

function core.remove_node()
	error("TODO: implement")
end

core.set_node = core.add_node

function core.set_node_level()
	error("TODO: implement")
end

function core.swap_node()
	error("TODO: implement")
end

function core.transforming_liquid_add()
	error("TODO: implement")
end
