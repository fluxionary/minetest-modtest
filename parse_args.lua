--[[
	--builtin PATH/TO/builtin
	--conf PATH/TO/minetest.conf
	--world PATH/TO/world
	--game PATH/TO/world
	--mods PATH/TO/mods
	mod_to_test
]]

local f = string.format

local concat_path = modtest.util.concat_path
local directory_exists = modtest.util.directory_exists
local file_exists = modtest.util.file_exists
local parse_config_line = modtest.util.parse_config_line

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

local function get_game_id(world_path)
	local filename = concat_path(world_path, "world.mt")

	if not file_exists(filename) then
		return
	end

	for line in io.lines(filename) do
		local key, value = parse_config_line(line)
		if key == "gameid" then
			if value == "minetest" then
				return "minetest_game"
			else
				return value
			end
		end
	end
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
			error("you must specify a world w/ the --world option")
		end
	end

	if not directory_exists(args.world) then
		error(f("world path %q doesn't exist", args.world))
	end

	if not file_exists(concat_path(args.world, "world.mt")) then
		error(f("world path %q doesn't contain a world.mt file"))
	end

	if not args.mods then
		if directory_exists(concat_path(args.mod_to_test, "modtest", "mods")) then
			args.mods = concat_path(args.mod_to_test, "modtest", "mods")
		elseif directory_exists(concat_path(home, ".minetest", "mods")) then
			args.mods = concat_path(home, ".minetest", "mods")
		end
		-- mods are optional, so no error if they don't exist
	end

	if not args.game then
		local game_id = get_game_id(args.world)
		if not game_id then
			error(f("cannot find game id in world.mt"))
		end

		if directory_exists(concat_path(args.mod_to_test, "modtest", game_id)) then
			args.game = concat_path(args.mod_to_test, "modtest", game_id)
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

	if not directory_exists(concat_path(args.game), "mods") then
		error("game folder contains no mods folder")
	end

	return args
end

modtest.args = parse_args(arg)
