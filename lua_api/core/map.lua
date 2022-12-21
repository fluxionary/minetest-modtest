local f = string.format

local m_floor = math.floor

local t_copy = table.copy

-- NOTICE: we cannot cache vector methods because they don't exist yet

local bound = modtest.util.bound
local in_bounds = modtest.util.in_bounds
local iterate_area = modtest.util.iterate_area
local memoize1 = modtest.util.memoize1
local volume = modtest.util.volume

local mapblock_size = 16
local chunksize = m_floor(tonumber(core.settings:get("chunksize")) or 5)
local max_mapgen_limit = 31007
local mapgen_limit = m_floor(tonumber(core.settings:get("mapgen_limit")) or max_mapgen_limit)
-- mapgen limit in blocks
local mapgen_limit_b = m_floor(bound(0, mapgen_limit, max_mapgen_limit) / mapblock_size)
local mapgen_limit_min = -mapgen_limit_b * mapblock_size
local mapgen_limit_max = (mapgen_limit_b + 1) * mapblock_size - 1

local map_min_i = mapgen_limit_min + (mapblock_size * chunksize)
local map_max_i = mapgen_limit_max - (mapblock_size * chunksize)

local function in_world_bounds(pos)
	return in_bounds(map_min_i, pos.x, map_max_i)
		and in_bounds(map_min_i, pos.y, map_max_i)
		and in_bounds(map_min_i, pos.z, map_max_i)
end

local enable_rollback_recording = core.settings:get_bool("enable_rollback_recording", false)

local api = modtest.api

api.map = {}

function api.clear_map()
	api.map = {}
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
					name = "air",
					param1 = 0,
					param2 = 0,
				}
			end
			panel[y] = column
		end
		self[x] = panel
	end

	self.metas = {}
	self.timers = {}

	self.loaded = true
	self.active = false
end

function Mapblock:get_node(pos)
	local relative = pos - (self.blockpos * 16)
	return self[relative.x][relative.y][relative.z]
end

function Mapblock:set_node(pos, node)
	local relative = pos - (self.blockpos * 16)
	self[relative.x][relative.y][relative.z] = node
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

function Mapblock:get_meta(pos)
	local index = core.hash_node_position(pos)
	local meta = self.metas[index]
	if not meta then
		meta = NodeMetaRef(pos)
		self.metas[index] = meta
	end
	return meta
end

function Mapblock:remove_meta(pos)
	local index = core.hash_node_position(pos)
	local meta = self.metas[index]
	if meta then
		meta:_remove() -- TODO a NodeMetaRef can meaningfully persist after a node has been reset, so this is wrong
		self.metas[index] = nil
	end
end

function Mapblock:get_timer(pos)
	local index = core.hash_node_position(pos)
	local timer = self.timers[index]
	if not timer then
		timer = NodeTimerRef()
		self.timers[index] = timer
	end
	return timer
end

function Mapblock:remove_timer(pos)
	local index = core.hash_node_position(pos)
	local timer = self.timers[index]
	if not timer then
		timer:_remove() -- TODO probably a NodeTimerRef can meaningfully persist after a node has been reset, so this is wrong
		self.timers[index] = nil
	end
end

function api.get_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = api.map[index]
	if mapblock.loaded then
		return mapblock
	end
end

function api.load_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = api.map[index]

	if not mapblock then
		mapblock = Mapblock(blockpos)
		api.map[index] = mapblock
	end

	mapblock.loaded = true

	return mapblock
end

function api.unload_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = api.map[index]

	if mapblock then
		mapblock.loaded = false
	end
end

function api.remove_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = api.map[index]

	if mapblock then
		for _, meta in pairs(mapblock.metas) do
			meta:_remove()
		end
		for _, timer in pairs(mapblock.timers) do
			timer:_remove()
		end
		api.map[index] = nil
	end
end

function api.activate_mapblock(blockpos)
	local mapblock = api.load_mapblock(blockpos)
	mapblock.active = true
	for _, def in ipairs(core.registered_lbms) do
		error("TODO: implement")
		--for
	end
end

function api.deactivate_mapblock(blockpos)
	local mapblock = api.load_mapblock(blockpos)
	mapblock.active = false
end

local function validate_pos(pos)
	assert(vector.check(pos), "position must be a vector")
	api.warn_on(not vector.equals(pos, vector.floor(pos)), "coordinates of position are not integers")
	api.warn_on(not in_world_bounds(pos), "pos is outside of world")
	return vector.floor(pos)
end

local function validate_node(node)
	assert(type(node) == "table" and type(node.name) == "string", "invalid node specification")
	assert(node.param1 == nil or type(node.param1) == "number", "invalid param1")
	assert(node.param2 == nil or type(node.param2) == "number", "invalid param2")

	local def = core.registered_nodes[node.name]
	assert(def, f("%s is not a known node", node.name))
	node = t_copy(node)
	node.param1 = math.floor(node.param1 or 0) % 256 -- cast to u8
	node.param2 = math.floor(node.param2 or 0) % 256 -- cast to u8
	return node, def
end

--[[
    * Set node at position `pos`
    * `node`: table `{name=string, param1=number, param2=number}`
    * If param1 or param2 is omitted, it's set to `0`.
    * e.g. `minetest.set_node({x=0, y=10, z=0}, {name="default:wood"})`
]]
--
function core.set_node(pos, node)
	pos = validate_pos(pos)
	local new_def
	node, new_def = validate_node(node)

	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)
	if not mapblock then
		return false
	end

	local old_node = mapblock:get_node(pos)
	local old_def = core.registered_nodes[old_node.name] or {}

	if old_def.on_destruct then
		old_def.on_destruct(pos)
	end

	mapblock:remove_meta(pos) -- TODO: clear it, don't remove it
	mapblock:remove_timer(pos) -- TODO: clear it, don't remove it

	mapblock:set_node(pos, node)

	if enable_rollback_recording then
		api.record_rollback_action(
			pos,
			{ pos = pos, old = old_node.name, new = node.name, timestamp = core.get_us_time() / 1e6 }
		)
	end

	if old_def.after_destruct then
		old_def.after_destruct(pos, old_node)
	end

	if new_def.on_construct then
		new_def.on_construct(pos)
	end

	return true
end

core.add_node = core.set_node

--[[
* `minetest.add_node_level(pos, level)`
    * increase level of leveled node by level, default `level` equals `1`
    * if `totallevel > maxlevel`, returns rest (`total-max`)
    * `level` must be between -127 and 127
]]
function core.add_node_level(pos, level)
	error("TODO: implement")
end

--[[
    * Set node on all positions set in the first argument.
    * e.g. `minetest.bulk_set_node({{x=0, y=1, z=1}, {x=1, y=2, z=2}}, {name="default:stone"})`
    * For node specification or position syntax see `minetest.set_node` call
    * Faster than set_node due to single call, but still considerably slower
      than Lua Voxel Manipulators (LVM) for large numbers of nodes.
      Unlike LVMs, this will call node callbacks. It also allows setting nodes
      in spread out positions which would cause LVMs to waste memory.
      For setting a cube, this is 1.3x faster than set_node whereas LVM is 20
      times faster.
]]
function core.bulk_set_node(poss, node)
	assert(type(poss) == "table", "first argument must be a table of positions")

	local succeeded = true
	for _, pos in ipairs(poss) do
		succeeded = succeeded and core.set_node(pos, node)
	end

	return succeeded
end

function core.compare_block_status(pos, condition)
	pos = validate_pos(pos)

	if not (condition == "unknown" or condition == "emerging" or condition == "loaded" or condition == "active") then
		return
	end

	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)
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
	pos1 = validate_pos(pos1)
	pos2 = validate_pos(pos2)
	pos1, pos2 = vector.sort(pos1, pos2)
	local bp_min = vector.floor(pos1 / 16)
	local bp_max = vector.ceil(pos2 / 16)
	for blockpos in iterate_area(bp_min, bp_max) do
		api.remove_mapblock(blockpos)
	end
end

function core.dig_node(pos)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)

	if not mapblock then
		return false
	end

	local node = mapblock:get_node(pos)
	local def = core.registered_nodes[node.name] or core.registered_nodes["unknown"]

	if not def and def.on_dig then
		return false
	end
	return def.on_dig(pos, node)
end

function core.find_node_near(pos, radius, nodenames, search_center)
	pos = validate_pos(pos)
	assert(type(radius) == "number", "radius must be a number")
	if type(nodenames) == "string" then
		nodenames = { nodenames }
	else
		assert(type(nodenames) == "table")
	end
	local predicate = memoize1(function(node_name)
		for i = 1, #nodenames do
			local target = nodenames[i]

			if node_name == target then
				return true
			end

			local group = target:match("^group:(.*)$")

			if group then
				if core.get_item_group(node_name, group) > 0 then
					return true
				end
			end
		end

		return false
	end)
	if search_center then
		for p in iterate_area(pos - radius, pos + radius) do
			if predicate(core.get_node(p).name) then
				return p
			end
		end
	else
		local v_equals = vector.equals
		for p in iterate_area(pos - radius, pos + radius) do
			if not v_equals(pos, p) and predicate(core.get_node(p).name) then
				return p
			end
		end
	end
end

--[[
    * `pos1` and `pos2` are the min and max positions of the area to search.
    * `nodenames`: e.g. `{"ignore", "group:tree"}` or `"default:dirt"`
    * If `grouped` is true the return value is a table indexed by node name
      which contains lists of positions.
    * If `grouped` is false or absent the return values are as follows:
      first value: Table with all node positions
      second value: Table with the count of each node with the node name
      as index
    * Area volume is limited to 4,096,000 nodes
]]
function core.find_nodes_in_area(pos1, pos2, nodenames, grouped)
	pos1 = validate_pos(pos1)
	pos2 = validate_pos(pos2)
	pos1, pos2 = vector.sort(pos1, pos2)
	assert(volume(pos1, pos2) <= (160 ^ 3), "too large a volume")
	if type(nodenames) == "string" then
		nodenames = { nodenames }
	else
		assert(type(nodenames) == "table")
	end
	local predicate = memoize1(function(node_name)
		for i = 1, #nodenames do
			local target = nodenames[i]

			if node_name == target then
				return true
			end

			local group = target:match("^group:(.*)$")

			if group then
				if core.get_item_group(node_name, group) > 0 then
					return true
				end
			end
		end

		return false
	end)
	if grouped then
		local ps_by_name = {}
		for p in iterate_area(pos1, pos2) do
			local node_name = core.get_node(p).name
			if predicate(node_name) then
				local ps = ps_by_name[node_name]
				if not ps then
					ps = {}
					ps_by_name[node_name] = {}
				end
				ps[#ps + 1] = p
			end
		end
		return ps_by_name
	else
		local ps = {}
		local counts = {}
		for p in iterate_area(pos1, pos2) do
			local node_name = core.get_node(p).name
			if predicate(node_name) then
				ps[#ps + 1] = p
				counts[node_name] = (counts[node_name] or 0) + 1
			end
		end
		return ps, counts
	end
end

function core.find_nodes_in_area_under_air(pos1, pos2, nodenames)
	pos1 = validate_pos(pos1)
	pos2 = validate_pos(pos2)
	pos1, pos2 = vector.sort(pos1, pos2)
	assert(volume(pos1, pos2) <= (160 ^ 3), "too large a volume")
	if type(nodenames) == "string" then
		nodenames = { nodenames }
	else
		assert(type(nodenames) == "table")
	end
	local predicate = memoize1(function(node_name)
		for i = 1, #nodenames do
			local target = nodenames[i]

			if node_name == target then
				return true
			end

			local group = target:match("^group:(.*)$")

			if group then
				if core.get_item_group(node_name, group) > 0 then
					return true
				end
			end
		end

		return false
	end)

	local v_new = vector.new
	local ps = {}
	for p in iterate_area(pos1, pos2) do
		local node_name = core.get_node(p).name
		if predicate(node_name) and core.get_node(v_new(p.x, p.y + 1, p.z)).name == "air" then
			ps[#ps + 1] = p
		end
	end
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

function core.get_meta(pos)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.load_mapblock(blockpos)
	return mapblock:get_meta(pos)
end

local values = {
	{ 4250.0 + 125.0, 175.0 },
	{ 4500.0 + 125.0, 175.0 },
	{ 4750.0 + 125.0, 250.0 },
	{ 5000.0 + 125.0, 350.0 },
	{ 5250.0 + 125.0, 500.0 },
	{ 5500.0 + 125.0, 675.0 },
	{ 5750.0 + 125.0, 875.0 },
	{ 6000.0 + 125.0, 1000.0 },
	{ 6250.0 + 125.0, 1000.0 },
}

--[[
https://github.com/minetest/minetest/blob/master/src/daynightratio.h
]]
local function time_to_daynight_ratio(t, smooth)
	t = t % 24000
	if t > 12000 then
		-- sunset is a mirror of sunrise
		t = 24000 - t
	end
	if not smooth then
		local lastt = values[1][1]
		for i = 2, 9 do
			local t0 = values[i][1]
			local switch_t = (t0 + lastt) / 2
			lastt = t0
			if switch_t > t then
				return values[i][2]
			end
		end
		return 1000
	end

	if t < values[2][1] then
		return values[1][2]
	elseif t >= values[8][1] then
		return values[9][2]
	end

	for i = 2, 9 do
		if values[i][1] > t then
			local td0 = values[i][1] - values[i - 1][1]
			local ff = (t - values[i - 1][1]) / td0
			return ff * values[i][1] + (1 - ff) * values[i - 1][1]
		end
	end
end

function core.get_natural_light(pos, timeofday)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)
	if not mapblock then
		return
	end
	local node = mapblock:get_node(pos)
	local daylight = node.param1 % 16
	if daylight == 0 then
		return 0
	end
	local artificial_light = math.floor(node.param1 / 16)
	if daylight == artificial_light then
		-- TODO: if daylight is the same as artificial light, we need to find the actual value. which is complicated.
		-- daylight = find_sunlight(pos)
	end

	if timeofday then
		assert(type(timeofday) == "number")
		api.warn_on(timeofday < 0 or timeofday > 1, "timeofday should be between 0 and 1")
		timeofday = (24000 * (timeofday % 1))
	else
		timeofday = core.get_timeofday()
	end

	local dnr = time_to_daynight_ratio(timeofday, true)

	return math.floor(dnr * daylight / 1000)
end

function core.get_node(pos)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)

	if not mapblock then
		return { name = "ignore", param1 = 0, param2 = 0 }
	end

	return t_copy(mapblock:get_node(pos))
end

function core.get_node_level()
	error("TODO: implement")
end

function core.get_node_light(pos, timeofday)
	pos = validate_pos(pos)
	error("TODO: implement")
end

function core.get_node_max_level()
	error("TODO: implement")
end

function core.get_node_or_nil(pos)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)

	if mapblock then
		return t_copy(mapblock:get_node(pos))
	end
end

function core.get_node_timer(pos)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.load_mapblock(blockpos) -- TODO: load or ... ?
	return mapblock:get_timer(pos)
end

function core.get_voxel_manip(pos1, pos2)
	return VoxelManip(pos1, pos2)
end

function core.load_area(pos1, pos2)
	pos1 = validate_pos(pos1)
	if pos2 then
		pos2 = validate_pos(pos2)
	else
		pos2 = pos1
	end
	pos1, pos2 = vector.sort(pos1, pos2)
	local bp_min = vector.floor(pos1 / 16)
	local bp_max = vector.ceil(pos2 / 16)
	for blockpos in iterate_area(bp_min, bp_max) do
		api.load_mapblock(blockpos)
	end
end

function core.place_node(pos, node)
	pos = validate_pos(pos)
	local node_def
	node, node_def = validate_node(node)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)
	if not mapblock then
		return false
	end
	local old_node = mapblock:get_node(pos)
	if old_node.name == "ignore" then
		return false
	end
	local stack = ItemStack(node.name)
	local pointed_thing = {
		type = node,
		above = pos,
		below = vector.new(pos.x, pos.y - 1, pos.z),
	}
	return node_def.on_place(stack, nil, pointed_thing)
end

function core.punch_node(pos)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)
	if not mapblock then
		return false
	end
	local node = mapblock:get_node(pos)
	if node.name == "ignore" then
		return false
	end
	local stack = ItemStack(node.name)
	local def = stack:get_definition()
	if not def.on_punch then
		return false
	end
	return def.on_punch(pos, node, nil, {})
end

function core.remove_node(pos)
	pos = validate_pos(pos)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)
	if not mapblock then
		return false
	end
	local old_node = mapblock:get_node(pos)
	local def = ItemStack(old_node.name):get_definition()
	if def.on_destruct then
		def.on_destruct(pos)
	end
	mapblock:set_node(pos, { name = "air", param1 = 0, param2 = 0 })
	if def.after_destruct then
		def.after_destruct(pos, old_node)
	end

	return true
end

function core.set_node_level()
	error("TODO: implement")
end

function core.swap_node(pos, node)
	pos = validate_pos(pos)
	node = validate_node(node)
	local blockpos = vector.floor(pos / 16)
	local mapblock = api.get_mapblock(blockpos)
	if not mapblock then
		return false
	end
	mapblock:set_node(pos, node)
	return true
end

function core.transforming_liquid_add()
	error("TODO: implement")
end
