local f = string.format

local util = modtest.util

function util.concat_path(...)
	return table.concat({ ... }, DIR_DELIM)
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
	return os.rename(path, path)
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
