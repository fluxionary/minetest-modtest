local api = modtest.api

function core.register_alias_raw(name, convert_to)
	api.registered_alias_raws[name] = convert_to
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

	api.registered_item_raws[name] = itemdef

	if itemdef.type == "node" then
		if not api.content_id_by_name[name] then
			local next_content_id = next(api.available_content_ids)
			if not next_content_id then
				error("ran out of available node ids")
			else
				api.available_content_ids = nil
			end
		end
	end
end

function core.unregister_item_raw(name)
	local content_id = api.content_id_by_name[name]
	if content_id < 125 or content_id > 127 then
		api.registered_item_raws[name] = nil
		if content_id then
			api.content_id_by_name[name] = nil
			api.available_content_ids[content_id] = true
		end
	end
end

function core.get_content_id()
	error("TODO: implement")
end

function core.get_name_from_content_id()
	error("TODO: implement")
end
