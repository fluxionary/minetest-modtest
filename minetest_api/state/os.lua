local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	self.http_api_lua = nil
end, function(self, other)
	self.http_api_lua = deepcopy(other.http_api_lua)
end)
