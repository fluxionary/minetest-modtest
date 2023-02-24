local state = ...

local f = string.format

function core.register_alias_raw(name, convert_to)
	state.registered_alias_raws[name] = convert_to
end

function core.register_item_raw(itemdef)
	if type(itemdef.name) ~= "string" then
		error("item name is not defined or is not a string")
	end

	local name = itemdef.name

	if not itemdef.node_placement_prediction then
		if itemdef.type == "node" then
			itemdef.node_placement_prediction = name
		else
			itemdef.node_placement_prediction = ""
		end
	end

	state.registered_item_raws[name] = itemdef

	if itemdef.type == "node" then
		if not state.content_id_by_name[name] then
			local content_id = state:get_next_content_id()
			state.content_id_by_name[name] = content_id
			state.content_id_by_name[content_id] = name
		end
	end
end

function core.unregister_item_raw(name)
	local content_id = api.content_id_by_name[name]
	if content_id < 125 or content_id > 127 then
		api.registered_item_raws[name] = nil
		if content_id then
			api.content_id_by_name[name] = nil
			state.content_id_by_name[content_id] = nil
			api.available_content_ids[content_id] = true
		end
	end
end

function core.get_content_id(name)
	local content_id = api.content_id_by_name[name]
	if not content_id then
		error(f("unknown node: %q", name))
	end
	return content_id
end

function core.get_name_from_content_id(content_id)
	return state.content_id_by_name[content_id % 65536] or "unknown"
end
