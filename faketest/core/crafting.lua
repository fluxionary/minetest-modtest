local registered_crafts = {}

function core.register_craft(def)
	table.insert(registered_crafts, def)
end
