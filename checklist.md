what has been implemented, even as a stub:

* classes
  * [x] AreaStore
    * [ ] _init
    * [ ] get_area
    * [ ] get_areas_for_pos
    * [ ] get_areas_in_area
    * [ ] insert_area
    * [ ] reserve
    * [ ] remove_area
    * [ ] set_cache_params
    * [ ] to_string
    * [ ] to_file
    * [ ] from_string
    * [ ] from_file

  * [x] EntityRef
    * [x] remove
    * [x] set_velocity
    * [x] add_velocity
    * [x] get_velocity
    * [x] set_acceleration
    * [x] get_acceleration
    * [x] set_rotation
    * [x] get_rotation
    * [x] set_yaw
    * [x] get_yaw
    * [x] set_texture_mod
    * [x] get_texture_mod
    * [x] set_sprite
    * [x] get_entity_name
    * [x] get_luaentity

  * [x] InvRef
    * [x] is_empty
    * [x] get_size
    * [x] get_width
    * [x] set_size
    * [x] set_width
    * [x] get_stack
    * [x] set_stack
    * [x] get_list
    * [x] set_list
    * [x] get_lists
    * [x] set_lists
    * [x] add_item
    * [x] room_for_item
    * [x] contains_item
    * [x] remove_item
    * [x] get_location

  * [x] ItemStack
    * [x] _init
    * [x] is_empty
    * [x] get_name
    * [x] set_name
    * [x] get_count
    * [x] set_count
    * [x] get_wear
    * [x] set_wear
    * [x] get_meta
    * [ ] get_metadata
    * [ ] set_metadata
    * [x] get_description
    * [x] get_short_description
    * [x] clear
    * [x] replace
    * [x] to_string
    * [x] to_table
    * [x] get_stack_max
    * [x] get_free_space
    * [x] is_known
    * [x] get_definition
    * [x] get_tool_capabilities
    * [x] add_wear
    * [x] add_wear_by_uses
    * [x] add_item
    * [x] item_fits
    * [x] take_item
    * [x] peek_item

  * [x] ItemStackMetaRef
    * [x] set_tool_capabilities

  * [x] MetaDataRef
    * [x] contains
    * [x] get
    * [x] get_string
    * [x] set_string
    * [x] get_int
    * [x] set_int
    * [x] get_float
    * [x] set_float
    * [x] to_table
    * [x] from_table
    * [x] equals

  * [x] ModChannel
    * [ ] _init
    * [ ] leave
    * [ ] send_all
    * [ ] is_writeable

  * [x] NodeMetaRef
    * [x] get_inventory
    * [x] mark_as_private

  * [x] NodeTimerRef
    * [ ] set
    * [ ] start
    * [ ] stop
    * [ ] is_started
    * [ ] get_timeout
    * [ ] get_elapsed

  * [x] ObjectRef
    * [x] get_pos
    * [x] set_pos
    * [x] move_to
    * [ ] punch
    * [ ] right_click
    * [ ] set_hp
    * [x] get_hp
    * [x] set_armor_groups
    * [x] get_armor_groups
    * [x] set_animation
    * [x] get_animation
    * [x] set_local_animation
    * [x] get_local_animation
    * [x] set_eye_offset
    * [x] get_eye_offset
    * [x] send_mapblock
    * [x] set_animation_frame_speed
    * [ ] set_bone_position
    * [ ] get_bone_position
    * [ ] set_attach
    * [ ] get_attach
    * [ ] get_children
    * [ ] set_detach
    * [x] is_player
    * [x] set_properties
    * [x] get_properties
    * [x] set_nametag_attributes
    * [x] get_nametag_attributes

    * [x] remove
    * [x] set_velocity
    * [x] add_velocity
    * [x] get_velocity
    * [x] set_acceleration
    * [x] get_acceleration
    * [x] set_rotation
    * [x] get_rotation
    * [x] set_yaw
    * [x] get_yaw
    * [x] set_texture_mod
    * [x] get_texture_mod
    * [x] set_sprite
    * [x] get_entity_name
    * [x] get_luaentity

    * [x] get_inventory
    * [x] get_wield_list
    * [x] get_wield_index
    * [x] get_wielded_item
    * [x] set_wielded_item
    * [x] get_player_name
    * [x] get_look_dir
    * [x] get_look_pitch
    * [x] get_look_yaw
    * [x] get_look_vertical
    * [x] get_look_horizontal
    * [x] set_look_vertical
    * [x] set_look_horizontal
    * [x] set_look_pitch
    * [x] set_look_yaw
    * [x] set_fov
    * [x] get_fov
    * [x] set_breath
    * [x] get_breath
    * [x] set_attribute
    * [x] get_attribute
    * [x] get_meta
    * [x] set_inventory_formspec
    * [x] get_inventory_formspec
    * [x] set_formspec_prepend
    * [x] get_formspec_prepend
    * [x] get_player_control
    * [x] get_player_control_bits
    * [x] set_physics_override
    * [x] get_physics_override
    * [x] hud_add
    * [x] hud_remove
    * [x] hud_change
    * [x] hud_get
    * [x] hud_set_flags
    * [x] hud_get_flags
    * [x] hud_set_hotbar_itemcount
    * [x] hud_get_hotbar_itemcount
    * [x] hud_set_hotbar_image
    * [x] hud_get_hotbar_image
    * [x] hud_set_hotbar_selected_image
    * [x] hud_get_hotbar_selected_image
    * [x] set_sky
    * [x] get_sky
    * [x] get_sky_color
    * [x] set_sun
    * [x] get_sun
    * [x] set_moon
    * [x] get_moon
    * [x] set_stars
    * [x] get_stars
    * [x] set_clouds
    * [x] get_clouds
    * [x] override_day_night_ratio
    * [x] get_day_night_ratio
    * [x] set_minimap_modes
    * [x] set_lighting
    * [x] get_lighting
    * [x] respawn

  * [ ] PcgRandom
    * [ ] _init
    * [ ] next
    * [ ] rand_normal_dist

  * [ ] PerlinNoise
    * [ ] _init
    * [ ] get_2d
    * [ ] get_3d

  * [ ] PerlinNoiseMap
    * [ ] _init
    * [ ] get_2d_map
    * [ ] get_2d_map_flat
    * [ ] get_3d_map
    * [ ] get_3d_map_flat
    * [ ] calc_2d_map
    * [ ] calc_3d_map
    * [ ] get_map_slice

  * [ ] PlayerRef
    * [x] get_inventory
    * [x] get_wield_list
    * [x] get_wield_index
    * [x] get_wielded_item
    * [x] set_wielded_item
    * [x] get_player_name
    * [x] get_look_dir
    * [x] get_look_pitch
    * [x] get_look_yaw
    * [x] get_look_vertical
    * [x] get_look_horizontal
    * [x] set_look_vertical
    * [x] set_look_horizontal
    * [x] set_look_pitch
    * [x] set_look_yaw
    * [x] set_fov
    * [x] get_fov
    * [x] set_breath
    * [x] get_breath
    * [x] set_attribute
    * [x] get_attribute
    * [x] get_meta
    * [x] set_inventory_formspec
    * [x] get_inventory_formspec
    * [x] set_formspec_prepend
    * [x] get_formspec_prepend
    * [x] get_player_control
    * [x] get_player_control_bits
    * [x] set_physics_override
    * [x] get_physics_override
    * [x] hud_add
    * [x] hud_remove
    * [x] hud_change
    * [x] hud_get
    * [x] hud_set_flags
    * [x] hud_get_flags
    * [x] hud_set_hotbar_itemcount
    * [x] hud_get_hotbar_itemcount
    * [x] hud_set_hotbar_image
    * [x] hud_get_hotbar_image
    * [x] hud_set_hotbar_selected_image
    * [x] hud_get_hotbar_selected_image
    * [x] set_sky
    * [x] get_sky
    * [x] get_sky_color
    * [x] set_sun
    * [x] get_sun
    * [x] set_moon
    * [x] get_moon
    * [x] set_stars
    * [x] get_stars
    * [x] set_clouds
    * [x] get_clouds
    * [x] override_day_night_ratio
    * [x] get_day_night_ratio
    * [x] set_minimap_modes
    * [x] set_lighting
    * [x] get_lighting
    * [ ] respawn

  * [x] PlayerMetaRef

  * [x] PseudoRandom
    * [ ] _init
    * [ ] next

  * [x] Raycast
    * [ ] _init
    * [ ] next

  * [ ] SecureRandom
    * [ ] _init
    * [ ] next_bytes

  * [x] Settings
    * [x] _init
    * [x] get
    * [x] get_bool
    * [ ] get_np_group
    * [ ] get_flags
    * [x] set
    * [x] set_bool
    * [ ] set_np_group
    * [x] remove
    * [x] get_names
    * [x] write
    * [x] to_table

  * [x] StorageRef

  * [x] vector (mostly part of builtin)

  * [x] VoxelArea (part of builtin)

  * [x] VoxelManip
    * [ ] _init
    * [ ] read_from_map
    * [ ] get_data
    * [ ] set_data
    * [ ] write_to_map
    * [ ] get_node_at
    * [ ] set_node_at
    * [ ] update_liquids
    * [ ] calc_lighting
    * [ ] set_lighting
    * [ ] get_light_data
    * [ ] set_light_data
    * [ ] get_param2_data
    * [ ] set_param2_data
    * [ ] update_map
    * [ ] was_modified
    * [ ] get_emerged_area

* core
  * async
    * [x] do_async_callback
    * [x] register_async_dofile

  * entity
    * [x] add_entity
    * [x] add_item
    * [x] clear_objects
    * [x] get_objects_in_area
    * [x] get_objects_inside_radius

  * globalstep
    * this is actually just api code to trigger random stuff

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
      * [x] get_dig_params
      * [x] get_hit_params
      * [x] get_tool_wear_after_use
    * [ ] get_translated_string
    * [x] is_yes

  * inventory
    * [x] create_detached_inventory_raw
    * [x] get_inventory
    * [x] remove_detached_inventory_raw

  * item
    * crafting
      * [ ] clear_craft
      * [ ] get_all_craft_recipes
      * [ ] get_craft_recipe
      * [ ] get_craft_result
      * [ ] register_craft
    * [ ] get_content_id
    * [ ] get_name_from_content_id
    * [x] register_alias_raw
    * [x] register_item_raw
    * [x] unregister_item_raw

  * log
    * [x] log
    * [x] print

  * map
    * [x] add_node
    * [ ] add_node_level
    * [x] bulk_set_node
    * [x] compare_block_status
    * [x] delete_area
    * [x] dig_node
    * [x] find_node_near
    * [x] find_nodes_in_area
    * [x] find_nodes_in_area_under_air
    * [ ] find_nodes_with_meta
    * [ ] fix_light
    * [ ] forceload_block
    * [ ] forceload_free_block
    * [x] get_meta
    * [x] get_natural_light
    * [x] get_node
    * [ ] get_node_level
    * [ ] get_node_light
    * [ ] get_node_max_level
    * [ ] get_node_or_nil
    * [x] get_node_timer
    * [x] get_voxel_manip
    * [x] load_area
    * [x] place_node
    * [x] punch_node
    * [x] remove_node
    * [x] set_node
    * [ ] set_node_level
    * [x] swap_node
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
    * [x] get_mod_storage

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
    * [x] add_particle
    * [x] add_particlespawner
    * [x] delete_particlespawner

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
    * [x] get_connected_players
    * [x] get_player_by_name
    * [ ] get_player_information
    * [ ] get_player_ip
    * [ ] get_player_privs
    * [ ] show_formspec

  * rollback
    * [ ] rollback_get_node_actions
    * [ ] rollback_revert_actions_by

  * state
    * [x] get_builtin_path
    * [x] get_current_modname
    * [x] get_last_run_mod
    * [x] get_modnames
    * [x] get_modpath
    * [x] get_server_max_lag
    * [x] get_server_status
    * [x] get_user_path
    * [x] get_version
    * [x] get_worldpath
    * [x] is_singleplayer
    * [x] set_last_run_mod
    * [x] request_shutdown

  * time
    * [x] get_day_count
    * [x] get_gametime
    * [x] get_server_uptime
    * [x] get_timeofday
    * [x] get_us_time
    * [x] set_timeofday

  * unknown
    * [ ] serialize_roundtrip
