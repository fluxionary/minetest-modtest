local state = ...

MapBlock = modtest.util.class1()

function MapBlock:_init(blockpos)
	self.blockpos = blockpos

	for x = 0, 15 do
		local panel = {}
		for y = 0, 15 do
			local column = {}
			for z = 0, 15 do
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

	-- time of last deactivation. nil means "hasn't been active yet"
	self.timestamp = nil

	-- set of run-once LBM names
	self.lbms_run = {}
end

function MapBlock:get_node(pos)
	local relative = pos - (self.blockpos * 16)
	assert(0 <= relative.x and relative.x <= 15)
	assert(0 <= relative.y and relative.y <= 15)
	assert(0 <= relative.z and relative.z <= 15)
	return self[relative.x][relative.y][relative.z]
end

function MapBlock:set_node(pos, node)
	local relative = pos - (self.blockpos * 16)
	assert(0 <= relative.x and relative.x <= 15)
	assert(0 <= relative.y and relative.y <= 15)
	assert(0 <= relative.z and relative.z <= 15)
	self[relative.x][relative.y][relative.z] = node
end

function MapBlock:iter_nodes(filter)
	local p1 = self.blockpos * 16
	local p2 = vector.add(p1, 15)
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

function MapBlock:get_meta(pos)
	local index = core.hash_node_position(pos)
	local meta = self.metas[index]
	if not meta then
		meta = NodeMetaRef(pos)
		self.metas[index] = meta
	end
	return meta
end

function MapBlock:remove_meta(pos)
	local index = core.hash_node_position(pos)
	local meta = self.metas[index]
	if meta then
		meta:_remove() -- TODO a NodeMetaRef can meaningfully persist after a node has been reset, so this is wrong
		self.metas[index] = nil
	end
end

function MapBlock:get_timer(pos)
	local index = core.hash_node_position(pos)
	local timer = self.timers[index]
	if not timer then
		timer = NodeTimerRef()
		self.timers[index] = timer
	end
	return timer
end

function MapBlock:remove_timer(pos)
	local index = core.hash_node_position(pos)
	local timer = self.timers[index]
	if timer then
		timer:_remove() -- TODO probably a NodeTimerRef can meaningfully persist after a node has been reset, so this is wrong
		self.timers[index] = nil
	end
end
