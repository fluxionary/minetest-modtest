local State = ...

State._register_initializers(function(self)
	self.next_object_id = 1
end, function(self, other)
	self.next_object_id = other.next_object_id
end)
