in modtest itself
-----------------

consider modtest non-functional until this comment is removed.

* need to implement io restrictions properly-ish
* need to figure out how to restrict "print" properly w/out it breaking busted's output
* the architecture probably needs a bit of a refactor before i get too much further. we're at the point where
  the location of some code seems partially arbitrary.

in lua_api.txt
--------------

https://github.com/minetest/minetest/pull/13240

* active object reference
  * `get_formspec_prepend(formspec)` -- doesn't actually take an argument
  * `hud_get_hotbar_itemcount` missing parens
  * `hud_get_hotbar_image` missing parens
  * `hud_get_hotbar_selected_image` missing parens
* environment access
  * `minetest.get_node_light(pos, timeofday)` should be `minetest.get_node_light(pos[, timeofday])`
* minetest.get_player_information(player_name)
  * missing `,` after `lang_code = "fr"`
