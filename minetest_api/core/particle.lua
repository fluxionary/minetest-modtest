local state = ...

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

function core.add_particlespawner(...)
	local args = { ... }
	assert(#args > 0, "must supply a particle spawner definition")
	if #args > 1 then
		core.log(
			"deprecated",
			"core.add_particle(add_particlespawner(amount, time, minpos, maxpos, "
				.. "minvel, maxvel, minacc, maxacc, minexptime, maxexptime, minsize, maxsize, collisiondetection, texture, "
				.. "playername)"
		)
		args = {
			amount = args[1],
			time = args[2],
			minpos = args[3],
			maxpos = args[4],
			minvel = args[5],
			maxvel = args[6],
			minacc = args[7],
			maxacc = args[8],
			minexptime = args[9],
			maxexptime = args[10],
			minsize = args[11],
			maxsize = args[12],
			collisiondetection = args[13],
			texture = args[14],
			playername = args[15],
		}
	end
	local next_particle_spawner_id = state.next_particle_spawner_id + 1
	state.next_particle_spawner_id = next_particle_spawner_id
	state.particle_spawners[next_particle_spawner_id] = args
	return next_particle_spawner_id
end

function core.delete_particlespawner(id, player)
	if not player then
		state.particle_spawners[id] = nil
	end
end
