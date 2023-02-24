local state = ...

local f = string.format

InvRef = modtest.util.class1()

modtest.util.check_removed(InvRef)

function InvRef:_init(location)
	self._location = location
	if location.type == "player" then
		if state.player_inventories[location.name] then
			error(f("player inventory already exists for %s", location.name))
		end
		state.player_inventories[location.name] = self
	elseif location.type == "node" then
		local pos_hash = core.hash_node_position(location.pos)
		if state.node_inventories[pos_hash] then
			error(f("node inventory already exists for %s", core.pos_to_string(location.pos)))
		end
		state.node_inventories[pos_hash] = self
	elseif location.type == "detached" then
		if state.detached_inventories[location.name] then
			error(f("detached inventory already exists for %s", location.name))
		end
		state.detached_inventories[location.name] = self
	else
		error(f("invalid inventory location type %s", location.type))
	end
	self._lists = {}
end

function InvRef:_remove()
	local location = self._location
	local invtype = location.type
	if invtype == "player" then
		state.player_inventories[location.name] = nil
	elseif invtype == "node" then
		state.node_inventories[core.hash_node_position(location.pos)] = nil
	elseif invtype == "detached" then
		state.detached_inventories[location.name] = nil
	end
	self._removed = true
end

function InvRef:is_empty(listname)
	local list = self._lists[listname]
	if not list then
		return true
	end
	for _, stack in ipairs(list) do
		if not stack:is_empty() then
			return false
		end
	end
	return true
end

function InvRef:get_size(listname)
	local list = self._lists[listname]
	if not list then
		return 0
	end
	return #list
end

function InvRef:set_size(listname, size)
	if size == 0 then
		self._lists[listname] = nil
		return
	end

	local list = self._lists[listname] or {}

	while #list < size do
		list[#list + 1] = ItemStack()
	end

	for i = size + 1, #list do
		list[i] = nil
	end

	self._lists[listname] = list
end

function InvRef:get_width(listname)
	local list = self._lists[listname] or {}
	return list.width or 0
end

function InvRef:set_width(listname, width)
	local list = self._lists[listname] or {}
	list.width = width
	self._lists[listname] = list
end

function InvRef:get_stack(listname, i)
	local list = self._lists[listname]
	if not list or i > #list then
		return ItemStack()
	end
	return ItemStack(list[i])
end

function InvRef:set_stack(listname, i, stack)
	local list = self._lists[listname]
	if not list or i > #list then
		return false
	end
	list[i] = ItemStack(stack)
	return true
end

function InvRef:get_list(listname)
	local list = self._lists[listname]
	if not list then
		return
	end
	local stacks = {}
	for _, stack in ipairs(list) do
		table.insert(stacks, ItemStack(stack))
	end
	return stacks
end

function InvRef:set_list(listname, list)
	local ourlist = self._lists[listname]
	if not ourlist then
		return
	end

	for i = 1, math.min(#ourlist, #list) do
		ourlist[i] = ItemStack(list[i])
	end
end

function InvRef:get_lists()
	local lists = {}
	for listname in pairs(self._lists) do
		lists[listname] = self:get_list(listname)
	end
	return lists
end

function InvRef:set_lists(lists)
	for listname, list in pairs(lists) do
		self:set_list(listname, list)
	end
end

-- add item somewhere in list, returns leftover `ItemStack`.
function InvRef:add_item(listname, stack)
	local list = self._lists[listname]
	stack = ItemStack(stack)
	if not list then
		return stack
	end

	for _, our_stack in ipairs(list) do
		stack = our_stack:add_item(stack)
		if stack:is_empty() then
			break
		end
	end

	return stack
end

-- returns `true` if the stack of items can be fully added to the list
function InvRef:room_for_item(listname, stack)
	local list = self._lists[listname]
	if not list then
		return false
	end

	stack = ItemStack(stack)
	local copy = table.copy(list)
	for _, our_stack in ipairs(copy) do
		stack = our_stack:add_item(stack)
		if stack:is_empty() then
			break
		end
	end

	return stack:is_empty()
end

-- take as many items as specified from the list, returns the items that were actually removed (as an `ItemStack`)
-- note that any item metadata is ignored, so attempting to remove a specific unique item this way will likely remove
-- the wrong one -- to do that use `set_stack` with an empty `ItemStack`.
function InvRef:remove_item(listname, stack)
	local removed = ItemStack()
	stack = ItemStack(stack)

	local list = self._lists[listname]
	if not list or stack:is_empty() then
		return removed
	end

	local name = stack:get_name()
	local count_remaining = stack:get_count()
	local taken = 0

	for _, our_stack in ipairs(list) do
		if our_stack:get_name() == name then
			local n = our_stack:take_item(count_remaining):get_count()
			count_remaining = count_remaining - n
			taken = taken + n
		end

		if count_remaining == 0 then
			break
		end
	end

	stack:set_count(taken)

	return stack
end

-- returns `true` if the stack of items can be fully taken from the list.
-- If `match_meta` is false, only the items' names are compared (default: `false`).
function InvRef:contains_item(listname, stack, match_meta)
	local list = self._lists[listname]
	if not list then
		return false
	end

	stack = ItemStack(stack)

	if match_meta then
		local name = stack:get_name()
		local wear = stack:get_wear()
		local meta = stack:get_meta()
		local needed_count = stack:get_count()

		for _, our_stack in ipairs(list) do
			if our_stack:get_name() == name and our_stack:get_wear() == wear and our_stack:get_meta():equals(meta) then
				local n = our_stack:peek_item(needed_count):get_count()
				needed_count = needed_count - n
			end
			if needed_count == 0 then
				break
			end
		end

		return needed_count == 0
	else
		local name = stack:get_name()
		local needed_count = stack:get_count()

		for _, our_stack in ipairs(list) do
			if our_stack:get_name() == name then
				local n = our_stack:peek_item(needed_count):get_count()
				needed_count = needed_count - n
			end
			if needed_count == 0 then
				break
			end
		end

		return needed_count == 0
	end
end

function InvRef:get_location()
	return table.copy(self._location)
end
