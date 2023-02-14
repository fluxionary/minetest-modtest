local f = string.format

local api = modtest.api

core.auth = {}

--[[
{
	name = name,
	password = password,
	privileges = privileges,
	last_login = -1,
}
]]
function core.auth.create(auth_entry)
	assert(type(auth_entry) == "table")
	assert(type(auth_entry.name) == "string")
	assert(type(auth_entry.password) == "string")
	local name = auth_entry.name
	assert(not api.auth_entries[name], f("%s already exists", name))
	api.auth_entries[name] = table.copy(auth_entry)
end

function core.auth.delete(name)
	assert(type(name) == "string")
	assert(api.auth_entries[name])
	api.auth_entries[name] = nil
end

function core.auth.list_names()
	local names = {}
	for name in pairs(api.auth_entries) do
		names[#names + 1] = name
	end
	return names
end

function core.auth.read(name)
	assert(type(name) == "string")
	local auth_entry = api.auth_entries[name]
	if auth_entry then
		return table.copy(auth_entry)
	end
end

function core.auth.reload()
	-- do nothing
end

function core.auth.save(auth_entry)
	assert(type(auth_entry) == "table")
	assert(type(auth_entry.name) == "string")
	assert(type(auth_entry.password) == "string")
	local name = auth_entry.name
	assert(api.auth_entries[name], f("%s doesn't exists", name))
	modtest.util.set_all(api.auth_entries[name], auth_entry)
end

function core.check_password_entry(name, entry, password)
	assert(type(name) == "string")
	assert(type(entry) == "string")
	assert(type(password) == "string")
	return entry == core.get_password_hash(name, password)
end

function core.get_password_hash(name, raw_password)
	return raw_password
end

function core.notify_authentication_modified(name)
	-- all this does is notify clients that they now have fast/fly/noclip etc.
end

function core.remove_player(name)
	assert(type(name) == "string")
	local player = core.get_player_by_name(name)

	if not player then
		if api.auth_entries[name] then
			api.auth_entries[name] = nil
			return 0
		end
		return 1
	end
	return 2
end
