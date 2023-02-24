local state = ...

local set_all = modtest.util.set_all
local is_valid_colorspec = modtest.util.is_valid_colorspec
local is_frame_index = modtest.util.is_frame_index
local normalize_colorspec = modtest.util.normalize_colorspec
local is_non_negative_number = modtest.util.is_non_negative_number
----

Player = modtest.util.class1(ObjectRef)

modtest.util.check_removed(Player)

local player_control_bits = {
	up = 2 ^ 0,
	down = 2 ^ 1,
	left = 2 ^ 2,
	right = 2 ^ 3,
	jump = 2 ^ 4,
	aux1 = 2 ^ 5,
	sneak = 2 ^ 6,
	dig = 2 ^ 7,
	place = 2 ^ 8,
	zoom = 2 ^ 9,
	LMB = 0,
	RMB = 0,
}

function Player:_init(name, connection_info, persistent_data)
	ObjectRef._init(self, persistent_data.pos)
	self._player_name = name
	self._connection_info = connection_info
	self._persistent_data = persistent_data

	self._fov = { 0, false, 0 }
	self._inventory_formspec = "size[8,7.5]list[current_player;main;0,3.5;8,4;]list[current_player;craft;3,0;3,3;]"
		.. "listring[]list[current_player;craftpreview;7,1;1,1;]"
	self._formspec_prepend = ""
	self._player_control = {
		up = false,
		down = false,
		left = false,
		right = false,
		jump = false,
		aux1 = false,
		sneak = false,
		dig = false,
		place = false,
		LMB = false,
		RMB = false,
		zoom = false,
	}
	self._physics_override = {
		speed = 1,
		jump = 1,
		gravity = 1,
		sneak = true,
		new_move = true,
		sneak_glitch = false,
	}
	self._next_hud_id = 1
	self._huds = {}
	self._hud_flags = {
		basic_debug = false,
		breathbar = true,
		crosshair = true,
		healthbar = true,
		hotbar = true,
		minimap = false,
		minimap_radar = false,
		wielditem = true,
	}
	self._hotbar_itemcount = 8
	self._hotbar_image = ""
	self._hotbar_selected_image = ""
	self._sky = {
		base_color = {
			r = 255,
			g = 255,
			b = 255,
			a = 255,
		},
		type = "regular",
		textures = {},
		clouds = true,
		sky_color = {
			fog_tint_type = "default",
			fog_sun_tint = {
				r = 244,
				g = 125,
				b = 29,
				a = 255,
			},
			fog_moon_tint = {
				r = 128,
				g = 153,
				b = 204,
				a = 255,
			},
			day_sky = {
				r = 97,
				g = 181,
				b = 245,
				a = 255,
			},
			day_horizon = {
				r = 144,
				g = 211,
				b = 246,
				a = 255,
			},
			dawn_sky = {
				r = 180,
				g = 186,
				b = 250,
				a = 255,
			},
			dawn_horizon = {
				r = 186,
				g = 193,
				b = 240,
				a = 255,
			},
			night_sky = {
				r = 0,
				g = 107,
				b = 255,
				a = 255,
			},
			night_horizon = {
				r = 64,
				g = 144,
				b = 255,
				a = 255,
			},
			indoors = {
				r = 100,
				g = 100,
				b = 100,
				a = 255,
			},
		},
	}
	self._sun = {
		sunrise_visible = true,
		scale = 1,
		visible = true,
		texture = "sun.png",
		tonemap = "sun_tonemap.png",
		sunrise = "sunrisebg.png",
	}
	self._moon = {
		scale = 1,
		tonemap = "moon_tonemap.png",
		visible = true,
		texture = "moon.png",
	}
	self._stars = {
		scale = 1,
		visible = true,
		count = 1000,
		star_color = {
			r = 235,
			g = 235,
			b = 255,
			a = 105,
		},
		day_opacity = 0,
	}
	self._clouds = {
		color = {
			r = 240,
			g = 240,
			b = 255,
			a = 229,
		},
		density = 0.40000000596046,
		ambient = {
			r = 0,
			g = 0,
			b = 0,
			a = 255,
		},
		height = 120,
		thickness = 16,
		speed = {
			y = -2,
			x = 0,
		},
	}
	self._local_animation = {
		{ y = 0, x = 0 },
		{ y = 0, x = 0 },
		{ y = 0, x = 0 },
		{ y = 0, x = 0 },
		0,
	}
	self._eye_offset_firstperson = vector.zero()
	self._eye_offset_thirdperson = vector.zero()
	self._lighting = {
		shadows = {
			intensity = 0,
		},
	}

	self._wield_index = 1

	self._timed_out = false

	self._chat_log = {}
end

-- internal functions

function Player:_receive_chat(message)
	table.insert(self._chat_log, message)
end

function Player:_is_timed_out()
	return self._timed_out
end

function Player:_time_out()
	self._timed_out = true
end

function Player:_disconnect(timed_out)
	for _, callback in core.registered_on_leaveplayers do
		callback(self, timed_out)
	end
	core.object_refs[self._id] = nil
	-- TODO: inventory persists, but using it while a player is disconnected is .. not good.
	-- idea: set the inventory's _removed parameter while the player is logged out, and unset it if they come back?
	self._removed = true
end

function Player:_show_formspec(formname, formspec)
	for _, callback in ipairs(state.registered_on_shown_formspecs) do
		callback(self, formname, formspec)
	end
end

-- player specific

function Player:is_player()
	return true
end

function Player:set_armor_groups(groups)
	groups = table.copy(groups)
	if not core.settings:get_bool("enable_damage", false) and not (groups.immortal or 0) > 0 then
		core.log("warning", "Mod tried to enable damage for a player, but it's disabled globally. Ignoring.")
		groups.immortal = 1
	end
	ObjectRef.set_armor_groups(self, groups)
end

-- player only

function Player:get_inventory()
	return self._persistent_data.inventory
end

function Player:get_wield_list()
	return "main"
end

function Player:get_wield_index()
	return self._wield_index
end

function Player:get_wielded_item()
	local inv = self:get_inventory()
	return inv:get_stack("main", self._wield_index)
end

function Player:set_wielded_item(item)
	local inv = self:get_inventory()
	return inv:set_stack("main", self._wield_index, item)
end

function Player:get_player_name()
	return self._player_name
end

function Player:get_player_velocity()
	core.log("deprecated", "Player:get_player_velocity()")
	return vector.copy(self._velocity)
end

function Player:add_player_velocity(vel)
	core.log("deprecated", "Player:add_player_velocity(vel)")
	assert(vector.check(vel), "velocity must be a vector")
	self._velocity = vector.add(self._velocity, vel)
end

function Player:get_look_dir()
	return vector.new(
		math.cos(self._pitch) * math.cos(self._yaw),
		math.sin(self._pitch),
		math.cos(self._pitch) * math.sin(self._yaw)
	)
end

function Player:get_look_vertical()
	return self._persistent_data.pitch
end

function Player:get_look_horizontal()
	return self._persistent_data.yaw
end

function Player:set_look_vertical(radians)
	self._persistent_data.pitch = radians
end

function Player:set_look_horizontal(radians)
	self._persistent_data.yaw = radians
end

function Player:get_look_pitch()
	core.log("deprecated", "Player:get_look_pitch()")
	return -self._persistent_data.pitch
end

function Player:get_look_yaw()
	core.log("deprecated", "Player:get_look_yaw()")
	return self._persistent_data.yaw + (math.pi / 2)
end

function Player:set_look_pitch(radians)
	core.log("deprecated", "Player:set_look_pitch(radians)")
	self._persistent_data.pitch = -radians
end

function Player:set_look_yaw(radians)
	core.log("deprecated", "Player:set_look_yaw(radians)")
	self._persistent_data.yaw = radians - (math.pi / 2)
end

function Player:get_breath()
	return self._persistent_data.breath
end

function Player:set_breath(value)
	self._persistent_data.breath = value
end

function Player:set_fov(fov, is_multiplier, transition_time)
	self._fov = { fov, is_multiplier, transition_time }
end

function Player:get_fov()
	return unpack(self._fov)
end

function Player:set_attribute(attribute, value)
	core.log("deprecated", "Player:set_attribute(attribute, value)")
	self._persistent_data.meta:set_string(attribute, value)
end

function Player:get_attribute(attribute)
	core.log("deprecated", "Player:get_attribute(attribute)")
	self._persistent_data.meta:get_string(attribute)
end

function Player:get_meta()
	return self._persistent_data.meta
end

function Player:set_inventory_formspec(formspec)
	self._inventory_formspec = formspec
end

function Player:get_inventory_formspec()
	return self._inventory_formspec
end

function Player:set_formspec_prepend(formspec)
	self._formspec_prepend = formspec
end

function Player:get_formspec_prepend()
	return self._formspec_prepend
end

function Player:get_player_control()
	return table.copy(self._player_control)
end

function Player:get_player_control_bits()
	local bits = 0
	for key, value in pairs(self._player_control) do
		if value then
			bits = bits + player_control_bits[key]
		end
	end
	return bits
end

function Player:set_physics_override(override_table)
	-- TODO input validation
	set_all(self._physics_override, override_table)
end

function Player:get_physics_override()
	return table.copy(self._physics_override)
end

function Player:hud_add(def)
	-- TODO input validation?
	local id = self._next_hud_id
	self._next_hud_id = id + 1
	self._huds[id] = table.copy(def)
	return id
end

function Player:hud_remove(id)
	if self._huds[id] then
		self._huds[id] = nil
	else
		modtest.warn("attempt to remove non-existent HUD")
	end
end

function Player:hud_change(id, stat, value)
	local hud = self._huds[id]
	if hud then
		hud[stat] = value
	else
		modtest.warn("attempt to change non-existent HUD")
	end
end

function Player:hud_get(id)
	local hud = self._huds[id]
	if hud then
		return table.copy(hud)
	end
end

function Player:hud_set_flags(flags)
	set_all(self._hud_flags, flags)
end

function Player:hud_get_flags()
	return table.copy(self._hud_flags)
end

function Player:hud_set_hotbar_itemcount(count)
	if type(count) == "number" then
		count = math.floor(count)
		if count > 0 and count <= self._persistent_data.inventory:get_size("main") then
			self._hotbar_itemcount = math.floor(count)
			return true
		end
	else
		error("hotbar itemcount must be an integer")
	end
end

function Player:hud_get_hotbar_itemcount()
	return self._hotbar_itemcount
end

function Player:hud_set_hotbar_image(texturename)
	self._hotbar_image = texturename
end

function Player:hud_get_hotbar_image()
	return self._hotbar_image
end

function Player:hud_set_hotbar_selected_image(texturename)
	self._hotbar_selected_image = texturename
end

function Player:hud_get_hotbar_selected_image()
	return self._hotbar_selected_image
end

function Player:set_minimap_modes(modes, selected_mode)
	if type(selected_mode) ~= "number" or selected_mode < 0 then
		error("invalid selected minimap mode")
	end
	self._minimap_modes = table.copy(modes)
	self._selected_minimap_mode = selected_mode
end

function Player:set_sky(sky_parameters, type, textures, clouds)
	if type ~= nil or textures ~= nil or clouds ~= nil or is_valid_colorspec(sky_parameters) then
		core.log("deprecated", "Player:set_sky(base_color, type, textures, clouds)")

		if type(type) ~= "string" then
			error("type must be a string")
		end

		sky_parameters = {
			base_color = sky_parameters,
			type = type,
			textures = textures,
			clouds = clouds,
		}
	end

	if is_valid_colorspec(sky_parameters.base_color) then
		sky_parameters.base_color = normalize_colorspec(sky_parameters.base_color)
	else
		modtest.warn("invalid colorspec, ignoring")
		sky_parameters.base_color = nil
	end

	if sky_parameters.type ~= "regular" and sky_parameters.type ~= "skybox" and sky_parameters.type ~= "plain" then
		modtest.warn("invalid skybox type, ignoring")
		sky_parameters.type = nil
	end

	set_all(self._sky, sky_parameters)
end

function Player:get_sky(as_table)
	if as_table ~= true then
		core.log("deprecated", "Player:get_sky()")
		return table.copy(self._sky.base_color), self._sky.type, table.copy(self._sky.textures), self._sky.clouds
	end
	return table.copy(self._sky)
end

function Player:get_sky_color()
	core.log("deprecated", "Player:get_sky_color()")
	return table.copy(self._sky.base_color)
end

function Player:set_sun(sun_parameters)
	-- TODO input validation
	modtest.table.set_all(self._sun, sun_parameters)
end

function Player:get_sun()
	return table.copy(self._sun)
end

function Player:set_moon(moon_parameters)
	-- TODO input validation
	modtest.table.set_all(self._moon, moon_parameters)
end

function Player:get_moon()
	return table.copy(self._moon)
end

function Player:set_stars(star_parameters)
	-- TODO input validation
	modtest.table.set_all(self._stars, star_parameters)
end

function Player:get_stars()
	return table.copy(self._stars)
end

function Player:set_clouds(cloud_parameters)
	-- TODO input validation
	modtest.table.set_all(self._clouds, cloud_parameters)
end

function Player:get_clouds()
	return table.copy(self._clouds)
end

function Player:override_day_night_ratio(ratio)
	if ratio == nil or (type(ratio) == "number" and 0 <= ratio and ratio <= 1) then
		self._day_night_override = ratio
	else
		error("invalid day/night ratio")
	end
end

function Player:get_day_night_ratio()
	return self._day_night_override
end

function Player:set_local_animation(idle, walk, dig, walk_while_dig, frame_speed)
	if
		not (
			is_frame_index(idle)
			and is_frame_index(walk)
			and is_frame_index(dig)
			and is_frame_index(walk_while_dig)
			and is_non_negative_number(frame_speed)
		)
	then
		error("invalid animation spec")
	end
	self._local_animation = {
		table.copy(idle),
		table.copy(walk),
		table.copy(dig),
		table.copy(walk_while_dig),
		frame_speed,
	}
end

function Player:get_local_animation()
	return unpack(table.copy(self._local_animation))
end

function Player:set_eye_offset(firstperson, thirdperson)
	-- TODO input validation
	if firstperson then
		self._eye_offset_firstperson = vector.copy(firstperson)
	else
		self._eye_offset_firstperson = vector.zero()
	end
	if thirdperson then
		self._eye_offset_thirdperson = vector.copy(thirdperson)
	else
		self._eye_offset_thirdperson = vector.zero()
	end
end

function Player:get_eye_offset()
	return self._eye_offset_firstperson, self._eye_offset_thirdperson
end

function Player:send_mapblock(blockpos)
	-- TODO input validation
	if not vector.check(blockpos) then
		error("invalid blockpos")
	end
	-- TODO: should this actually do anything? we're not testing client/server interactions, just the server.
end

function Player:set_lighting(light_definition)
	-- TODO input validation
	set_all(self._lighting, light_definition)
end

function Player:get_lighting()
	return table.copy(self._lighting)
end

function Player:respawn()
	error("TODO: implement")
end
