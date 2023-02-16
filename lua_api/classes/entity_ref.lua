EntityRef = modtest.util.class1(ObjectRef)

modtest.util.check_removed(EntityRef)

function EntityRef:_init(pos, name)
	ObjectRef._init(self, pos)
	self._luaentity = { name = name }
	core.luaentities[self._id] = self._luaentity
	self._acceleration = vector.zero()
	self._rotation = vector.zero()
	self._texture_mod = ""
	modtest.util.set_all(self._luaentity, core.registered_entities[name].initial_properties)
end

function EntityRef:remove()
	core.object_refs[self._id] = nil
	core.luaentities[self._id] = nil
	self._removed = true
end

function EntityRef:set_velocity(vel)
	self._velocity = vector.copy(vel)
end

function EntityRef:set_acceleration(acc)
	self._acceleration = vector.copy(acc)
end

function EntityRef:get_acceleration()
	return vector.copy(self._acceleration)
end

function EntityRef:set_rotation(rot)
	self._rotation = vector.copy(rot)
end

function EntityRef:get_rotation()
	return vector.copy(self._rotation)
end

function EntityRef:set_yaw(yaw)
	self._rotation.y = yaw
end

function EntityRef:get_yaw()
	return self._rotation.y
end

function EntityRef:set_texture_mod(mod)
	self._texture_mod = mod
end

function EntityRef:get_texture_mod()
	return self._texture_mod
end

function EntityRef:set_sprite(start_frame, num_frames, framelength, select_x_by_camera)
	self._sprite = { start_frame, num_frames, framelength, select_x_by_camera }
end

function EntityRef:get_entity_name()
	core.log("deprecated", "EntityObject:get_entity_name()")
	local luaentity = self:get_luaentity()
	if luaentity then
		return luaentity.name
	end
end

function EntityRef:get_luaentity()
	return self._luaentity
end
