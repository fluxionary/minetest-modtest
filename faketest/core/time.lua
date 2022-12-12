modtest.core.us_time = 0

function modtest.core.step_us_time(us)
	modtest.core.us_time = modtest.core.us_time + us
end

function core.get_us_time()
	return modtest.core.us_time
end
