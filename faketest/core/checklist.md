what has been implemented, even as a stub:
* async
  * [ ] do_async_callback
  * [ ] register_async_dofile

* entity
  * [ ] add_entity
  * [ ] add_item
  * [ ] clear_objects
  * [ ] get_objects_in_area
  * [ ] get_objects_inside_radius

* globalstep

* helpers
  * 3d algorithms
    * [ ] find_path
    * [ ] line_of_sight
    * [ ] raycast
  * base64
    * [ ] decode_base64
    * [ ] encode_base64
  * colorspec
    * [ ] colorspec_to_bytes
    * [ ] colorspec_to_colorstring
  * compression
    * [ ] compress
    * [ ] decompress
  * json
    * [ ] parse_json
    * [ ] write_json
  * png
    * [ ] encode_png
  * sha1
    * [ ] sha1
  * tool_use
    * [ ] get_dig_params
    * [ ] get_hit_params
    * [ ] get_tool_wear_after_use
  * [ ] get_translated_string
  * [ ] is_yes

* inventory
  * [ ] create_detached_inventory_raw
  * [ ] get_inventory
  * [ ] remove_detached_inventory_raw

* item
  * crafting
    * [ ] clear_craft
    * [ ] get_all_craft_recipes
    * [ ] get_craft_recipe
    * [ ] get_craft_result
    * [ ] register_craft
  * [ ] register_alias_raw
  * [ ] register_item_raw
  * [ ] unregister_item_raw

* log
  * [ ] log
  * [ ] print

* map
  * [ ] add_node
  * [ ] add_node_level
  * [ ] bulk_set_node
  * [ ] compare_block_status
  * [ ] delete_area
  * [ ] dig_node
  * [ ] find_node_near
  * [ ] find_nodes_in_area
  * [ ] find_nodes_in_area_under_air
  * [ ] find_nodes_with_meta
  * [ ] fix_light
  * [ ] forceload_block
  * [ ] forceload_free_block
  * [ ] get_content_id
  * [ ] get_meta
  * [ ] get_name_from_content_id
  * [ ] get_natural_light
  * [ ] get_node
  * [ ] get_node_level
  * [ ] get_node_light
  * [ ] get_node_max_level
  * [ ] get_node_or_nil
  * [ ] get_node_timer
  * [ ] get_voxel_manip
  * [ ] load_area
  * [ ] place_node
  * [ ] punch_node
  * [ ] remove_node
  * [ ] set_node
  * [ ] set_node_level
  * [ ] swap_node
  * [ ] transforming_liquid_add

* mapgen
  * biome
    * [ ] clear_registered_biomes
    * [ ] get_biome_data
    * [ ] get_biome_id
    * [ ] get_biome_name
    * [ ] register_biome
  * decoration
    * [ ] clear_registered_decorations
    * [ ] generate_decorations
    * [ ] get_decoration_id
    * [ ] register_decoration
  * noise
    * [ ] get_noiseparams
    * [ ] get_perlin
    * [ ] get_perlin_map
    * [ ] set_noiseparams
  * ore
    * [ ] clear_registered_ores
    * [ ] generate_ores
    * [ ] register_ore
  * schematic
    * [ ] clear_registered_schematics
    * [ ] create_schematic
    * [ ] place_schematic
    * [ ] place_schematic_on_vmanip
    * [ ] read_schematic
    * [ ] register_schematic
    * [ ] serialize_schematic
  * settings
    * [ ] get_mapgen_params
    * [ ] get_mapgen_setting
    * [ ] get_mapgen_setting_noiseparams
    * [ ] set_mapgen_params
    * [ ] set_mapgen_setting
    * [ ] set_mapgen_setting_noiseparams
  * tree
    * [ ] spawn_tree
  * [ ] emerge_area
  * [ ] get_gen_notify
  * [ ] get_heat
  * [ ] get_humidity
  * [ ] get_mapgen_object
  * [ ] get_spawn_level
  * [ ] set_gen_notify

* mod_channel
  * [ ] mod_channel_join

* mod_storage
  * [ ] get_mod_storage

* os
  * insecure
    * [ ] request_http_api
    * [ ] request_insecure_environment
    * [ ] set_http_api_lua
  * [ ] cpdir
  * [ ] get_dir_list
  * [ ] mkdir
  * [ ] mvdir
  * [ ] rmdir
  * [ ] safe_file_write

* particle
  * [ ] add_particle
  * [ ] add_particlespawner
  * [ ] delete_particlespawner

* player
  * auth
    * [ ] check_password_entry
    * [ ] get_password_hash
    * [ ] notify_authentication_modified
    * [ ] remove_player
  * ban
    * [ ] ban_player
    * [ ] get_ban_description
    * [ ] get_ban_list
    * [ ] unban_player_or_ip
  * chat
    * [ ] chat_send_all
    * [ ] chat_send_player
  * sound
    * [ ] sound_fade
    * [ ] sound_play
    * [ ] sound_stop
  * [ ] disconnect_player
  * [ ] dynamic_add_media
  * [ ] get_connected_players
  * [ ] get_player_by_name
  * [ ] get_player_information
  * [ ] get_player_ip
  * [ ] get_player_privs
  * [ ] show_formspec

* rollback
  * [ ] rollback_get_node_actions
  * [ ] rollback_revert_actions_by

* state
  * [ ] get_builtin_path
  * [ ] get_current_modname
  * [ ] get_last_run_mod
  * [ ] get_modnames
  * [ ] get_modpath
  * [ ] get_server_max_lag
  * [ ] get_server_status
  * [ ] get_user_path
  * [ ] get_version
  * [ ] get_worldpath
  * [ ] is_singleplayer
  * [ ] set_last_run_mod
  * [ ] request_shutdown

* time
  * [ ] get_day_count
  * [ ] get_gametime
  * [ ] get_server_uptime
  * [ ] get_timeofday
  * [ ] get_us_time
  * [ ] set_timeofday

* unknown
  * [ ] serialize_roundtrip
