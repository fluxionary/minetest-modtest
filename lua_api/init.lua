local api = {}

function api.initialize_modtest_state()
	-- # async
	api.async_env = nil
	api.async_jobs = modtest.Deque()
	api.async_results = {}

	-- # inventory
	api.player_inventories = {}
	api.node_inventories = {}
	api.detached_inventories = {}

	-- # item/item
	api.registered_alias_raws = {}

	api.registered_item_raws = {}
	api.content_id_by_name = {}
	api.available_content_ids = {}
	api.available_unknown_content_ids = {}

	for i = 0, 32767 do
		if i < 125 or i > 127 then
			api.available_content_ids[i] = true
		end
	end

	api.content_id_by_name["unknown"] = 125
	api.content_id_by_name["air"] = 126
	api.content_id_by_name["ignore"] = 127

	for i = 32768, 65535 do
		api.available_unknown_content_ids[i] = true
	end

	-- # log
	-- internal log messages chan either be a string (from print()) or {level = level, message = message} (log())
	modtest.api.log_messages = modtest.Deque()

	-- # map
	api.map = {}

	-- # player/auth
	api.auth_entries = {}

	-- # player/player
	api.registered_players = {}
	api.connected_players = {}

	-- # state
	api.current_modname = nil -- i think it's nil by default?
	api.last_run_mod = nil
	api.all_modnames = {}
	api.all_modpaths = {}

	-- # time
	api.us_time = 0
	api.gametime = tonumber(core.settings:get("world_start_time")) / 24000 -- in [0, 1)
	api.day_count = 0
	api.start_time = os.actual_time()
end

function modtest.initialize_environment()
	modtest.api = api

	modtest.dofile("lua_api", "classes", "init")
	modtest.dofile("lua_api", "core", "init")

	api.initialize_modtest_state()

	INIT = "game"

	modtest.doexternal(modtest.args.builtin, "init")
end
