local bound = modtest.util.bound
local m_floor = math.floor
local m_min = math.min
local m_pow = math.pow

function core.is_yes(value)
	return (value == "y" or value == "yes" or value == "true" or value == true or (tonumber(value) or 0) ~= 0)
end

function core.get_tool_wear_after_use(uses, initial_wear)
	-- https://github.com/minetest/minetest/blob/504e43e0dae50ad98e19db0649c9c825cf2ab7a7/doc/lua_api.txt#L3692-L3697
	-- https://github.com/minetest/minetest/blob/981d79157a64468d19f140f5c55d8ccd3855fa71/src/tool.cpp#L185-L246
	if uses == 0 then
		return 0
	end

	uses = m_floor(uses)
	uses = uses % (2 ^ 32)

	if not initial_wear then
		initial_wear = 0
	end

	initial_wear = m_floor(initial_wear)
	initial_wear = initial_wear % (2 ^ 16)

	local wear_normal = m_floor(65536 / uses)
	local blocks_oversize = m_floor(65536 % uses)
	local wear_extra = 0
	if blocks_oversize > 0 then
		local blocks_normal = uses - blocks_oversize
		local wear_extra_at = blocks_normal * wear_normal
		if initial_wear >= wear_extra_at then
			wear_extra = 1
		end
	end

	return wear_normal + wear_extra
end

local function get_time(cap, rating)
	local rated = cap[rating]
	if rated then
		return true, rated
	else
		return false, 0
	end
end

function core.get_dig_params(groups, tool_capabilities, wear)
	-- https://github.com/minetest/minetest/blob/504e43e0dae50ad98e19db0649c9c825cf2ab7a7/doc/lua_api.txt#L3698-L3708
	-- https://github.com/minetest/minetest/blob/981d79157a64468d19f140f5c55d8ccd3855fa71/src/tool.cpp#L248-L302
	if not wear then
		wear = 0
	end

	local tool_groupcaps = tool_capabilities.groupcaps or {}

	if tool_groupcaps.dig_immediate then
		local dig_immediate = groups.dig_immediate
		if dig_immediate == 2 then
			return { diggable = true, time = 0.5, wear = 0 }
		elseif dig_immediate == 3 then
			return { diggable = true, time = 0, wear = 0 }
		end
	end

	local result_diggable = false
	local result_time = 0
	local result_wear = 0

	local node_level = groups.level or 0
	for group, cap in pairs(tool_groupcaps) do
		local level_diff = cap.level - node_level
		if level_diff >= 0 then
			local rating = groups[group] or 0
			local time_exists, time = get_time(cap, rating)

			if time_exists then
				time = time / level_diff
				if not result_diggable or time < result_time then
					result_diggable = true
					result_time = time
					local real_uses = m_floor(cap.uses * m_pow(3, level_diff))
					real_uses = m_min(real_uses, 65535)
					result_wear = core.get_tool_wear_after_use(real_uses, wear)
				end
			end
		end
	end

	return { result_diggable = true, time = result_time, wear = result_wear }
end

function core.get_hit_params(groups, tool_capabilities, time_from_last_punch, wear)
	-- https://github.com/minetest/minetest/blob/981d79157a64468d19f140f5c55d8ccd3855fa71/doc/lua_api.txt#L3709-L3718
	-- https://github.com/minetest/minetest/blob/981d79157a64468d19f140f5c55d8ccd3855fa71/src/tool.cpp#L304-L333
	if not time_from_last_punch then
		time_from_last_punch = 1000000
	end

	if not wear then
		wear = 0
	end

	local full_punch_interval = tool_capabilities.full_punch_interval or 1.4
	local damage = 0
	local result_wear = 0
	local punch_interval_multiplier = bound(0, time_from_last_punch / full_punch_interval, 1)

	for damage_group, value in pairs(tool_capabilities.damage_groups or {}) do
		local armor = groups[damage_group] or 0
		damage = damage + (value * punch_interval_multiplier * armor * 0.01)
	end

	if tool_capabilities.punch_attack_uses > 0 then
		result_wear = core.get_tool_wear_after_use(tool_capabilities.punch_attack_uses, wear)
			* punch_interval_multiplier
	end

	return {
		hp = bound(-65535, damage, 65535),
		wear = m_floor(result_wear),
	}
end
