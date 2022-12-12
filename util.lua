local f = string.format

local m_max = math.max
local m_min = math.min

local util = {}

function util.parse_config_line(line)
	return line:match("^%s*([^%s=]+)%s*=%s*(.-)%s*$")
end

function util.concat_path(...)
	return table.concat({ ... }, DIR_DELIM)
end

function util.split(str)
	local values = {}
	for s in str:gmatch("([^%s,]+)") do
		table.insert(values, s)
	end
	return values
end

function util.file_exists(path)
	local fh = io.open(path, "r")
	if fh then
		io.close(fh)
		return true
	else
		return false
	end
end

function util.directory_exists(path)
	path = path .. DIR_DELIM
	local ok, err, code = os.rename(path, path)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

function util.get_subdirectories(path)
	local subdirectories = {}
	if not util.directory_exists(path) then
		return subdirectories
	end
	local ls = util.concat_path("", "bin", "ls")
	local pfile = io.popen(f("%s -1 %q", ls, path))
	for filename in pfile:lines() do
		filename = util.concat_path(path, filename)
		if util.directory_exists(filename) then
			table.insert(subdirectories, filename)
		end
	end
	pfile:close()
	return subdirectories
end

function util.iterate_tree(basepath)
	local subpaths = {}
	local ls = util.concat_path("", "bin", "ls")
	local pfile = io.popen(f("%s -1 %q", ls, basepath))
	for filename in pfile:lines() do
		local fullpath = util.concat_path(basepath, filename)
		if util.directory_exists(fullpath) then
			for subpath in util.iterate_tree(fullpath) do
				subpaths[#subpaths + 1] = subpath
			end
		else
			subpaths[#subpaths + 1] = fullpath
		end
	end

	local i = 0
	return function()
		i = i + 1
		return subpaths[i]
	end
end

function util.make_class(super)
	local class = {}
	class.__index = class

	local metatable = {}
	if super then
		metatable.__index = super
	end

	function metatable:__call(...)
		local obj = setmetatable({}, class)
		if obj._init then
			obj:_init(...)
		end
		return obj
	end

	setmetatable(class, metatable)

	return class
end

function util.equals(a, b)
	local type_a = type(a)
	if type_a ~= type(b) then
		return false
	end
	if type_a ~= "table" then
		return a == b
	elseif a == b then
		return true
	end

	local size_a = 0

	for key, value in pairs(a) do
		if not util.equals(value, b[key]) then
			return false
		end
		size_a = size_a + 1
	end

	local size_b = 0
	for _ in pairs(b) do
		size_b = size_b + 1
		if size_b > size_a then
			return false
		end
	end

	return size_a == size_b
end

function util.bound(min, v, max)
	return m_max(min, m_min(v, max))
end

modtest.util = util
