local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.current_modname = nil -- i think it's nil by default?
	self.last_run_mod = nil
	self.all_modnames = {}
	self.all_modpaths = {}
end, function(self, other)
	self.current_modname = other.current_modname
	self.last_run_mod = other.last_run_mod
	self.all_modnames = deepcopy(other.all_modnames)
	self.all_modpaths = deepcopy(other.all_modpaths)
end)

function State:set_current_modname(name)
	self.current_modname = name
end

function State:set_last_run_mod(name)
	self.last_run_mod = name
end

function State:set_all_modpaths(modpaths)
	self.all_modpaths = modpaths
	for modname in pairs(modpaths) do
		table.insert(self.all_modnames, modname)
	end
end
