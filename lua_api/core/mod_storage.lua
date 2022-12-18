local storages = setmetatable({}, {
	__index = function(self, modname)
		local storage = StorageRef()
		self[modname] = storage
		return storage
	end,
})

function modtest.api.clear_storage(modname)
	storages[modname] = nil
end

function core.get_mod_storage(modname)
	return storages[modname]
end
