local function get_depends(mod_name, all_modpaths)
	local modpath = all_modpaths[mod_name]
	local conf_file = modpath .. "/mod.conf"
	local depends = {}
	local optional_depends = {}
	if modtest.util.file_exists(conf_file) then
		for line in io.lines(conf_file) do
			local key, value = modtest.util.parse_config_line(line)
			if key == "depends" then
				depends = modtest.util.split(value)
			elseif key == "optional_depends" then
				optional_depends = modtest.util.split(value)
			end
		end
	end
	return depends, optional_depends
end

local function get_mod_name(modpath)
	local conf_file = modpath .. "/mod.conf"
	for line in io.lines(conf_file) do
		local key, value = modtest.util.parse_config_line(line)
		if key == "name" then
			return value
		end
	end

	return modpath:match('^.-/([^/]+)$')
end

local function load_mod(mod_name, all_modpaths)
	local modpath = all_modpaths[mod_name]
	local init_file = modpath .. "/init.lua"
	if not modtest.util.file_exists(init_file) then
		error(("could not find %q?"):format(init_file))
	end
	modtest.log({"debug", 1}, "loading mod %q from %q", mod_name, modpath)
	modtest.set_current_modname(mod_name)
	dofile(init_file)
	modtest.set_current_modname(nil)
end

local function get_mod_paths(mod_folder, mod_paths, is_root)
	if is_root == nil then is_root = true end
	local subdirs = modtest.util.get_subdirectories(mod_folder)
	local found = false
	for _, subdir in ipairs(subdirs) do
		local mod_conf = subdir .. "/mod.conf"
		modtest.log("debug", "looking for %s", mod_conf)
		local modpack_conf = subdir .. "/modpack.conf"
		if modtest.util.file_exists(mod_conf) then
			local mod_name = get_mod_name(subdir)
			mod_paths[mod_name] = subdir
			modtest.log("debug", "found mod %s in %s", mod_name, subdir)
			found = true
		elseif modtest.util.file_exists(modpack_conf) then
			found = get_mod_paths(subdir, mod_paths, false) or found
		elseif is_root then
			found = get_mod_paths(subdir, mod_paths, false) or found
		end
	end
	if not found then
		modtest.log("debug", "no mods found in %s", mod_folder)
	end
	return found
end

local function get_all_mod_paths()
	local mod_paths = {}

	-- first game
	get_mod_paths(modtest.args.game .. "/mods", mod_paths)
	-- the mods folder
	get_mod_paths(modtest.args.mods, mod_paths)
	-- then worldmods folder
	get_mod_paths(modtest.args.world .. "/worldmods", mod_paths)
	-- then specific "mod to test"
	local to_test_name = get_mod_name(modtest.args.mod_to_test)
	mod_paths[to_test_name] = modtest.args.mod_to_test

	return mod_paths
end

local function resolve_mod(mod_name, resolved, unresolved, all_modpaths)
	local depends, optional_depends = get_depends(mod_name, all_modpaths)

	unresolved[mod_name] = true

	for _, depend in ipairs(depends) do
		if not resolved[depend] then
			if unresolved[depend] then
				error(("dependency cycle detected: %q -> %q"):format(mod_name, depend))
			end

			resolve_mod(depend, resolved, unresolved, all_modpaths)
		end
	end

	for _, depend in ipairs(optional_depends) do
		if not resolved[depend] and all_modpaths[depend] then
			if unresolved[depend] then
				error(("dependency cycle detected: %q -> %q"):format(mod_name, depend))
			end

			resolve_mod(depend, resolved, unresolved, all_modpaths)
		end
	end

	load_mod(mod_name, all_modpaths)

	resolved[mod_name] = true
	unresolved[mod_name] = nil
end

function modtest.load_mods()
	local all_modpaths = get_all_mod_paths()
	modtest.set_all_modpaths(all_modpaths)

	local to_test_name = get_mod_name(modtest.args.mod_to_test)

	resolve_mod(to_test_name, {}, {}, all_modpaths)

	modtest.log("debug", "mods loaded")
end
