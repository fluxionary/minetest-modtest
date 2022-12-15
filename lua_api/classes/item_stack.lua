ItemStack = modtest.util.class1()

local function parse_itemstring(itemstring)
	local name, count, wear
	name, count, wear = itemstring:match("^(%S+) (%d+) (%d+)$")
	if not (name and count and wear) then
		name, count = itemstring:match("^(%S+) (%d+)$")
	end
	if not (name and count) then
		name = itemstring:match("^(%S+)$")
	end
	if not name then
		error(("we don't know how to parse itemstring %q"):format(itemstring))
	end
	if not wear then
		wear = 0
	end
	if not count then
		count = 1
	end
	return name, count, wear
end

--[[
thing is itemstack, itemstring, table, or nil
]]
function ItemStack:_init(thing)
	self._meta = ItemStackMetaRef()

	if thing == nil then
		self._name = ""
		self._count = 0
		self._wear = 0
	elseif type(thing) == "string" then
		self._name, self._count, self._wear = parse_itemstring(thing)
	elseif type(thing) == "table" then
		if thing._name and thing._count and thing._wear then
			self._name = thing._name
			self._count = thing._count
			self._wear = thing._wear
			self._meta:from_table(thing._meta:to_table())
		else
			self._name = thing.name or ""
			self._count = thing.count or 1
			self._wear = thing.wear or 0
		end
	else
		error("invalid argument")
	end
end

function ItemStack:is_empty()
	return self._count == 0
end

function ItemStack:get_name()
	return self._name
end

function ItemStack:set_name(item_name)
	self._name = item_name
	return item_name == ""
end

function ItemStack:get_count()
	return self._count
end

function ItemStack:set_count(count)
	if count < 0 or count >= (2 ^ 16) or count ~= math.round(count) then
		error("ItemStack: invalid count")
	end
	self._count = count
end

function ItemStack:get_wear()
	return self._wear
end

function ItemStack:set_wear(wear)
	if wear < 0 or wear >= (2 ^ 16) or wear ~= math.round(wear) then
		error("ItemStack: invalid wear")
	end
	self._wear = wear
end

function ItemStack:get_meta()
	return self._meta
end

function ItemStack:get_metadata()
	error("TODO: implement")
end

function ItemStack:set_metadata(metadata)
	error("TODO: implement")
end

function ItemStack:get_description()
	local def = core.registered_items[self._name] or {}
	return self._meta.description or def.description or self._name
end

function ItemStack:get_short_description()
	local def = core.registered_items[self._name] or {}
	local sd = self._meta.short_description or def.short_description or self:get_description()
	return sd:match("^([^\n]+)")
end

function ItemStack:clear()
	self._name = ""
	self._count = 0
	self._wear = 0
	self._meta.from_table()
end

function ItemStack:replace(item)
	if type(item) == "string" then
		self._name, self._count, self._wear = parse_itemstring(item)
		self._meta.from_table()
	elseif type(item) == "table" then
		if item._name and item._count and item._wear then
			self._name = item._name
			self._count = item._count
			self._wear = item._wear
			self._meta:from_table(item._meta:to_table())
		else
			self._name = item.name or ""
			self._count = item.count or 1
			self._wear = item.wear or 0
			self._meta.from_table()
		end
	else
		error("invalid argument")
	end
end

function ItemStack:to_string()
	error("have to serialize metadata :/")
end

function ItemStack:to_table()
	error("TODO: implement")
end

function ItemStack:get_stack_max()
	error("TODO: implement")
end

function ItemStack:get_free_space()
	error("TODO: implement")
end

function ItemStack:is_known()
	error("TODO: implement")
end

function ItemStack:get_definition()
	error("TODO: implement")
end

function ItemStack:get_tool_capabilities()
	error("TODO: implement")
end

function ItemStack:add_wear(amount)
	error("TODO: implement")
end

function ItemStack:add_wear_by_uses(max_uses)
	error("TODO: implement")
end

function ItemStack:add_item(item)
	error("TODO: implement")
end

function ItemStack:item_fits(item)
	error("TODO: implement")
end

function ItemStack:take_item(n)
	error("TODO: implement")
end

function ItemStack:peek_item(n)
	error("TODO: implement")
end

function ItemStack:equals(other)
	error("TODO: implement")
end

function ItemStack:__equals(other)
	error("TODO: implement")
end
