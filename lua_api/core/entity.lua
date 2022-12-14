core.object_refs = {}
core.luaentities = {}

function core.add_entity(pos, name, staticdata)
	local object = EntityRef(pos, name)
	local def = core.registered_entities[name]
	if def then
		local initial_properties = def.initial_properties
		if initial_properties then
			object:set_properties(initial_properties)
		end
		local on_activate = def.on_activate
		if on_activate then
			local ent = object:get_luaentity()
			on_activate(ent, staticdata)
			-- TODO: do we need to pass 0 or something as dtime_s?
		end
	end
end

function core.add_item(pos, item)
	item = ItemStack(item)
	if not item:is_known() then
		return
	end
	return core.spawn_item(pos, item)
end

function core.clear_objects()
	for _, obj in pairs(core.luaentities) do
		obj:remove()
	end
end

function core.get_objects_in_area(pos1, pos2)
	local minp, maxp = vector.sort(pos1, pos2)
	local objects = {}
	for _, obj in pairs(core.object_refs) do
		if modtest.util.in_bounds(minp, obj:get_pos(), maxp) then
			objects[#objects + 1] = obj
		end
	end
	return objects
end

function core.get_objects_inside_radius(pos, radius)
	local objects = {}
	for _, obj in pairs(core.object_refs) do
		if vector.distance(pos, obj:get_pos()) <= radius then
			objects[#objects + 1] = obj
		end
	end
	return objects
end
