Player = modtest.util.class1(ActiveObject)

modtest.util.check_removed(Player)

local player_control_bits = {
	up = 1,
	down = 2,
	left = 4,
	right = 8,
	jump = 16,
	aux1 = 32,
	sneak = 64,
	dig = 128,
	place = 256,
	zoom = 512,
	LMB = 0,
	RMB = 0,
}

function Player:_init(name, connection_info, persistent_data)
	ActiveObject._init(self, persistent_data.pos)
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
end

-- internal functions

function Player:_disconnect(timed_out)
	core.object_refs[self._id] = nil
	self._removed = true
end

-- player specific

function Player:set_armor_groups(groups)
	groups = table.copy(groups)
	if not core.settings:get_bool("enable_damage", false) and not (groups.immortal or 0) > 0 then
		core.log("warning", "Mod tried to enable damage for a player, but it's disabled globally. Ignoring.")
		groups.immortal = 1
	end
	ActiveObject.set_armor_groups(self, groups)
end

-- player only

function ActiveObject:get_player_name()
	return self._player_name
end

function ActiveObject:get_player_velocity()
	modtest.api.warn("called deprecated")
	return vector.copy(self._velocity)
end

function ActiveObject:add_player_velocity(vel)
	modtest.api.warn("called deprecated")
	if not vector.check(vel) then
		error("velocity must be a vector")
	end
	self._velocity = vector.add(self._velocity, vel)
end

function ActiveObject:get_look_dir()
	return vector.new(
		math.cos(self._pitch) * math.cos(self._yaw),
		math.sin(self._pitch),
		math.cos(self._pitch) * math.sin(self._yaw)
	)
end

function ActiveObject:get_look_vertical()
	return self._persistent_data.pitch
end

function ActiveObject:get_look_horizontal()
	return self._persistent_data.yaw
end

function ActiveObject:set_look_vertical(radians)
	self._persistent_data.pitch = radians
end

function ActiveObject:set_look_horizontal(radians)
	self._persistent_data.yaw = radians
end

function ActiveObject:get_look_pitch()
	modtest.api.warn("called deprecated")
	return -self._persistent_data.pitch
end

function ActiveObject:get_look_yaw()
	modtest.api.warn("called deprecated")
	return self._persistent_data.yaw + (math.pi / 2)
end

function ActiveObject:set_look_pitch(radians)
	modtest.api.warn("called deprecated")
	self._persistent_data.pitch = -radians
end

function ActiveObject:set_look_yaw(radians)
	modtest.api.warn("called deprecated")
	self._persistent_data.yaw = radians - (math.pi / 2)
end

function ActiveObject:get_breath()
	return self._persistent_data.breath
end

function ActiveObject:set_breath(value)
	self._persistent_data.breath = value
end

function ActiveObject:set_fov(fov, is_multiplier, transition_time)
	self._fov = { fov, is_multiplier, transition_time }
end

function ActiveObject:get_fov()
	return unpack(self._fov)
end

function ActiveObject:set_attribute(attribute, value)
	modtest.api.warn("called deprecated")
	self._persistent_data.meta:set_string(attribute, value)
end

function ActiveObject:get_attribute(attribute)
	modtest.api.warn("called deprecated")
	self._persistent_data.meta:get_string(attribute)
end

function ActiveObject:get_meta()
	return self._persistent_data.meta
end

function ActiveObject:set_inventory_formspec(formspec)
	self._inventory_formspec = formspec
end

function ActiveObject:get_inventory_formspec()
	return self._inventory_formspec
end

function ActiveObject:set_formspec_prepend(formspec)
	self._formspec_prepend = formspec
end

function ActiveObject:get_formspec_prepend()
	return self._formspec_prepend
end

function ActiveObject:get_player_control()
	return table.copy(self._player_control)
end

function ActiveObject:get_player_control_bits()
	local bits = 0
	for key, value in pairs(self._player_control) do
		if value then
			bits = bits + player_control_bits[key]
		end
	end
	return bits
end

function ActiveObject:set_physics_override(override_table)
	-- TODO input validation
	modtest.util.set_all(self._physics_override, override_table)
end

function ActiveObject:get_physics_override()
	return table.copy(self._physics_override)
end

function ActiveObject:hud_add(def)
	-- TODO input validation?
	local id = self._next_hud_id
	self._next_hud_id = id + 1
	self._huds[id] = table.copy(def)
	return id
end

function ActiveObject:hud_remove(id)
	if self._huds[id] then
		self._huds[id] = nil
	else
		modtest.api.warn("attempt to remove non-existent HUD")
	end
end

function ActiveObject:hud_change(id, stat, value)
	local hud = self._huds[id]
	if hud then
		hud[stat] = value
	else
		modtest.api.warn("attempt to change non-existent HUD")
	end
end

function ActiveObject:hud_get(id)
	local hud = self._huds[id]
	if hud then
		return table.copy(hud)
	end
end

function ActiveObject:hud_set_flags(flags)
	modtest.api.set_all(self._hud_flags, flags)
end

function ActiveObject:hud_get_flags()
	return table.copy(self._hud_flags)
end

function ActiveObject:hud_set_hotbar_itemcount(count)
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

function ActiveObject:hud_get_hotbar_itemcount()
	return self._hotbar_itemcount
end

function ActiveObject:hud_set_hotbar_image(texturename)
	self._hotbar_image = texturename
end

function ActiveObject:hud_get_hotbar_image()
	return self._hotbar_image
end

function ActiveObject:hud_set_hotbar_selected_image(texturename)
	self._hotbar_selected_image = texturename
end

function ActiveObject:hud_get_hotbar_selected_image()
	return self._hotbar_selected_image
end

function ActiveObject:set_minimap_modes(modes, selected_mode)
	if type(selected_mode) ~= "number" or selected_mode < 0 then
		error("invalid selected minimap mode")
	end
	self._minimap_modes = table.copy(modes)
	self._selected_minimap_mode = selected_mode
end

function ActiveObject:set_sky(sky_parameters, type, textures, clouds)
	if type ~= nil or textures ~= nil or clouds ~= nil or modtest.util.is_valid_colorspec(sky_parameters) then
		modtest.api.warn("called deprecated")

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

	if modtest.util.is_valid_colorspec(sky_parameters.base_color) then
		sky_parameters.base_color = modtest.util.normalize_colorspec(sky_parameters.base_color)
	else
		modtest.api.warn("invalid colorspec, ignoring")
		sky_parameters.base_color = nil
	end

	if sky_parameters.type ~= "regular" and sky_parameters.type ~= "skybox" and sky_parameters.type ~= "plain" then
		modtest.api.warn("invalid skybox type, ignoring")
		sky_parameters.type = nil
	end

	modtest.util.set_all(self._sky, sky_parameters)
end

function ActiveObject:get_sky(as_table)
	if as_table ~= true then
		modtest.api.warn("called deprecated")
		return table.copy(self._sky.base_color), self._sky.type, table.copy(self._sky.textures), self._sky.clouds
	end
	return table.copy(self._sky)
end

function ActiveObject:get_sky_color()
	modtest.api.warn("called deprecated")
	return table.copy(self._sky.base_color)
end

function ActiveObject:set_sun(sun_parameters)
	-- TODO input validation
	modtest.table.set_all(self._sun, sun_parameters)
end

function ActiveObject:get_sun()
	return table.copy(self._sun)
end

function ActiveObject:set_moon(moon_parameters)
	-- TODO input validation
	modtest.table.set_all(self._moon, moon_parameters)
end

function ActiveObject:get_moon()
	return table.copy(self._moon)
end

function ActiveObject:set_stars(star_parameters)
	-- TODO input validation
	modtest.table.set_all(self._stars, star_parameters)
end

function ActiveObject:get_stars()
	return table.copy(self._stars)
end

function ActiveObject:set_clouds(cloud_parameters)
	-- TODO input validation
	modtest.table.set_all(self._clouds, cloud_parameters)
end

function ActiveObject:get_clouds()
	return table.copy(self._clouds)
end

function ActiveObject:override_day_night_ratio(ratio)
	if ratio == nil or (type(ratio) == "number" and 0 <= ratio and ratio <= 1) then
		self._day_night_override = ratio
	else
		error("invalid day/night ratio")
	end
end

function ActiveObject:get_day_night_ratio()
	return self._day_night_override
end

function ActiveObject:set_local_animation(idle, walk, dig, walk_while_dig, frame_speed)
	if
		not (
			modtest.util.is_frame_index(idle)
			and modtest.util.is_frame_index(walk)
			and modtest.util.is_frame_index(dig)
			and modtest.util.is_frame_index(walk_while_dig)
			and modtest.util.is_non_negative_number(frame_speed)
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

function ActiveObject:get_local_animation()
	return unpack(table.copy(self._local_animation))
end

function ActiveObject:set_eye_offset(firstperson, thirdperson)
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

function ActiveObject:get_eye_offset()
	return self._eye_offset_firstperson, self._eye_offset_thirdperson
end

function ActiveObject:send_mapblock(blockpos)
	-- TODO input validation
	if not vector.check(blockpos) then
		error("invalid blockpos")
	end
	-- TODO: should this actually do anything? we're not testing client/server interactions, just the server.
end

function ActiveObject:set_lighting(light_definition)
	-- TODO input validation
	modtest.util.set_all(self._lighting, light_definition)
end

function ActiveObject:get_lighting()
	return table.copy(self._lighting)
end

function ActiveObject:respawn()
	error("TODO: implement")
end
