NodeMetaRef = modtest.util.make_class(MetaDataRef)

function NodeMetaRef:_init(pos)
	MetaDataRef.__init(self)
	self.__pos = pos
	self.__inventory = InvRef({ type = "node", pos = pos })
	self.__private = {}
end

function NodeMetaRef:get_inventory()
	return self.__inventory
end

function NodeMetaRef:mark_as_private(keys)
	if type(keys) == "string" then
		self.__private[keys] = true
	else
		for _, key in ipairs(keys) do
			self.__private[key] = true
		end
	end
end

function NodeMetaRef:set_string(key, value)
	MetaDataRef.set_string(self, key, value)
	if self.__table[key] == nil then
		self.__private[key] = nil
	end
end

function NodeMetaRef:to_table()
	local t = MetaDataRef.to_table(self)
	t.inventory = self.__inventory.to_table()
	return t
end

function NodeMetaRef:from_table(t)
	MetaDataRef.from_table(self, t)
	self.__inventory.from_table(t.inventory)
end
