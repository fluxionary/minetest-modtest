local state = ...

ObjectRef = modtest.util.class1()

modtest.util.check_removed(ObjectRef)

function ObjectRef:_init(pos)
	assert(vector.check(pos))
	self._id, state.next_object_id = state.next_object_id, state.next_object_id + 1
	core.object_refs[self._id] = self
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

function ObjectRef:get_pos()
	return vector.copy(self._pos)
end

function ObjectRef:set_pos(pos)
	if not vector.check(pos) then
		error("position must be a vector")
	end
	self._pos = pos
end

function ObjectRef:get_velocity()
	return vector.copy(self._velocity)
end

function ObjectRef:add_velocity(vel)
	if not vector.check(vel) then
		error("velocity must be a vector")
	end
	self._velocity = vector.add(self._velocity, vel)
end

function ObjectRef:move_to(pos, continuous)
	if not vector.check(pos) then
		error("position must be a vector")
	end
	self._pos = pos
end

function ObjectRef:punch(puncher, time_from_last_punch, tool_capabilities, direction)
	error("TODO: implement")
end

function ObjectRef:right_click(clicker)
	error("TODO: implement")
end

function ObjectRef:get_hp()
	return self._hp
end

function ObjectRef:set_hp(hp, reason)
	if type(hp) ~= "number" then
		error("hp must be a number")
	end
	self._hp = math.max(0, math.floor(hp))
	error("TODO: implement more fully")
end

function ObjectRef:get_inventory()
	return
end

function ObjectRef:get_wield_list()
	return ""
end

function ObjectRef:get_wield_index()
	return 1
end

function ObjectRef:get_wielded_item()
	return ItemStack("")
end

function ObjectRef:set_wielded_item(item)
	return false
end

function ObjectRef:set_armor_groups(groups)
	self._armor_groups = table.copy(groups)
end

function ObjectRef:get_armor_groups()
	return table.copy(self._armor_groups)
end

function ObjectRef:set_animation(frame_range, frame_speed, frame_blend, frame_loop)
	self._animation = { frame_range, frame_speed, frame_blend, frame_loop }
end

function ObjectRef:get_animation()
	return unpack(self._animation)
end

function ObjectRef:set_animation_frame_speed(frame_speed)
	self._animation[2] = frame_speed
end

function ObjectRef:set_attach(parent, bone, position, rotation, forced_visible)
	error("TODO: implement")
end

function ObjectRef:get_attach()
	error("TODO: implement")
end

function ObjectRef:get_children()
	error("TODO: implement")
end

function ObjectRef:set_detach()
	error("TODO: implement")
end

function ObjectRef:set_bone_position(bone, position, rotation)
	error("TODO: implement")
end

function ObjectRef:get_bone_position(bone)
	error("TODO: implement")
end

function ObjectRef:set_properties(properties)
	modtest.util.set_all(self._properties, properties)
end

function ObjectRef:get_properties()
	return table.copy(self._properties)
end

function ObjectRef:is_player()
	return false
end

function ObjectRef:get_nametag_attributes()
	return table.copy(self._nametag_attributes)
end

function ObjectRef:set_nametag_attributes(attributes)
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

function ObjectRef:remove()
	modtest.warn("called on non-luaentity")
end

function ObjectRef:set_velocity(vel)
	modtest.warn("called on non-luaentity")
end

function ObjectRef:set_acceleration(acc)
	modtest.warn("called on non-luaentity")
end

function ObjectRef:get_acceleration()
	modtest.warn("called on non-luaentity")
end

function ObjectRef:set_rotation(rot)
	modtest.warn("called on non-luaentity")
end

function ObjectRef:get_rotation()
	modtest.warn("called on non-luaentity")
end

function ObjectRef:set_yaw(yaw)
	modtest.warn("called on non-luaentity")
end

function ObjectRef:get_yaw()
	modtest.warn("called on non-luaentity")
end

function ObjectRef:set_texture_mod(mod)
	modtest.warn("called on non-luaentity")
end

function ObjectRef:get_texture_mod()
	modtest.warn("called on non-luaentity")
end

function ObjectRef:set_sprite(start_frame, num_frames, framelength, select_x_by_camera)
	modtest.warn("called on non-luaentity")
end

function ObjectRef:get_entity_name()
	modtest.warn("called on non-luaentity")
	core.log("deprecated", "ObjectRef:get_entity_name()")
end

function ObjectRef:get_luaentity()
	-- this is usually called on an unknown object to *check* whether it is a luaentity object
	--modtest.warn("called on non-luaentity")
end

-- Player only (no-op for other objects)

function ObjectRef:get_player_name()
	modtest.warn("called on non-player")
	return ""
end

function ObjectRef:get_player_velocity()
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:get_player_velocity()")
	return vector.zero()
end

function ObjectRef:add_player_velocity(vel)
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:add_player_velocity(vel)")
end

function ObjectRef:get_look_dir()
	modtest.warn("called on non-player")
end

function ObjectRef:get_look_vertical()
	modtest.warn("called on non-player")
end

function ObjectRef:get_look_horizontal()
	modtest.warn("called on non-player")
end

function ObjectRef:set_look_vertical(radians)
	modtest.warn("called on non-player")
end

function ObjectRef:set_look_horizontal(radians)
	modtest.warn("called on non-player")
end

function ObjectRef:get_look_pitch()
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:get_look_pitch()")
end

function ObjectRef:get_look_yaw()
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:get_look_yaw()")
end

function ObjectRef:set_look_pitch(radians)
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:set_look_pitch(radians)")
end

function ObjectRef:set_look_yaw(radians)
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:set_look_yaw(radians)")
end

function ObjectRef:get_breath()
	modtest.warn("called on non-player")
end

function ObjectRef:set_breath(value)
	modtest.warn("called on non-player")
end

function ObjectRef:set_fov(fov, is_multiplier, transition_time)
	modtest.warn("called on non-player")
end

function ObjectRef:get_fov()
	modtest.warn("called on non-player")
end

function ObjectRef:set_attribute(attribute, value)
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:set_attribute(attribute, value)")
end

function ObjectRef:get_attribute(attribute)
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:get_attribute(attribute)")
end

function ObjectRef:get_meta()
	modtest.warn("called on non-player")
end

function ObjectRef:set_inventory_formspec(formspec)
	modtest.warn("called on non-player")
end

function ObjectRef:get_inventory_formspec()
	modtest.warn("called on non-player")
end

function ObjectRef:set_formspec_prepend(formspec)
	modtest.warn("called on non-player")
end

function ObjectRef:get_formspec_prepend(formspec)
	modtest.warn("called on non-player")
end

function ObjectRef:get_player_control()
	modtest.warn("called on non-player")
	return {}
end

function ObjectRef:get_player_control_bits()
	modtest.warn("called on non-player")
	return 0
end

function ObjectRef:set_physics_override(override_table)
	modtest.warn("called on non-player")
end

function ObjectRef:get_physics_override()
	modtest.warn("called on non-player")
end

function ObjectRef:hud_add(def)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_remove(id)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_change(id, stat, value)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_get(id)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_set_flags(flags)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_get_flags()
	modtest.warn("called on non-player")
end

function ObjectRef:hud_set_hotbar_itemcount(count)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_get_hotbar_itemcount()
	modtest.warn("called on non-player")
end

function ObjectRef:hud_set_hotbar_image(texturename)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_get_hotbar_image()
	modtest.warn("called on non-player")
end

function ObjectRef:hud_set_hotbar_selected_image(texturename)
	modtest.warn("called on non-player")
end

function ObjectRef:hud_get_hotbar_selected_image()
	modtest.warn("called on non-player")
end

function ObjectRef:set_minimap_modes(modes, selected_mode)
	modtest.warn("called on non-player")
end

function ObjectRef:set_sky(sky_parameters, type, textures, clouds)
	modtest.warn("called on non-player")
	if type or textures or clouds then
		core.log("deprecated", "ObjectRef:set_sky(color, type, textures, clouds)")
	end
end

function ObjectRef:get_sky(as_table)
	modtest.warn("called on non-player")
	if as_table ~= true then
		core.log("deprecated", "ObjectRef:get_sky()")
	end
end

function ObjectRef:get_sky_color()
	modtest.warn("called on non-player")
	core.log("deprecated", "ObjectRef:get_sky_color()")
end

function ObjectRef:set_sun(sun_parameters)
	modtest.warn("called on non-player")
end

function ObjectRef:get_sun()
	modtest.warn("called on non-player")
end

function ObjectRef:set_moon(moon_parameters)
	modtest.warn("called on non-player")
end

function ObjectRef:get_moon()
	modtest.warn("called on non-player")
end

function ObjectRef:set_stars(star_parameters)
	modtest.warn("called on non-player")
end

function ObjectRef:get_stars()
	modtest.warn("called on non-player")
end

function ObjectRef:set_clouds(cloud_parameters)
	modtest.warn("called on non-player")
end

function ObjectRef:get_clouds()
	modtest.warn("called on non-player")
end

function ObjectRef:override_day_night_ratio(ratio)
	modtest.warn("called on non-player")
end

function ObjectRef:get_day_night_ratio()
	modtest.warn("called on non-player")
end

function ObjectRef:set_local_animation(idle, walk, dig, walk_while_dig, frame_speed)
	modtest.warn("called on non-player")
end

function ObjectRef:get_local_animation()
	modtest.warn("called on non-player")
end

function ObjectRef:set_eye_offset(firstperson, thirdperson)
	modtest.warn("called on non-player")
end

function ObjectRef:get_eye_offset()
	modtest.warn("called on non-player")
end

function ObjectRef:send_mapblock(blockpos)
	modtest.warn("called on non-player")
end

function ObjectRef:set_lighting(light_definition)
	modtest.warn("called on non-player")
end

function ObjectRef:get_lighting()
	modtest.warn("called on non-player")
end

function ObjectRef:respawn()
	modtest.warn("called on non-player")
end
