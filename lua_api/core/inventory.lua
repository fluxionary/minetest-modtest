local api = modtest.api

function core.create_detached_inventory_raw(name, player_name)
	local inv = api.detached_inventories[name]
	if inv then
		return inv
	end
	return InvRef({ type = "detached", name = name }) -- adds itself from the above table
end

function core.remove_detached_inventory_raw(name)
	local inv = api.detached_inventories[name]
	if inv then
		inv:_remove() -- removes itself from the above table
	end
end

function core.get_inventory(location)
	if location.type == "player" then
		return api.player_inventories[location.name]
	elseif location.type == "node" then
		return api.node_inventories[core.hash_node_position(location.pos)]
	elseif location.type == "detached" then
		return api.detached_inventories[location.name]
	end
end
