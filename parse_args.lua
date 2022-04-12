local function is_option(v)
	return v:sub(1, 2) == "--"
end

local function get_option(arg, i)
	local option = arg[i]
	local value = arg[i + 1]
	local key = option:sub(3)
	if not (key == "conf" or key == "world" or key == "mods" or key == "game") then
		error(("unknown argument %s"):format(option))
	end
	if not value then
		error("invalid arguments")
	end
	return key, value
end

local function get_game_id(world)
	local filename = world .. "/world.mt"
	for line in io.lines(filename) do
		local key, value = modtest.util.parse_config_line(line)
		if key == "gameid" then
			if not value or value == "" or value == "minetest" then
				return "minetest_game"
			end
		end
	end
	return "minetest_game"
end

function modtest.parse_args(arg)
	--[[
		--conf PATH/TO/minetest.conf
		--world PATH/TO/world
		--mods PATH/TO/mods
		mod_to_test
	]]

	local args = {}

	local i = 1
	while i <= #arg do
		local v = arg[i]
		if is_option(v) then
			local key, value = get_option(arg, i)
			args[key] = value
			i = i + 2
		else
			if args.mod_to_test then
				error(("too many arguments specified %q"):format(table.concat(arg, " ")))
			end
			if not modtest.util.file_exists(v) then
				error(("mod at %s does not exist"):format(v))
			end
			args.mod_to_test = v
			i = i + 1
		end
	end

	if not args.mod_to_test then
		error("you must specify a path to a mod to test")
	end

	if not args.conf then
		local home = os.getenv("HOME")
		if not home or home == "" then
			error("could't figure out where you live")
		end
		args.conf = home .. "/.minetest/minetest.conf"
	end

	if not args.mods then
		if args.world then
			args.mods = args.world .. "/worldmods"
		else
			local home = os.getenv("HOME")
			if not home or home == "" then
				error("could't figure out where you live")
			end
			args.mods = home .. "/.minetest/mods"
		end
	end

	if not args.world then
		args.world = "."
	end

	if not args.game then
		local game_id = get_game_id(args.world)
		local home = os.getenv("HOME")
		if not home or home == "" then
			error("could't figure out where you live")
		end
		args.game = home .. "/.minetest/games/" .. game_id
	end

	return args
end
