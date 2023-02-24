local State = ...

local f = string.format

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	-- # player_ref
	self.registered_on_shown_formspecs = {}

	-- # player/auth
	self.auth_entries = {}

	-- # player/player
	self.registered_players = {}
	self.connected_players = {}
end, function(self, other)
	self.registered_on_shown_formspecs = deepcopy(other.registered_on_shown_formspecs)
	self.auth_entries = deepcopy(other.auth_entries)
	self.registered_players = deepcopy(other.registered_players)
	self.connected_players = deepcopy(other.connected_players)
end)

function State:create_player(player_name, password)
	if self.registered_players[player_name] then
		error(f("player %q already exists, this is likely an error", player_name))
	end

	local static_spawnpoint = core.string_to_pos(core.settings:get("static_spawnpoint")) or vector.zero()

	local auth_handler = core.get_auth_handler() -- create_auth
	-- TODO check blank passwords if applicable
	auth_handler.create_auth(player_name, password)

	self.registered_players[player_name] = {
		meta = PlayerMetaRef(),
		inventory = InvRef({ type = "player", name = player_name }),
		pitch = 0,
		yaw = 0,
		pos = static_spawnpoint,
		hp = 20, -- TODO: this really isn't a setting or anything?!
		breath = 10, -- same here
	}
end

function State:try_join_player(name, password, connection_info)
	if self.connected_players[name] then
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

	if not core.check_password_entry(name, auth_entry.password, password) then
		return false, "invalid password"
	end

	local persistent_data = self.registered_players[name]

	local is_new_player = auth_entry.last_login == nil or auth_entry.last_login == -1

	auth_handler.record_login(name)

	assert(vector.check(persistent_data.pos), dump(persistent_data))
	local player = Player(name, connection_info, persistent_data)
	self.connected_players[name] = player

	if is_new_player then
		for i = 1, #core.registered_on_newplayers do
			core.registered_on_newplayers[i](player)
		end
	end

	for i = 1, #core.registered_on_joinplayers do
		core.registered_on_joinplayers[i](player)
	end

	return player
end

function State:time_out_player(name)
	local player = core.get_player_by_name(name)
	if not player then
		modtest.warn(f("attempt to time-out a player %q who isn't connected", name))
		return false
	end
	player:_time_out()
	return true
end

function State:register_on_shown_formspec(callback)
	self.registered_on_shown_formspecs[#self.registered_on_shown_formspecs + 1] = callback
end
