--[[
	modtest
	--builtin PATH/TO/builtin     # optional, but must be able to find it
	--conf PATH/TO/minetest.conf  # optional
	--game PATH/TO/game           # optional, defaults to our own "null game"
	--mods PATH/TO/mods           # optional
	--world PATH/TO/world         # optional, defaults to our own "empty_world"
	mod_to_test					  # required
]]

local f = string.format

local concat_path = modtest.util.concat_path
local directory_exists = modtest.util.directory_exists
local file_exists = modtest.util.file_exists

local valid_args = {
	builtin = true,
	conf = true,
	game = true,
	mods = true,
	world = true,
}

local function is_option(v)
	return v:sub(1, 2) == "--"
end

local function get_option(arg, i)
	local option = arg[i]
	local value = arg[i + 1]
	local key = option:sub(3)
	if not valid_args[key] then
		error(f("unknown argument %s", option))
	end
	if not value then
		error("invalid arguments")
	end
	return key, value
end

local function get_game_name(path)
	local settings = modtest.util.load_settings(concat_path(path, "game.conf"))
	return settings.name
end

local function parse_args(argv)
	local args = {}

	local i = 1
	while i <= #argv do
		local v = argv[i]
		if is_option(v) then
			local key, value = get_option(argv, i)
			args[key] = value
			i = i + 2
		else
			if args.mod_to_test then
				error(f("too many arguments specified %q", table.concat(argv, " ")))
			end
			args.mod_to_test = v
			i = i + 1
		end
	end

	if not args.mod_to_test then
		error("you must specify a path to a mod to test")
	end

	if not directory_exists(args.mod_to_test) then
		error(f("mod dir %q does not exist"))
	end

	if not file_exists(concat_path(args.mod_to_test, "init.lua")) then
		error(f("mod dir %q doesn't contain an init.lua file"))
	end

	if not file_exists(concat_path(args.mod_to_test, "mod.conf")) then
		error(f("mod dir %q doesn't contain a mod.conf file"))
	end

	local home = os.getenv("HOME")
	if not home or home == "" then
		home = "."
	end

	if not args.conf then
		if file_exists(concat_path(args.mod_to_test, "minetest.conf")) then
			args.conf = concat_path(args.mod_to_test, "minetest.conf")
		end
		-- conf is optional, so no error if it doesn't exist
	end

	if not args.builtin then
		if modtest.util.directory_exists(concat_path(home, ".minetest", "builtin")) then
			args.builtin = concat_path(home, ".minetest", "builtin")
		elseif modtest.util.directory_exists("/usr/share/minetest/builtin") then
			args.builtin = "/usr/share/minetest/builtin"
		else
			error("cannot find minetest builtin lua code; use --builtin PATH/TO/BUILTIN")
		end
	end

	if not args.world then
		if directory_exists(concat_path(args.mod_to_test, "modtest", "world")) then
			args.world = concat_path(args.mod_to_test, "modtest", "world")
		else
			args.world = concat_path(modtest.our_path, "empty_world")
		end
	end

	if not directory_exists(args.world) then
		error(f("world path %q doesn't exist", args.world))
	end

	local world_mt_path = concat_path(args.world, "world.mt")

	if not file_exists(world_mt_path) then
		error(f("world path %q doesn't contain a world.mt file"))
	end

	args.world_mt = modtest.util.load_settings(world_mt_path)

	if not args.mods then
		if directory_exists(concat_path(args.mod_to_test, "modtest", "mods")) then
			args.mods = concat_path(args.mod_to_test, "modtest", "mods")
		elseif directory_exists(concat_path(home, ".minetest", "mods")) then
			args.mods = concat_path(home, ".minetest", "mods")
		end
		-- mods dir is optional, so no error if the dir doesn't exist
	end

	if not args.game then
		local game_id = args.world_mt.gameid
		if not game_id then
			error(f("cannot find game id in world.mt"))
		end

		if directory_exists(concat_path(args.mod_to_test, "modtest", game_id)) then
			args.game = concat_path(args.mod_to_test, "modtest", game_id)
		elseif directory_exists(concat_path(modtest.our_path, game_id)) then
			args.game = concat_path(modtest.our_path, game_id)
		elseif directory_exists(concat_path(home, ".minetest", "games", game_id)) then
			args.game = concat_path(home, ".minetest", "games", game_id)
		elseif directory_exists(concat_path("/usr/share/minetest/games", game_id)) then
			args.game = concat_path("/usr/share/minetest/games", game_id)
		else
			error(f("cannot find game %q, please manually point to it w/ the --game option", game_id))
		end
	end

	if not directory_exists(args.game) then
		error("game directory does not exist")
	end

	if not file_exists(concat_path(args.game, "game.conf")) then
		error("game folder contains no game.conf")
	end

	args.game_name = get_game_name(args.game)

	if not directory_exists(concat_path(args.game), "mods") then
		error("game folder contains no mods folder")
	end

	return args
end

modtest.args = parse_args(arg)
arg = {}
