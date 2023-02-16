modtest API

* `modtest.with_environment = fuction(description, callback)`

  runs the callback w/ a fresh copy of the modtest environment. e.g.

  ```lua
  modtest.with_environment("run some tests in the modtest environment", function()
    it("node is defined", function()
      assert.is_not_nil(minetest.registered_nodes["example_mod:node"])
    end)
  end)
  ```

##### player API

* `modtest.api.create_player = function(player_name, password)`
* `modtest.api.try_join_player = function(name, password, connection_info)`
* `modtest.api.time_out_player = function(name)`

* `modtest.api.register_on_shown_formspec = function(callback)`

##### async

* `modtest.api.run_next_async_job = function()`

##### step

* `modtest.api.trigger_globalstep = function()`

##### time

* `modtest.api.add_us_time = function(us)`

##### log messages

* `modtest.api.log_messages = {}`

##### access mapblocks

* `modtest.api.get_mapblock = function(blockpos)`
* `modtest.api.load_mapblock = function(blockpos)`
* `modtest.api.unload_mapblock = function(blockpos)`
* `modtest.api.remove_mapblock = function(blockpos)`
* `modtest.api.activate_mapblock = function(blockpos)`
* `modtest.api.deactivate_mapblock = function(blockpos)`

##### mod_storage

* `modtest.api.clear_storage = function(modname)`

##### rollback

* `modtest.api.record_rollback_action = function(pos, action)`

##### general state

* `modtest.api.set_current_modname = function(name)`
* `modtest.api.set_last_run_mod = function(name)`
* `modtest.api.set_all_modpaths = function(modpaths)`
