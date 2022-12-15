local m_max = math.max
local m_min = math.min

local util = modtest.util

function util.bound(min, v, max)
	return m_max(min, m_min(v, max))
end
