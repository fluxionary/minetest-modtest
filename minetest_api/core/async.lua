local state = ...

local jobid = 0

-- local jobid = core.do_async_callback(func, args, mod_origin)
function core.do_async_callback(func, args, mod_origin)
	jobid = jobid + 1
	state.async_jobs:push_back({ jobid, func, args, mod_origin })
	return jobid
end

function core.register_async_dofile(path)
	local env = state:get_async_env()
	setfenv(1, env)
	dofile(path)
end
