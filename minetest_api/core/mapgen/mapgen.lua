local state = ...

function core.emerge_area()
	error("TODO: implement")
end

function core.get_gen_notify()
	error("TODO: implement")
end

function core.get_heat()
	error("TODO: implement")
end

function core.get_humidity()
	error("TODO: implement")
end

--[[
Mapgen objects
==============

A mapgen object is a construct used in map generation. Mapgen objects can be
used by an `on_generate` callback to speed up operations by avoiding
unnecessary recalculations, these can be retrieved using the
`minetest.get_mapgen_object()` function. If the requested Mapgen object is
unavailable, or `get_mapgen_object()` was called outside of an `on_generate()`
callback, `nil` is returned.

The following Mapgen objects are currently available:

### `voxelmanip`

This returns three values; the `VoxelManip` object to be used, minimum and
maximum emerged position, in that order. All mapgens support this object.

### `heightmap`

Returns an array containing the y coordinates of the ground levels of nodes in
the most recently generated chunk by the current mapgen.

### `biomemap`

Returns an array containing the biome IDs of nodes in the most recently
generated chunk by the current mapgen.

### `heatmap`

Returns an array containing the temperature values of nodes in the most
recently generated chunk by the current mapgen.

### `humiditymap`

Returns an array containing the humidity values of nodes in the most recently
generated chunk by the current mapgen.

### `gennotify`

Returns a table mapping requested generation notification types to arrays of
positions at which the corresponding generated structures are located within
the current chunk. To enable the capture of positions of interest to be recorded
call `minetest.set_gen_notify()` first.

Possible fields of the returned table are:

* `dungeon`: bottom center position of dungeon rooms
* `temple`: as above but for desert temples (mgv6 only)
* `cave_begin`
* `cave_end`
* `large_cave_begin`
* `large_cave_end`
* `decoration#id` (see below)

Decorations have a key in the format of `"decoration#id"`, where `id` is the
numeric unique decoration ID as returned by `minetest.get_decoration_id()`.
For example, `decoration#123`.

The returned positions are the ground surface 'place_on' nodes,
not the decorations themselves. A 'simple' type decoration is often 1
node above the returned position and possibly displaced by 'place_offset_y'.
]]
function core.get_mapgen_object()
	error("TODO: implement")
end

function core.get_spawn_level()
	error("TODO: implement")
end

function core.set_gen_notify()
	error("TODO: implement")
end
