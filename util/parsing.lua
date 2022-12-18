local f = string.format

local util = modtest.util

util.named_colors = {
	aliceblue = { a = 255, r = 0xf0, b = 0xf8, g = 0xff },
	antiquewhite = { a = 255, r = 0xfa, b = 0xeb, g = 0xd7 },
	aqua = { a = 255, r = 0x00, b = 0xff, g = 0xff },
	aquamarine = { a = 255, r = 0x7f, b = 0xff, g = 0xd4 },
	azure = { a = 255, r = 0xf0, b = 0xff, g = 0xff },
	beige = { a = 255, r = 0xf5, b = 0xf5, g = 0xdc },
	bisque = { a = 255, r = 0xff, b = 0xe4, g = 0xc4 },
	black = { a = 255, r = 0x00, b = 0x00, g = 0x00 },
	blanchedalmond = { a = 255, r = 0xff, b = 0xeb, g = 0xcd },
	blue = { a = 255, r = 0x00, b = 0x00, g = 0xff },
	blueviolet = { a = 255, r = 0x8a, b = 0x2b, g = 0xe2 },
	brown = { a = 255, r = 0xa5, b = 0x2a, g = 0x2a },
	burlywood = { a = 255, r = 0xde, b = 0xb8, g = 0x87 },
	cadetblue = { a = 255, r = 0x5f, b = 0x9e, g = 0xa0 },
	chartreuse = { a = 255, r = 0x7f, b = 0xff, g = 0x00 },
	chocolate = { a = 255, r = 0xd2, b = 0x69, g = 0x1e },
	coral = { a = 255, r = 0xff, b = 0x7f, g = 0x50 },
	cornflowerblue = { a = 255, r = 0x64, b = 0x95, g = 0xed },
	cornsilk = { a = 255, r = 0xff, b = 0xf8, g = 0xdc },
	crimson = { a = 255, r = 0xdc, b = 0x14, g = 0x3c },
	cyan = { a = 255, r = 0x00, b = 0xff, g = 0xff },
	darkblue = { a = 255, r = 0x00, b = 0x00, g = 0x8b },
	darkcyan = { a = 255, r = 0x00, b = 0x8b, g = 0x8b },
	darkgoldenrod = { a = 255, r = 0xb8, b = 0x86, g = 0x0b },
	darkgray = { a = 255, r = 0xa9, b = 0xa9, g = 0xa9 },
	darkgreen = { a = 255, r = 0x00, b = 0x64, g = 0x00 },
	darkgrey = { a = 255, r = 0xa9, b = 0xa9, g = 0xa9 },
	darkkhaki = { a = 255, r = 0xbd, b = 0xb7, g = 0x6b },
	darkmagenta = { a = 255, r = 0x8b, b = 0x00, g = 0x8b },
	darkolivegreen = { a = 255, r = 0x55, b = 0x6b, g = 0x2f },
	darkorange = { a = 255, r = 0xff, b = 0x8c, g = 0x00 },
	darkorchid = { a = 255, r = 0x99, b = 0x32, g = 0xcc },
	darkred = { a = 255, r = 0x8b, b = 0x00, g = 0x00 },
	darksalmon = { a = 255, r = 0xe9, b = 0x96, g = 0x7a },
	darkseagreen = { a = 255, r = 0x8f, b = 0xbc, g = 0x8f },
	darkslateblue = { a = 255, r = 0x48, b = 0x3d, g = 0x8b },
	darkslategray = { a = 255, r = 0x2f, b = 0x4f, g = 0x4f },
	darkslategrey = { a = 255, r = 0x2f, b = 0x4f, g = 0x4f },
	darkturquoise = { a = 255, r = 0x00, b = 0xce, g = 0xd1 },
	darkviolet = { a = 255, r = 0x94, b = 0x00, g = 0xd3 },
	deeppink = { a = 255, r = 0xff, b = 0x14, g = 0x93 },
	deepskyblue = { a = 255, r = 0x00, b = 0xbf, g = 0xff },
	dimgray = { a = 255, r = 0x69, b = 0x69, g = 0x69 },
	dimgrey = { a = 255, r = 0x69, b = 0x69, g = 0x69 },
	dodgerblue = { a = 255, r = 0x1e, b = 0x90, g = 0xff },
	firebrick = { a = 255, r = 0xb2, b = 0x22, g = 0x22 },
	floralwhite = { a = 255, r = 0xff, b = 0xfa, g = 0xf0 },
	forestgreen = { a = 255, r = 0x22, b = 0x8b, g = 0x22 },
	fuchsia = { a = 255, r = 0xff, b = 0x00, g = 0xff },
	gainsboro = { a = 255, r = 0xdc, b = 0xdc, g = 0xdc },
	ghostwhite = { a = 255, r = 0xf8, b = 0xf8, g = 0xff },
	gold = { a = 255, r = 0xff, b = 0xd7, g = 0x00 },
	goldenrod = { a = 255, r = 0xda, b = 0xa5, g = 0x20 },
	gray = { a = 255, r = 0x80, b = 0x80, g = 0x80 },
	green = { a = 255, r = 0x00, b = 0x80, g = 0x00 },
	greenyellow = { a = 255, r = 0xad, b = 0xff, g = 0x2f },
	grey = { a = 255, r = 0x80, b = 0x80, g = 0x80 },
	honeydew = { a = 255, r = 0xf0, b = 0xff, g = 0xf0 },
	hotpink = { a = 255, r = 0xff, b = 0x69, g = 0xb4 },
	indianred = { a = 255, r = 0xcd, b = 0x5c, g = 0x5c },
	indigo = { a = 255, r = 0x4b, b = 0x00, g = 0x82 },
	ivory = { a = 255, r = 0xff, b = 0xff, g = 0xf0 },
	khaki = { a = 255, r = 0xf0, b = 0xe6, g = 0x8c },
	lavender = { a = 255, r = 0xe6, b = 0xe6, g = 0xfa },
	lavenderblush = { a = 255, r = 0xff, b = 0xf0, g = 0xf5 },
	lawngreen = { a = 255, r = 0x7c, b = 0xfc, g = 0x00 },
	lemonchiffon = { a = 255, r = 0xff, b = 0xfa, g = 0xcd },
	lightblue = { a = 255, r = 0xad, b = 0xd8, g = 0xe6 },
	lightcoral = { a = 255, r = 0xf0, b = 0x80, g = 0x80 },
	lightcyan = { a = 255, r = 0xe0, b = 0xff, g = 0xff },
	lightgoldenrodyellow = { a = 255, r = 0xfa, b = 0xfa, g = 0xd2 },
	lightgray = { a = 255, r = 0xd3, b = 0xd3, g = 0xd3 },
	lightgreen = { a = 255, r = 0x90, b = 0xee, g = 0x90 },
	lightgrey = { a = 255, r = 0xd3, b = 0xd3, g = 0xd3 },
	lightpink = { a = 255, r = 0xff, b = 0xb6, g = 0xc1 },
	lightsalmon = { a = 255, r = 0xff, b = 0xa0, g = 0x7a },
	lightseagreen = { a = 255, r = 0x20, b = 0xb2, g = 0xaa },
	lightskyblue = { a = 255, r = 0x87, b = 0xce, g = 0xfa },
	lightslategray = { a = 255, r = 0x77, b = 0x88, g = 0x99 },
	lightslategrey = { a = 255, r = 0x77, b = 0x88, g = 0x99 },
	lightsteelblue = { a = 255, r = 0xb0, b = 0xc4, g = 0xde },
	lightyellow = { a = 255, r = 0xff, b = 0xff, g = 0xe0 },
	lime = { a = 255, r = 0x00, b = 0xff, g = 0x00 },
	limegreen = { a = 255, r = 0x32, b = 0xcd, g = 0x32 },
	linen = { a = 255, r = 0xfa, b = 0xf0, g = 0xe6 },
	magenta = { a = 255, r = 0xff, b = 0x00, g = 0xff },
	maroon = { a = 255, r = 0x80, b = 0x00, g = 0x00 },
	mediumaquamarine = { a = 255, r = 0x66, b = 0xcd, g = 0xaa },
	mediumblue = { a = 255, r = 0x00, b = 0x00, g = 0xcd },
	mediumorchid = { a = 255, r = 0xba, b = 0x55, g = 0xd3 },
	mediumpurple = { a = 255, r = 0x93, b = 0x70, g = 0xdb },
	mediumseagreen = { a = 255, r = 0x3c, b = 0xb3, g = 0x71 },
	mediumslateblue = { a = 255, r = 0x7b, b = 0x68, g = 0xee },
	mediumspringgreen = { a = 255, r = 0x00, b = 0xfa, g = 0x9a },
	mediumturquoise = { a = 255, r = 0x48, b = 0xd1, g = 0xcc },
	mediumvioletred = { a = 255, r = 0xc7, b = 0x15, g = 0x85 },
	midnightblue = { a = 255, r = 0x19, b = 0x19, g = 0x70 },
	mintcream = { a = 255, r = 0xf5, b = 0xff, g = 0xfa },
	mistyrose = { a = 255, r = 0xff, b = 0xe4, g = 0xe1 },
	moccasin = { a = 255, r = 0xff, b = 0xe4, g = 0xb5 },
	navajowhite = { a = 255, r = 0xff, b = 0xde, g = 0xad },
	navy = { a = 255, r = 0x00, b = 0x00, g = 0x80 },
	oldlace = { a = 255, r = 0xfd, b = 0xf5, g = 0xe6 },
	olive = { a = 255, r = 0x80, b = 0x80, g = 0x00 },
	olivedrab = { a = 255, r = 0x6b, b = 0x8e, g = 0x23 },
	orange = { a = 255, r = 0xff, b = 0xa5, g = 0x00 },
	orangered = { a = 255, r = 0xff, b = 0x45, g = 0x00 },
	orchid = { a = 255, r = 0xda, b = 0x70, g = 0xd6 },
	palegoldenrod = { a = 255, r = 0xee, b = 0xe8, g = 0xaa },
	palegreen = { a = 255, r = 0x98, b = 0xfb, g = 0x98 },
	paleturquoise = { a = 255, r = 0xaf, b = 0xee, g = 0xee },
	palevioletred = { a = 255, r = 0xdb, b = 0x70, g = 0x93 },
	papayawhip = { a = 255, r = 0xff, b = 0xef, g = 0xd5 },
	peachpuff = { a = 255, r = 0xff, b = 0xda, g = 0xb9 },
	peru = { a = 255, r = 0xcd, b = 0x85, g = 0x3f },
	pink = { a = 255, r = 0xff, b = 0xc0, g = 0xcb },
	plum = { a = 255, r = 0xdd, b = 0xa0, g = 0xdd },
	powderblue = { a = 255, r = 0xb0, b = 0xe0, g = 0xe6 },
	purple = { a = 255, r = 0x80, b = 0x00, g = 0x80 },
	rebeccapurple = { a = 255, r = 0x66, b = 0x33, g = 0x99 },
	red = { a = 255, r = 0xff, b = 0x00, g = 0x00 },
	rosybrown = { a = 255, r = 0xbc, b = 0x8f, g = 0x8f },
	royalblue = { a = 255, r = 0x41, b = 0x69, g = 0xe1 },
	saddlebrown = { a = 255, r = 0x8b, b = 0x45, g = 0x13 },
	salmon = { a = 255, r = 0xfa, b = 0x80, g = 0x72 },
	sandybrown = { a = 255, r = 0xf4, b = 0xa4, g = 0x60 },
	seagreen = { a = 255, r = 0x2e, b = 0x8b, g = 0x57 },
	seashell = { a = 255, r = 0xff, b = 0xf5, g = 0xee },
	sienna = { a = 255, r = 0xa0, b = 0x52, g = 0x2d },
	silver = { a = 255, r = 0xc0, b = 0xc0, g = 0xc0 },
	skyblue = { a = 255, r = 0x87, b = 0xce, g = 0xeb },
	slateblue = { a = 255, r = 0x6a, b = 0x5a, g = 0xcd },
	slategray = { a = 255, r = 0x70, b = 0x80, g = 0x90 },
	slategrey = { a = 255, r = 0x70, b = 0x80, g = 0x90 },
	snow = { a = 255, r = 0xff, b = 0xfa, g = 0xfa },
	springgreen = { a = 255, r = 0x00, b = 0xff, g = 0x7f },
	steelblue = { a = 255, r = 0x46, b = 0x82, g = 0xb4 },
	tan = { a = 255, r = 0xd2, b = 0xb4, g = 0x8c },
	teal = { a = 255, r = 0x00, b = 0x80, g = 0x80 },
	thistle = { a = 255, r = 0xd8, b = 0xbf, g = 0xd8 },
	tomato = { a = 255, r = 0xff, b = 0x63, g = 0x47 },
	turquoise = { a = 255, r = 0x40, b = 0xe0, g = 0xd0 },
	violet = { a = 255, r = 0xee, b = 0x82, g = 0xee },
	wheat = { a = 255, r = 0xf5, b = 0xde, g = 0xb3 },
	white = { a = 255, r = 0xff, b = 0xff, g = 0xff },
	whitesmoke = { a = 255, r = 0xf5, b = 0xf5, g = 0xf5 },
	yellow = { a = 255, r = 0xff, b = 0xff, g = 0x00 },
	yellowgreen = { a = 255, r = 0x9a, b = 0xcd, g = 0x32 },
}

local settingtypes_patterns = {
	"^(%S+)%s+%([^%)]*%)%s+int%s+(%S+)",
	"^(%S+)%s+%([^%)]*%)%s+string%s*(.*)$",
	"^(%S+)%s+%([^%)]*%)%s+bool%s+(%S+)",
	"^(%S+)%s+%([^%)]*%)%s+float%s+(%S+)",
	"^(%S+)%s+%([^%)]*%)%s+enum%s+(%S+)",
	"^(%S+)%s+%([^%)]*%)%s+path%s*(%S*)$",
	"^(%S+)%s+%([^%)]*%)%s+filepath%s*(%S*)$",
	"^(%S+)%s+%([^%)]*%)%s+key%s+(%S+)",
	"^(%S+)%s+%([^%)]*%)%s+flags%s+(%S+)",
	"^(%S+)%s+%([^%)]*%)%s+noise_params_2d%s+(.*)$",
	"^(%S+)%s+%([^%)]*%)%s+noise_params_3d%s+(.*)$",
	"^(%S+)%s+%([^%)]*%)%s+v3f%s+(.*)$",
}

function util.parse_settingtypes_line(line)
	local sps = settingtypes_patterns
	for i = 1, #sps do
		local name, default = line:match(sps[i])
		if name and default then
			return name, default
		end
	end
end
function util.normalize_colorspec(v)
	if type(v) == "table" then
		v = table.copy(v)
		if not v.a then
			v.a = 255
		end
		return v
	elseif type(v) == "string" then
		local nc = util.named_colors[v]
		if nc then
			return nc
		end

		local r, g, b, a
		r, g, b, a = v:match("^#(%x%x)(%x%x)(%x%x)(%x%x)$")
		if not r then
			r, g, b, a = v:match("^#(%x)(%x)(%x)(%x)$")
			if r then
				r, g, b, a = r .. r, g .. g, b .. b, a .. a
			end
		end
		if not r then
			r, g, b = v:match("^#(%x%x)(%x%x)(%x%x)$")
			a = "FF"
		end
		if not r then
			r, g, b = v:match("^#(%x)(%x)(%x)$")
			r, g, b = r .. r, g .. g, b .. b
		end
		if not r then
			error(f("invalid string colorspec %q", v))
		end

		return { a = tonumber(a, 16), r = tonumber(r, 16), g = tonumber(g, 16), b = tonumber(b, 16) }
	elseif type(v) == "number" then
		v = math.floor(v)
		local r, g, b
		b = v % 256
		v = math.floor(v / 256)
		g = v % 256
		v = math.floor(v / 256)
		r = v % 256
		v = math.floor(v / 256)
		return { a = v, r = r, g = g, b = b }
	else
		error(f("invalid colorspec %q", v))
	end
end

local function parse_settings(fh, filepath)
	local linenum = 0
	local values = {}

	local state = "normal"
	local multikey
	local multiline

	for line in fh:lines() do
		linenum = linenum + 1
		line = line:trim()
		if state == "group" then
			if line:sub(-1) == "}" then
				table.insert(multiline, line)
				values[multikey] = table.concat(multiline, "\n"):trim()
				multikey = nil
				multiline = nil
				state = "normal"
			else
				table.insert(multiline, line)
			end
		elseif state == "multiline" then
			if line:sub(-3) == '"""' then
				table.insert(multiline, line:sub(1, -4))
				values[multikey] = table.concat(multiline, "\n"):trim()
				multikey = nil
				multiline = nil
				state = "normal"
			end
		elseif state == "normal" then
			if #line > 0 and line:sub(1, 1) ~= "#" then
				local key, value = line:match("^([^=]+)=(.*)$")
				if not (key and value) then
					error(("invalid conf file %q line %i"):format(filepath, linenum))
				end

				key = key:trim()
				value = value:trim()

				if key == "" then
					error(("blank key in %q line %i"):format(filepath, linenum))
				end

				if value:sub(1, 1) == "{" and value:sub(-1) ~= "}" then
					state = "group"
					multikey = key
					multiline = { value }
				elseif value:sub(1, 3) == '"""' and (value:sub(-3) ~= '"""' or #value < 6) then
					state = "multiline"
					multikey = key
					multiline = { value:sub(4) }
				else
					values[key] = value
				end
			end
		else
			error(("somehow in invalid state %q line %i"):format(state, linenum))
		end
	end

	return values
end

function util.load_settings(filename, defaults)
	local settings
	if defaults then
		settings = table.copy(defaults)
	else
		settings = {}
	end

	if modtest.util.file_exists(filename) then
		local fh = io.open(filename)
		local changes = parse_settings(fh, filename)
		io.close(fh)

		modtest.util.set_all(settings, changes)
	end

	return settings
end
