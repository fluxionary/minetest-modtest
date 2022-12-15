local util = modtest.util

function util.class1(super)
	local class = {}
	class.__index = class

	setmetatable(class, {
		__index = (super and super.__index or super),
		__call = function(this_class, ...)
			local obj = setmetatable({}, this_class)
			local init = obj._init
			if init then
				init(obj, ...)
			end
			return obj
		end,
	})

	return class
end

-- shenanigans to avoid having boilerplate in every method to check whether an active object has been "removed"
function util.check_removed(class)
	local old_index = class.__index
	function class:__index(key)
		local value = old_index[key]
		if type(value) == "function" and key:sub(1, 1) ~= "_" then
			return function(self2, ...)
				if self2._removed then
					modtest.api.warn("called on removed")
					return
				end
				return value(self2, ...)
			end
		end

		return value
	end
end
