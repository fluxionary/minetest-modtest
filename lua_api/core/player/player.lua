local f = string.format

local api = modtest.api

function api.create_player(player_name, password)
	if api.registered_players[player_name] then
		error(f("player %q already exists, this is likely an error", player_name))
	end
	-- TODO check blank passwords if applicable
	local static_spawnpoint = core.settings:get("static_spawnpoint")
	if static_spawnpoint then
		static_spawnpoint = core.string_to_pos(static_spawnpoint)
	else
		static_spawnpoint = vector.zero()
	end

	local auth_handler = core.get_auth_handler() -- create_auth
	auth_handler.create_auth(player_name, password)

	api.api.registered_players[player_name] = {
		meta = PlayerMetaRef(),
		inventory = InvRef({ type = "player", name = player_name }),
		pitch = 0,
		yaw = 0,
		pos = static_spawnpoint,
		hp = 20, -- TODO: this really isn't a setting or anything?!
		breath = 10, -- same here
	}
end

function api.try_join_player(name, password, connection_info)
	if api.api.connected_players[name] then
		return false, "already connected"
	end

	local default_ip
	if core.settings:get_bool("ipv6_server", false) then
		default_ip = "::1"
	else
		default_ip = "127.0.0.1"
	end

	if not connection_info then
		connection_info = { ip = default_ip }
	elseif not connection_info.ip then
		connection_info.ip = default_ip
	end

	for i = 1, #core.registered_on_prejoinplayers do
		local rv = core.registered_on_prejoinplayers[i](name, connection_info.ip)
		if rv then
			return false, rv
		end
	end

	local auth_handler = core.get_auth_handler()
	local auth_entry = auth_handler.get_auth(name)

	if not auth_entry then
		return false, "unknown player"
	end

	if not core.check_password_entry(name, auth_handler.password, password) then
		return false, "invalid password"
	end

	local persistent_data = api.api.registered_players[name]

	local is_new_player = auth_entry.last_login == nil or auth_entry.last_login == -1

	auth_handler.record_login(name)

	local player = Player(name, connection_info, persistent_data)
	api.api.connected_players[name] = player

	if is_new_player then
		for i = 1, #core.registered_on_newplayers do
			core.registered_on_newplayers[i](player)
		end
	end

	for i = 1, #core.registered_on_joinplayers do
		core.registered_on_joinplayers[i](player)
	end
end

function core.disconnect_player(name, reason)
	local player = core.get_player_by_name(name)
	if not player then
		return false
	end
	player:_disconnect(false)
	api.api.connected_players[name] = nil
	return true
end

function api.time_out_player(name)
	local player = core.get_player_by_name(name)
	if not player then
		api.warn(f("attempt to time-out a player %q who isn't connected", name))
		return false
	end
	player:_time_out()
	return true
end

function core.dynamic_add_media()
	-- this is just sending data to a client, ignore it
end

function core.connected_players()
	local players = {}
	for _, player in pairs(api.api.connected_players) do
		table.insert(players, player)
	end
	return players
end

function core.get_player_by_name(name)
	return api.api.connected_players[name]
end

function core.get_player_information(player_name)
	local player = core.get_player_by_name(player_name)
	if not player then
		return
	end
	local auth_entry = core.get_auth_handler():get_auth(player_name)
	local now = os.time() -- NOTE: we have overriden os.time
	local ci = player._connection_info
	return {
		address = ci.ip,
		ip_version = ci.ip_version or 4,
		connection_uptime = now - auth_entry.last_login,
		protocol_version = 41,
		formspec_version = 2,
		lang_code = "en",
		-- TODO: these are not guaranteed to be present, but we should figure out a way to support them somehow
		--min_rtt = 0.01,            -- minimum round trip time
		--max_rtt = 0.2,             -- maximum round trip time
		--avg_rtt = 0.02,            -- average round trip time
		--min_jitter = 0.01,         -- minimum packet time jitter
		--max_jitter = 0.5,          -- maximum packet time jitter
		--avg_jitter = 0.03,         -- average packet time jitter
	}
end

function core.get_player_ip(name)
	local player = core.get_player_by_name(name)
	if not player then
		return
	end
	local ci = player._connection_info
	return ci.ip
end

function core.get_player_privs(name)
	local auth_handler = core.get_auth_handler()
	local auth_entry = auth_handler.get_auth(name)
	if not auth_entry then
		return {}
	end
	return auth_entry.privileges
end

function core.show_formspec(playername, formname, formspec)
	local player = core.get_player_by_name(playername)
	if not player then
		return
	end
	error("TODO: implement")
end
