local state = ...

function core.create_detached_inventory_raw(name, player_name)
	local inv = state.detached_inventories[name]
	if inv then
		return inv
	end
	return InvRef({ type = "detached", name = name }) -- adds itself from the above table
end

function core.remove_detached_inventory_raw(name)
	local inv = state.detached_inventories[name]
	if inv then
		inv:_remove() -- removes itself from the above table
	end
end

function core.get_inventory(location)
	if location.type == "player" then
		return state.player_inventories[location.name]
	elseif location.type == "node" then
		return state.node_inventories[core.hash_node_position(location.pos)]
	elseif location.type == "detached" then
		return state.detached_inventories[location.name]
	end
end
