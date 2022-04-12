ItemStack = modtest.util.make_class()

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
function ItemStack:__init(thing)
	self.__meta = ItemStackMetaRef()

	if thing == nil then
		self.__name = ""
		self.__count = 0
		self.__wear = 0

	elseif type(thing) == "string" then
		self.__name, self.__count, self.__wear = parse_itemstring(thing)

	elseif type(thing) == "table" then
		if thing.__name and thing.__count and thing.__wear then
			self.__name = thing.__name
			self.__count = thing.__count
			self.__wear = thing.__wear
			self.__meta:from_table(thing.__meta:to_table())
		else
			self.__name = thing.name or ""
			self.__count = thing.count or 1
			self.__wear = thing.wear or 0
		end
	else
		error("invalid argument")
	end
end

function ItemStack:is_empty()
	return self.__count == 0
end

function ItemStack:get_name()
	return self.__name
end

function ItemStack:set_name(item_name)
	self.__name = item_name
	return item_name == ""
end

function ItemStack:get_count()
	return self.__count
end

function ItemStack:set_count(count)
	if count < 0 or count >= (2^16) or count ~= math.round(count) then
		error("ItemStack: invalid count")
	end
	self.__count = count
end

function ItemStack:get_wear()
	return self.__wear
end

function ItemStack:set_wear(wear)
	if wear < 0 or wear >= (2^16) or wear ~= math.round(wear) then
		error("ItemStack: invalid wear")
	end
	self.__wear = wear
end

function ItemStack:get_meta()
	return self.__meta
end

function ItemStack:get_description()
	local def = core.registered_items[self.__name] or {}
	return self.__meta.description or def.description or self.__name
end

function ItemStack:get_short_description()
	local def = core.registered_items[self.__name] or {}
	local sd = 	self.__meta.short_description or def.short_description or self:get_description()
	return sd:match("^([^\n]+)")
end

function ItemStack:clear()
	self.__name = ""
	self.__count = 0
	self.__wear = 0
	self.__meta.from_table()
end

function ItemStack:replace(item)
	if type(item) == "string" then
		self.__name, self.__count, self.__wear = parse_itemstring(item)
		self.__meta.from_table()

	elseif type(item) == "table" then
		if item.__name and item.__count and item.__wear then
			self.__name = item.__name
			self.__count = item.__count
			self.__wear = item.__wear
			self.__meta:from_table(item.__meta:to_table())
		else
			self.__name = item.name or ""
			self.__count = item.count or 1
			self.__wear = item.wear or 0
			self.__meta.from_table()
		end
	else
		error("invalid argument")
	end
end

function ItemStack:to_string()
	error("have to serialize metadata :/")
end
