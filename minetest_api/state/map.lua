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
		mapblock = Mapblock(blockpos)
		self.map[index] = mapblock
	end

	mapblock.loaded = true

	return mapblock
end

function State:unload_mapblock(blockpos)
	local index = core.hash_node_position(blockpos)
	local mapblock = self.map[index]

	if mapblock then
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

function State:activate_mapblock(blockpos)
	local mapblock = State:load_mapblock(blockpos)
	mapblock.active = true
	for _, def in ipairs(core.registered_lbms) do
		error("TODO: implement")
		--for
	end
end

function State:deactivate_mapblock(blockpos)
	local mapblock = State:load_mapblock(blockpos)
	mapblock.active = false
end
