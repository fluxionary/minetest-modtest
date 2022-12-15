EntityObject = modtest.util.class1(ActiveObject)

modtest.util.check_removed(EntityObject)

function EntityObject:_init(pos, name)
	ActiveObject._init(pos)
	self._luaentity = { name = name }
	core.luaentities[self._id] = self._luaentity
	self._acceleration = vector.zero()
	self._rotation = vector.zero()
	self._texture_mod = ""
	modtest.util.set_all(self._luaentity, core.registered_entities[name].initial_properties)
end

function EntityObject:remove()
	core.object_refs[self._id] = nil
	core.luaentities[self._id] = nil
	self._removed = true
end

function EntityObject:set_velocity(vel)
	self._velocity = vector.copy(vel)
end

function EntityObject:set_acceleration(acc)
	self._acceleration = vector.copy(acc)
end

function EntityObject:get_acceleration()
	return vector.copy(self._acceleration)
end

function EntityObject:set_rotation(rot)
	self._rotation = vector.copy(rot)
end

function EntityObject:get_rotation()
	return vector.copy(self._rotation)
end

function EntityObject:set_yaw(yaw)
	self._rotation.y = yaw
end

function EntityObject:get_yaw()
	return self._rotation.y
end

function EntityObject:set_texture_mod(mod)
	self._texture_mod = mod
end

function EntityObject:get_texture_mod()
	return self._texture_mod
end

function EntityObject:set_sprite(start_frame, num_frames, framelength, select_x_by_camera)
	self._sprite = { start_frame, num_frames, framelength, select_x_by_camera }
end

function EntityObject:get_entity_name()
	modtest.api.warn("called deprecated")
	local luaentity = self:get_luaentity()
	if luaentity then
		return luaentity.name
	end
end

function EntityObject:get_luaentity()
	return self._luaentity
end
