local state = ...

function core.get_mod_storage(modname)
	return state.storages[modname]
end
