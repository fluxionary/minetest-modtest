modtest.api.async_jobs = modtest.Deque()

local jobid = 0

-- local jobid = core.do_async_callback(func, args, mod_origin)
function core.do_async_callback(func, args, mod_origin)
	jobid = jobid + 1
	modtest.api.async_jobs:push_back({ jobid, func, args, mod_origin })
	return jobid
end

modtest.api.async_dofiles = {}

function core.register_async_dofile(path)
	table.insert(modtest.api.async_dofiles)
end

function modtest.api.run_next_async_job()
	--local job = modtest.api.async_jobs:pop_front()
	--local job_id, func, args, mod_origin = unpack(job)
	error("how do i load the async environment and run a bytecode function in it?")
	--core.async_event_handler(jobid, retval)
end
