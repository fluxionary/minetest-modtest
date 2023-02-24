local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.registered_alias_raws = {}

	self.registered_item_raws = {}
	self.content_id_by_name = {}
	self.name_by_content_id = {}
	self.available_content_ids = {}
	self.available_unknown_content_ids = {}

	for i = 0, 32767 do
		if i < 125 or i > 127 then
			self.available_content_ids[i] = true
		end
	end

	self.content_id_by_name["unknown"] = 125
	self.name_by_content_id[125] = "unknown"
	self.content_id_by_name["air"] = 126
	self.name_by_content_id[126] = "air"
	self.content_id_by_name["ignore"] = 127
	self.name_by_content_id[127] = "ignore"

	for i = 32768, 65535 do
		self.available_unknown_content_ids[i] = true
	end
end, function(self, other)
	self.registered_alias_raws = deepcopy(other.registered_alias_raws)
	self.registered_item_raws = deepcopy(other.registered_item_raws)
	self.content_id_by_name = deepcopy(other.content_id_by_name)
	self.name_by_content_id = deepcopy(other.name_by_content_id)
	self.available_content_ids = deepcopy(other.available_content_ids)
	self.available_unknown_content_ids = deepcopy(other.available_unknown_content_ids)
end)

function State:get_next_content_id()
	local next_content_id = next(self.available_content_ids)
	assert(next_content_id, "ran out of available node ids")
	self.available_content_ids[next_content_id] = nil
	return next_content_id
end
