local State = ...

local deepcopy = modtest.util.deepcopy

State._register_initializers(function(self)
	-- internal log messages chan either be a string (from print()) or {level = level, message = message} (log())
	self.log_messages = modtest.util.Deque()
end, function(self, other)
	self.log_messages = deepcopy(other.log_messages)
end)
