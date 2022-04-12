modtest.util = {}


function modtest.util.parse_config_line(line)
	return line:match("^%s*([^%s=]+)%s*=%s*(.-)%s*$")
end

function modtest.util.split(str)
	local values = {}
	for str in str:gmatch("([^%s,]+)") do
		table.insert(values, str)
	end
	return values
end

function modtest.util.file_exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

function modtest.util.isdir(path)
	return modtest.util.file_exists(path.."/")
end

function modtest.util.get_subdirectories(path)
	local subdirectories = {}
	if not modtest.util.isdir(path) then
		return subdirectories
	end
    local pfile = io.popen(("/bin/ls -1 %q"):format(path))
    for filename in pfile:lines() do
	    filename = ("%s/%s"):format(path, filename)
	    if modtest.util.isdir(filename) then
		    table.insert(subdirectories, filename)
	    end
    end
    pfile:close()
	return subdirectories
end

function modtest.util.make_class(super)
    local class = {}
	class.__index = class

	local metatable = {}
	if super then
		metatable.__index = super
	end

    function metatable:__call(...)
        local obj = setmetatable({}, class)
        if obj.__init then
            obj:__init(...)
        end
        return obj
    end

	setmetatable(class, metatable)

    return class
end

function modtest.util.equals(a, b)
	local type_a = type(a)
	if type_a ~= type(b) then
		return false
	end
	if type_a ~= "table" then
		return a == b
	end
	local a_keys = {}
	for a_key, a_value in pairs(a) do
		local b_value = b[a_key]
		if not modtest.util.equals(a_value, b_value) then
			return false
		end
		a_keys[a_key] = true
	end
	for b_key, _ in pairs(b) do
		if not a_keys[b_key] then
			return false
		end
	end
	return true
end
