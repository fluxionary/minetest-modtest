modtest.api.player_inventories = {}
modtest.api.node_inventories = {}
modtest.api.detached_inventories = {}

function core.create_detached_inventory_raw(name, player_name)
	local inv = modtest.api.detached_inventories[name]
	if inv then
		return inv
	end
	return InvRef({ type = "detached", name = name }) -- adds itself from the above table
end

function core.remove_detached_inventory_raw(name)
	local inv = modtest.api.detached_inventories[name]
	if inv then
		inv:_remove() -- removes itself from the above table
	end
end

function core.get_inventory(location)
	if location.type == "player" then
		return modtest.api.player_inventories[location.name]
	elseif location.type == "node" then
		return modtest.api.node_inventories[core.hash_node_position(location.pos)]
	elseif location.type == "detached" then
		return modtest.api.detached_inventories[location.name]
	end
end
