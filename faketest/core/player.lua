local f = string.format

local registered_players = {}
local connected_players = {}

modtest.core.registered_players = registered_players
modtest.core.connected_players = connected_players

function modtest.core.create_player(name, password)
	if registered_players[name] then
		error(f("player %q already exists, this is likely an error", name))
	end
	-- TODO check blank passwords if applicable
	modtest.core.registered_players[name] = { password = password }
end

function modtest.core.try_join_player(name, password, connection_info)
	if modtest.core.connected_players[name] then
		return false, "already connected"
	end

	for i = 1, #core.registered_on_prejoinplayers do
		local rv = core.registered_on_prejoinplayers[i](name, (connection_info or {}).ip or "127.0.0.1")
		if rv then
			return false, rv
		end
	end

	local auth_info = modtest.core.registered_players[name]

	if not auth_info then
		return false, "unknown player"
	end

	if auth_info.password ~= password then
		return false
	end

	local player = Player(name, auth_info, connection_info)

	local last_login = auth_info.last_login
	auth_info.last_login = os.time()

	modtest.core.connected_players[name] = player

	if not last_login then
		for i = 1, #core.registered_on_newplayers do
			core.registered_on_newplayers[i](player)
		end
	end

	for i = 1, #core.registered_on_joinplayers do
		core.registered_on_joinplayers[i](player)
	end
end
