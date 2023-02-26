local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.map = {}
end, function(self, other)
	self.map = deepcopy(other.map)
end)

function State:clear_map()
	self.map = {}
end

function State:get_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = self.map[index]
	if mapblock and mapblock.loaded then
		return mapblock
	end
end

function State:load_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = self.map[index]

	if not mapblock then
		mapblock = MapBlock(blockpos)
		self.map[index] = mapblock
	end

	mapblock.loaded = true

	return mapblock
end

function State:unload_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = self.map[index]

	if mapblock then
		if mapblock.active then
			self:deactivate_mapblock(blockpos)
		end
		mapblock.loaded = false
	end
end

function State:remove_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = self.map[index]

	if mapblock then
		for _, meta in pairs(mapblock.metas) do
			meta:_remove()
		end
		for _, timer in pairs(mapblock.timers) do
			timer:_remove()
		end
		self.map[index] = nil
	end
end

function State:_create_lbm_filter(lbm_def)
	local nodefilter = {}
	assert(type(lbm_def.nodenames) == "table", dump(lbm_def):gsub("%s+", ""))

	for _, nodename in ipairs(lbm_def.nodenames) do
		local group = nodename:match("^group:(.*)$")
		if group then
			for _, name in ipairs(self:_get_all_items_in_group(group)) do
				nodefilter[name] = true
			end
		else
			nodefilter[nodename] = true
		end
	end
	return function(node)
		return nodefilter[node.name]
	end
end

-- i don't see any use in ensuring that a block was already loaded if we want to activate it. so load it if it's not.
function State:activate_mapblock(blockpos)
	local mapblock = self:load_mapblock(blockpos)
	if mapblock.active then
		-- already active, do nothing
		return
	end

	local dtime_s = 0 -- near as i can tell, dtime_s is 0 if the mapblock has never been active
	if mapblock.timestamp then
		dtime_s = (core.get_us_time() - mapblock.timestamp) / 1e6
	end

	mapblock.active = true

	for _, lbm_def in ipairs(core.registered_lbms) do
		if lbm_def.run_at_every_load or not mapblock.lbms_run[lbm_def.name] then
			local action = lbm_def.action
			local filter = self:_create_lbm_filter(lbm_def)
			for pos, node in mapblock:iter_nodes(filter) do
				action(pos, node, dtime_s)
			end
			if not lbm_def.run_at_every_load then
				mapblock.lbms_run[lbm_def.name] = true
			end
		end
	end
end

function State:deactivate_mapblock(blockpos)
	local mapblock = State:load_mapblock(blockpos)
	mapblock.active = false
	mapblock.timestamp = core.get_us_time()
end
