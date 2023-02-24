local State = ...

local os_time = os.time

State._register_initializers(function(self)
	self.us_time = 0
	self.gametime = 0 -- TODO: this isn't ready: tonumber(core.settings:get("world_start_time")) / 24000 -- in [0, 1)
	self.day_count = 0
	self.start_time = os_time()
end, function(self, other)
	self.us_time = other.us_time
	self.gametime = other.gametime
	self.day_count = other.day_count
	self.start_time = other.start_time
end)

function State:add_us_time(us)
	self.us_time = self.us_time + us
	local gametime = self.gametime
	gametime = gametime + (us * (tonumber(core.settings:get("time_speed")) or 72) / 1e6)
	self.day_count = self.day_count + math.floor(gametime)
	self.gametime = gametime % 1
end
