local util = modtest.util

function util.memoize1(func)
	local memo = {}
	return function(arg)
		if arg == nil then
			return func()
		end

		local rv = memo[arg]

		if not rv then
			rv = func(arg)
			memo[arg] = rv
		end

		return rv
	end
end
