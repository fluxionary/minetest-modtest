local f = string.format

local registered_players = {}
local connected_players = {}

modtest.api.registered_players = registered_players
modtest.api.connected_players = connected_players

function modtest.api.create_player(player_name, password)
	if registered_players[player_name] then
		error(f("player %q already exists, this is likely an error", player_name))
	end
	-- TODO check blank passwords if applicable
	local static_spawnpoint = core.settings:get("static_spawnpoint")
	if static_spawnpoint then
		static_spawnpoint = core.string_to_pos(static_spawnpoint)
	else
		static_spawnpoint = vector.zero()
	end

	modtest.api.registered_players[player_name] = {
		password = password,
		meta = PlayerMetaRef(),
		inventory = InvRef({ type = "player", name = player_name }),
		privileges = core.string_to_privs(core.settings:get("default_privs")),
		pitch = 0,
		yaw = 0,
		pos = static_spawnpoint,
		hp = 20, -- TODO: this really isn't a setting or anything?!
		breath = 10, -- same here
	}
end

function modtest.api.try_join_player(name, password, connection_info)
	if modtest.api.connected_players[name] then
		return false, "already connected"
	end

	for i = 1, #core.registered_on_prejoinplayers do
		local rv = core.registered_on_prejoinplayers[i](name, (connection_info or {}).ip or "127.0.0.1")
		if rv then
			return false, rv
		end
	end

	local persistent_data = modtest.api.registered_players[name]

	if not persistent_data then
		return false, "unknown player"
	end

	if persistent_data.password ~= password then
		return false
	end

	error("TODO: get pos from somewhere")

	local player = Player(name, connection_info, persistent_data)

	local last_login = persistent_data.last_login
	persistent_data.last_login = os.time()

	modtest.api.connected_players[name] = player

	if not last_login then
		for i = 1, #core.registered_on_newplayers do
			core.registered_on_newplayers[i](player)
		end
	end

	for i = 1, #core.registered_on_joinplayers do
		core.registered_on_joinplayers[i](player)
	end
end

function core.disconnect_player(name, reason)
	error("TODO: implement")
end

function modtest.api.time_out_player() end

function core.dynamic_add_media()
	error("TODO: implement")
end

function core.get_connected_players()
	local players = {}
	for _, player in pairs(modtest.api.connected_players) do
		table.insert(players, player)
	end
	return players
end

function core.get_player_by_name(name)
	return modtest.api.connected_players[name]
end

function core.get_player_information()
	error("TODO: implement")
end

function core.get_player_ip()
	error("TODO: implement")
end

function core.get_player_privs()
	error("TODO: implement")
end

function core.show_formspec()
	error("TODO: implement")
end
