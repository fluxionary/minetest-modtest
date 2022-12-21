in modtest itself
-----------------

consider modtest non-functional until this comment is removed.


in lua_api.txt
--------------

* active object reference
  * `get_formspec_prepend(formspec)` -- doesn't actually take an argument
  * `hud_get_hotbar_itemcount` missing parens
  * `hud_get_hotbar_image` missing parens
  * `hud_get_hotbar_selected_image` missing parens
* environment access
  * `minetest.get_node_light(pos, timeofday)` should be `minetest.get_node_light(pos[, timeofday])`
