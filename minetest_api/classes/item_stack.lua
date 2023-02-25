local state = ...

local f = string.format

ItemStack = modtest.util.class1()

local function parse_itemstring(itemstring)
	if itemstring:match("^%s*$") then
		return "", 0, 0, ItemStackMetaRef()
	end

	local name, count, wear, meta
	name, count, wear, meta = itemstring:match("^(%S+) (%d+) (%d+) (.*$)$")
	if not (name and count and wear and meta) then
		name, count, wear = itemstring:match("^(%S+) (%d+) (%d+)$")
	end
	if not (name and count and wear) then
		name, count = itemstring:match("^(%S+) (%d+)$")
	end
	if not (name and count) then
		name = itemstring:match("^(%S+)$")
	end
	if not name then
		error(f("we don't know how to parse itemstring %q", itemstring))
	end
	if not wear then
		wear = 0
	end
	if not count then
		count = 1
	end
	if meta then
		meta = ItemStackMetaRef(meta)
	else
		meta = ItemStackMetaRef()
	end
	return name, count, wear, meta
end

local function is_item_stack(item)
	return (
		type(item) == "table"
		and type(item._name) == "string"
		and type(item._count) == "number"
		and type(item._wear) == "wear"
		and type(item._meta) == "table" -- close enough
	)
end

--[[
thing is itemstack, itemstring, table, or nil
]]
function ItemStack:_init(thing)
	if thing == nil then
		self._name = ""
		self._count = 0
		self._wear = 0
		self._meta = ItemStackMetaRef()
	elseif type(thing) == "string" then
		self._name, self._count, self._wear, self._meta = parse_itemstring(thing)
	elseif type(thing) == "table" then
		if thing._name and thing._count and thing._wear then
			-- another ItemStack
			self._name = thing._name
			self._count = thing._count
			self._wear = thing._wear
			self._meta = ItemStackMetaRef()
			self._meta:from_table(thing._meta:to_table())
		else
			self._name = thing.name or ""
			self._count = thing.count or 1
			self._wear = thing.wear or 0
			self._meta = ItemStackMetaRef()
			self._meta:from_table({ fields = thing.meta })
		end
	else
		error(f("invalid argument of type %s", type(thing)))
	end
end

function ItemStack:is_empty()
	return self._count == 0
end

function ItemStack:get_name()
	return self._name
end

function ItemStack:set_name(item_name)
	assert(
		type(item_name) == "string",
		f("stack name must be a string, is a %s (%s)", type(item_name), tostring(item_name))
	)

	if item_name == "" then
		self:clear()
		return false
	else
		self._name = item_name
		return true
	end
end

function ItemStack:get_count()
	return self._count
end

function ItemStack:set_count(count)
	assert(type(count) == "number", f("count must be a number, is a %s (%s)", type(count), tostring(count)))

	if count <= 0 or count >= (2 ^ 16) or count ~= math.round(count) then
		self:clear()
		return false
	else
		self._count = count
	end
end

function ItemStack:get_wear()
	return self._wear
end

function ItemStack:set_wear(wear)
	assert(type(wear) == "number", f("wear must be a number, is a %s (%s)", type(wear), tostring(wear)))

	if wear >= 65536 then
		self:clear()
		return false
	elseif wear >= 0 then
		self._wear = math.floor(wear)
		return true
	else
		-- truncates non-int part, then casts to u16
		self._wear = math.ceil(wear) % 65536
		return true
	end
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
	local description = self._meta:get("description")

	if description then
		return description
	end

	local def = self:get_definition()
	return def.description or self._name
end

--[[
order of resolution:
* `short_description` in item metadata (See [Item Metadata].)
* `short_description` in item definition
* first line of the description (From item meta or def, see `get_description()`.)
* Returns nil if none of the above are set
]]
function ItemStack:get_short_description()
	local sd = self._meta:get("short_description")
	if sd then
		return sd
	end

	-- can't use get_definition() cuz that might return definition for unknown
	local def = core.registered_items[self._name]
	if def.short_description then
		return def.short_description
	end
	sd = self._meta:get("description") or def.description

	if sd then
		-- note that this mangles translation/color strings
		-- see https://github.com/minetest/minetest/issues/12566
		return sd:match("^([^\n]+)")
	end
end

function ItemStack:clear()
	self._name = ""
	self._count = 0
	self._wear = 0
	self._meta:from_table()
end

function ItemStack:replace(item)
	if type(item) == "string" then
		self._name, self._count, self._wear, self._meta = parse_itemstring(item)
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
			self._meta:from_table()
		end
	else
		error("invalid argument")
	end
end

function ItemStack:to_string()
	local parts = { self._name }
	local count = self._count
	local wear = self._wear
	local meta = self._meta
	local has_meta = not meta:_is_empty()
	local has_wear = wear > 0 or has_meta
	local has_count = count > 1 or has_wear
	if has_count then
		parts[2] = tostring(wear)
	end
	if has_wear then
		parts[3] = tostring(wear)
	end
	if has_meta then
		parts[4] = meta:_serialize()
	end
	return table.concat(parts, " ")
end

function ItemStack:to_table()
	return {
		name = self._name,
		count = self._count,
		wear = self._wear,
		meta = self._meta:to_table().fields,
	}
end

function ItemStack:get_stack_max()
	local def = self:get_definition()
	return def.stack_max or tonumber(core.settings:get("default_stack_max"))
end

function ItemStack:get_free_space()
	local stack_max = self:get_stack_max()
	return math.max(0, stack_max - self._count)
end

function ItemStack:is_known()
	return core.registered_items[self._name] ~= nil
end

function ItemStack:get_definition()
	local def = core.registered_items[self._name]
	if not def then
		def = core.registered_items["unknown"]
		assert(def, "unknown must exist")
	end
	return def
end

function ItemStack:get_tool_capabilities()
	local meta = self._meta
	local tc_json = meta:get("tool_capabilities")

	if tc_json then
		return core.parse_json(tc_json)
	end

	local tc = self:get_definition().tool_capabilities

	if tc then
		return tc
	end

	return core.registered_items[""].tool_capabilities
		or {
			-- see tool.h
			full_punch_interval = 1.4,
			max_drop_level = 1,
			damage_groups = {},
			punch_attack_uses = 0,
			groupcaps = {},
		}
end

function ItemStack:add_wear(amount)
	local def = self:get_definition()
	if def.type == "tool" then
		self:set_wear(self._wear + amount)
		return true
	else
		return false
	end
end

function ItemStack:add_wear_by_uses(max_uses)
	self:add_wear(core.get_tool_wear_after_use(max_uses, self._wear))
end

function ItemStack:add_item(item)
	if self:is_empty() then
		self:replace(item)
		return ItemStack()
	end

	item = ItemStack(item)

	if self._name ~= item._name or self._wear ~= item._wear or self._meta ~= item._meta then
		return item
	end

	local taken = item:take_item(self:get_free_space())
	self._count = self._count + taken._count
	return item
end

function ItemStack:item_fits(item)
	if self:is_empty() then
		return true
	end

	item = ItemStack(item)
	if self._name ~= item._name or self._wear ~= item._wear or self._meta ~= item._meta then
		return false
	end

	return self:get_free_space() >= item._count
end

function ItemStack:take_item(n)
	n = n or 1
	local to_take = math.min(self._count, n)
	local remaining = self._count - to_take
	local to_return = ItemStack(self)
	to_return:set_count(to_take)
	self:set_count(remaining)
	return to_return
end

function ItemStack:peek_item(n)
	local to_return = ItemStack(self)
	to_return:set_count(math.min(self._count, n))
	return to_return
end

function ItemStack:equals(other)
	if not is_item_stack(other) then
		return false
	end
	return (
		self._name == other._name
		and self._count == other._count
		and self._wear == other._wear
		and self._meta == other._meta
	)
end

function ItemStack:__equals(other)
	return self:equals(other)
end
