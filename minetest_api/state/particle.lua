local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.next_particle_spawner_id = 0
	self.particle_spawners = {}
end, function(self, other)
	self.next_particle_spawner_id = other.next_particle_spawner_id
	self.particle_spawners = deepcopy(other.particle_spawners)
end)
