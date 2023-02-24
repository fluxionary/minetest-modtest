local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.storages = setmetatable({}, {
		__index = function(self, modname)
			local storage = StorageRef()
			self[modname] = storage
			return storage
		end,
	})
end, function(self, other)
	self.storages = deepcopy(other.storages)
end)

function State:clear_storage(modname)
	state.storages[modname] = nil
end
