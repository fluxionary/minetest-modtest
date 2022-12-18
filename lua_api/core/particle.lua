function core.add_particle(...)
	assert(#{ ... } > 0, "must supply a particle definition")
	if #{ ... } > 1 then
		core.log(
			"deprecated",
			"core.add_particle(pos, velocity, acceleration,expirationtime, size, "
				.. "collisiondetection, texture, playername)"
		)
	end
end

local next_particle_spawner_id = 0
modtest.api.particle_spawners = {}

function core.add_particlespawner(...)
	assert(#{ ... } > 0, "must supply a particle spawner definition")
	if #{ ... } > 1 then
		core.log(
			"deprecated",
			"core.add_particle(add_particlespawner(amount, time, minpos, maxpos, "
				.. "minvel, maxvel, minacc, maxacc, minexptime, maxexptime, minsize, maxsize, collisiondetection, texture, "
				.. "playername)"
		)
	end
	next_particle_spawner_id = next_particle_spawner_id + 1
	modtest.api.particle_spawners[next_particle_spawner_id] = next_particle_spawner_id
	return next_particle_spawner_id
end

function core.delete_particlespawner(id, player)
	if not player then
		modtest.api.particle_spawners[id] = nil
	end
end
