NodeMetaRef = modtest.util.class1(MetaDataRef)

modtest.util.check_removed(NodeMetaRef)

function NodeMetaRef:_init(pos)
	MetaDataRef.__init(self)
	self._pos = pos
	self._inventory = InvRef({ type = "node", pos = pos })
	self._private = {}
end

function NodeMetaRef:_remove()
	self._inventory:_remove()
	MetaDataRef._remove(self)
end

function NodeMetaRef:get_inventory()
	return self._inventory
end

function NodeMetaRef:mark_as_private(keys)
	if type(keys) == "string" then
		self._private[keys] = true
	else
		for _, key in ipairs(keys) do
			self._private[key] = true
		end
	end
end

function NodeMetaRef:set_string(key, value)
	MetaDataRef.set_string(self, key, value)
	if self._table[key] == nil then
		self._private[key] = nil
	end
end

function NodeMetaRef:to_table()
	local t = MetaDataRef.to_table(self)
	t.inventory = self._inventory.to_table()
	return t
end

function NodeMetaRef:from_table(t)
	MetaDataRef.from_table(self, t)
	self._inventory.from_table(t.inventory)
end
