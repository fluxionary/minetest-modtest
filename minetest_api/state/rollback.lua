local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.rollbacks_by_pos = {}
end, function(self, other)
	self.rollbacks_by_pos = deepcopy(other.rollbacks_by_pos)
end)

function State:record_rollback_action(pos, action)
	local index = core.hash_node_position(pos)
	local actions = self.rollbacks_by_pos[index]
	if not actions then
		actions = modtest.util.Deque()
		self.rollbacks_by_pos[index] = actions
	end
	actions:push_back(action)
end
