local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.player_inventories = {}
	self.node_inventories = {}
	self.detached_inventories = {}
end, function(self, other)
	self.player_inventories = deepcopy(other.player_inventories)
	self.node_inventories = deepcopy(other.node_inventories)
	self.detached_inventories = deepcopy(other.detached_inventories)
end)
