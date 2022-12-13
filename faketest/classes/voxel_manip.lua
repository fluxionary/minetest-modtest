VoxelManip = modtest.util.class1()

function VoxelManip:_init(p1, p2)
	self._p1 = p1
	self._p2 = p2
end

function VoxelManip:read_from_map(p1, p2)
	self._p1 = p1
	self._p2 = p2
end

function VoxelManip:get_data()
	error("NOT IMPLEMENTED")
end

function VoxelManip:get_light_data()
	error("NOT IMPLEMENTED")
end

function VoxelManip:get_param2_data()
	error("NOT IMPLEMENTED")
end

function VoxelManip:set_data()
	error("NOT IMPLEMENTED")
end

function VoxelManip:set_light_data()
	error("NOT IMPLEMENTED")
end

function VoxelManip:set_param2_data()
	error("NOT IMPLEMENTED")
end
