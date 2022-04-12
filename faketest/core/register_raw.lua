local registered_alias_raws = {}

function core.register_alias_raw(name, convert_to)
	registered_alias_raws[name] = convert_to
end

local registered_item_raws = {}

function core.register_item_raw(itemdef)
	registered_item_raws[itemdef.name] = itemdef
end

function core.unregister_item_raw(name)
	registered_item_raws[name] = nil
end
