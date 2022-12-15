ActiveObject = modtest.util.class1()

modtest.util.check_removed(ActiveObject)

local next_object_id = 1

function ActiveObject:_init(pos)
	self._id, next_object_id = next_object_id, next_object_id + 1
	core.object_refs[self._id] = self
	self._removed = false -- set to true when luaentity removed or player disconnects
	self._pos = pos
	self._velocity = vector.zero()
	self._hp = 1
	self._armor_groups = {}
	self._animation = { { x = 1, y = 1 }, 15, 0, true }
	self._properties = {}
	self._nametag_attributes = {
		text = "",
		color = { a = 255, r = 255, g = 255, b = 255 },
		bgcolor = false,
	}
end

function ActiveObject:get_pos()
	return vector.copy(self._pos)
end

function ActiveObject:set_pos(pos)
	if not vector.check(pos) then
		error("position must be a vector")
	end
	self._pos = pos
end

function ActiveObject:get_velocity()
	return vector.copy(self._velocity)
end

function ActiveObject:add_velocity(vel)
	if not vector.check(vel) then
		error("velocity must be a vector")
	end
	self._velocity = vector.add(self._velocity, vel)
end

function ActiveObject:move_to(pos, continuous)
	if not vector.check(pos) then
		error("position must be a vector")
	end
	self._pos = pos
end

function ActiveObject:punch(puncher, time_from_last_punch, tool_capabilities, direction)
	error("TODO: implement")
end

function ActiveObject:get_hp()
	return self._hp
end

function ActiveObject:set_hp(hp, reason)
	if type(hp) ~= "number" then
		error("hp must be a number")
	end
	self._hp = math.max(0, math.floor(hp))
	error("TODO: implement more fully")
end

function ActiveObject:get_inventory()
	return
end

function ActiveObject:get_wield_list()
	return 1
end

function ActiveObject:get_wielded_item()
	return ItemStack("")
end

function ActiveObject:set_wielded_item(item)
	return false
end

function ActiveObject:set_armor_groups(groups)
	self._armor_groups = table.copy(groups)
end

function ActiveObject:get_armor_groups()
	return table.copy(self._armor_groups)
end

function ActiveObject:set_animation(frame_range, frame_speed, frame_blend, frame_loop)
	self._animation = { frame_range, frame_speed, frame_blend, frame_loop }
end

function ActiveObject:get_animation()
	return unpack(self._animation)
end

function ActiveObject:set_animation_frame_speed(frame_speed)
	self._animation[2] = frame_speed
end

function ActiveObject:set_attach(parent, bone, position, rotation, forced_visible)
	error("TODO: implement")
end

function ActiveObject:get_attach()
	error("TODO: implement")
end

function ActiveObject:get_children()
	error("TODO: implement")
end

function ActiveObject:set_detach()
	error("TODO: implement")
end

function ActiveObject:set_bone_position(bone, position, rotation)
	error("TODO: implement")
end

function ActiveObject:get_bone_position(bone)
	error("TODO: implement")
end

function ActiveObject:set_properties(properties)
	modtest.util.set_all(self._properties, properties)
end

function ActiveObject:get_properties()
	return table.copy(self._properties)
end

function ActiveObject:is_player()
	return false
end

function ActiveObject:get_nametag_attributes()
	return table.copy(self._nametag_attributes)
end

function ActiveObject:set_nametag_attributes(attributes)
	if attributes.text ~= nil and type(attributes.text) ~= "string" then
		error("nametag text must be a string")
	else
		self._nametag_attributes.text = attributes.text or ""
	end

	if modtest.util.is_valid_colorspec(attributes.color) then
		self._nametag_attributes.color = modtest.util.normalize_colorspec(attributes.color)
	elseif attributes.color ~= nil then
		error("nametag color must be a colorspec")
	end

	if modtest.util.is_valid_colorspec(attributes.bgcolor) then
		self._nametag_attributes.bgcolor = modtest.util.normalize_colorspec(attributes.bgcolor)
	elseif attributes.bgcolor ~= false then
		self._nametag_attributes.bgcolor = false
	elseif attributes.bgcolor ~= nil then
		error("nametag bgcolor must be a colorspec or false")
	end
end

-- Lua entity only (no-op for other objects)

function ActiveObject:remove()
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:set_velocity(vel)
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:set_acceleration(acc)
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:get_acceleration()
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:set_rotation(rot)
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:get_rotation()
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:set_yaw(yaw)
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:get_yaw()
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:set_texture_mod(mod)
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:get_texture_mod()
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:set_sprite(start_frame, num_frames, framelength, select_x_by_camera)
	modtest.api.warn("called on non-luaentity")
end

function ActiveObject:get_entity_name()
	modtest.api.warn("called on non-luaentity")
	modtest.api.warn("called deprecated")
end

function ActiveObject:get_luaentity()
	modtest.api.warn("called on non-luaentity")
end

-- Player only (no-op for other objects)

function ActiveObject:get_player_name()
	modtest.api.warn("called on non-player")
	return ""
end

function ActiveObject:get_player_velocity()
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
	return vector.zero()
end

function ActiveObject:add_player_velocity(vel)
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:get_look_dir()
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_look_vertical()
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_look_horizontal()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_look_vertical(radians)
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_look_horizontal(radians)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_look_pitch()
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:get_look_yaw()
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:set_look_pitch(radians)
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:set_look_yaw(radians)
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:get_breath()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_breath(value)
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_fov(fov, is_multiplier, transition_time)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_fov()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_attribute(attribute, value)
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:get_attribute(attribute)
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:get_meta()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_inventory_formspec(formspec)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_inventory_formspec()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_formspec_prepend(formspec)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_formspec_prepend(formspec)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_player_control()
	modtest.api.warn("called on non-player")
	return {}
end

function ActiveObject:get_player_control_bits()
	modtest.api.warn("called on non-player")
	return 0
end

function ActiveObject:set_physics_override(override_table)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_physics_override()
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_add(def)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_remove(id)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_change(id, stat, value)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_get(id)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_set_flags(flags)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_get_flags()
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_set_hotbar_itemcount(count)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_get_hotbar_itemcount()
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_set_hotbar_image(texturename)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_get_hotbar_image()
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_set_hotbar_selected_image(texturename)
	modtest.api.warn("called on non-player")
end

function ActiveObject:hud_get_hotbar_selected_image()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_minimap_modes(modes, selected_mode)
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_sky(sky_parameters, type, textures, clouds)
	modtest.api.warn("called on non-player")
	if type or textures or clouds then
		modtest.api.warn("called deprecated")
	end
end

function ActiveObject:get_sky(as_table)
	modtest.api.warn("called on non-player")
	if not as_table then
		modtest.api.warn("called deprecated")
	end
end

function ActiveObject:get_sky_color()
	modtest.api.warn("called on non-player")
	modtest.api.warn("called deprecated")
end

function ActiveObject:set_sun(sun_parameters)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_sun()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_moon(moon_parameters)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_moon()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_stars(star_parameters)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_stars()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_clouds(cloud_parameters)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_clouds()
	modtest.api.warn("called on non-player")
end

function ActiveObject:override_day_night_ratio(ratio)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_day_night_ratio()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_local_animation(idle, walk, dig, walk_while_dig, frame_speed)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_local_animation()
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_eye_offset(firstperson, thirdperson)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_eye_offset()
	modtest.api.warn("called on non-player")
end

function ActiveObject:send_mapblock(blockpos)
	modtest.api.warn("called on non-player")
end

function ActiveObject:set_lighting(light_definition)
	modtest.api.warn("called on non-player")
end

function ActiveObject:get_lighting()
	modtest.api.warn("called on non-player")
end

function ActiveObject:respawn()
	modtest.api.warn("called on non-player")
end
