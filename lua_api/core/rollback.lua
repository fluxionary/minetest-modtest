local api = modtest.api

api.rollbacks_by_pos = {}

function api.record_rollback_action(pos, action)
	local index = core.hash_node_position(pos)
	local actions = api.rollbacks_by_pos[index]
	if not actions then
		actions = modtest.Deque()
		api.rollbacks_by_pos[index] = actions
	end
	actions:push_back(action)
end

function core.rollback_get_node_actions()
	error("TODO: implement")
end

function core.rollback_revert_actions_by()
	error("TODO: implement")
end
