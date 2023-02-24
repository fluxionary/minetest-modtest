local state = ...

function core.disconnect_player(name, reason)
	local player = core.get_player_by_name(name)
	if not player then
		return false
	end
	player:_disconnect(false)
	state.connected_players[name] = nil
	return true
end

function core.dynamic_add_media()
	-- this is just sending data to a client, ignore it
end

function core.get_connected_players()
	local players = {}
	for _, player in pairs(state.connected_players) do
		table.insert(players, player)
	end
	return players
end

function core.get_player_by_name(name)
	return state.connected_players[name]
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
	player:_show_formspec(formname, formspec)
end
