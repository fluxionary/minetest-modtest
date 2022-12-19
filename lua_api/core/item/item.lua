modtest.api.registered_alias_raws = {}

function core.register_alias_raw(name, convert_to)
	modtest.api.registered_alias_raws[name] = convert_to
end

modtest.api.registered_item_raws = {}
modtest.api.content_id_by_name = {}
modtest.api.available_content_ids = {}
modtest.api.available_unknown_content_ids = {}

for i = 0, 32767 do
	if i < 125 or i > 127 then
		modtest.api.available_content_ids[i] = true
	end
end

modtest.api.content_id_by_name["unknown"] = 125
modtest.api.content_id_by_name["air"] = 126
modtest.api.content_id_by_name["ignore"] = 127

for i = 32768, 65535 do
	modtest.api.available_unknown_content_ids[i] = true
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

	modtest.api.registered_item_raws[name] = itemdef

	if itemdef.type == "node" then
		if not modtest.api.content_id_by_name[name] then
			local next_content_id = next(modtest.api.available_content_ids)
			if not next_content_id then
				error("ran out of available node ids")
			else
				modtest.api.available_content_ids = nil
			end
		end
	end
end

function core.unregister_item_raw(name)
	local content_id = modtest.api.content_id_by_name[name]
	if content_id < 125 or content_id > 127 then
		modtest.api.registered_item_raws[name] = nil
		if content_id then
			modtest.api.content_id_by_name[name] = nil
			modtest.api.available_content_ids[content_id] = true
		end
	end
end

function core.get_content_id()
	error("TODO: implement")
end

function core.get_name_from_content_id()
	error("TODO: implement")
end
