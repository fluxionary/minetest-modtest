# modtest

a framework for testing minetest mods.

***WARNING*** this is currently far from complete. there is some prior work here that doesn't achieve the goals of
this project, but you may be interested in them:
* [mineunit](https://github.com/S-S-X/mineunit)
* [mtt](https://github.com/buckaroobanzay/mtt)

## what's modtest do?

* provides a command-line utility for running tests on minetest mods. it uses
  [busted](https://lunarmodules.github.io/busted/) under the hood, as that seems to be the most preferred lua testing
  api, and it seems well maintained.
* aims to provide full support for the minetest lua API, without actually requiring a functional engine.

  this means, that lua API calls actually do something, and engine events can be triggered through a callback API.

## why does it exist?

it's meant as a way of running tests on a mod whenever you try to commit, using a utility like [pre-commit](????).
if your update fails the tests, or if there's code that isn't covered by tests, your commit will be rejected.

## how do i use it?

### some goals

* the user (someone designing tests for a mod or a server) shouldn't have to understand anything more than:
  * the minetest lua API
  * busted, a lua testing framework
  * a minimal framework for triggering events

### dependencies

* luajit 2.1-beta
  * lua 5.1 might also work fine, but that is not tested.
* busted

  busted is most easily installed via luarocks. use your favorite search engine to look that up.

* some version of the minetest engine

  we only need the "builtin" lua code from the engine, but that's not distributed otherwise.

### how to use modtest, ad-hoc

```shell
modtest --builtin PATH/TO/builtin \
        --conf PATH/TO/minetest.conf \
        --game PATH/TO/world \
        --mods PATH/TO/mods \
        --world PATH/TO/world \
        PATH/TO/mod_to_test
```

* `builtin` should be a path to some version of minetest's "builtin" lua code. if not supplied, we will check in
  `$HOME/.minetest/builtin` and then `/usr/share/minetest/builtin`. if those are also not present, modtest will  abort
  with an error.
* `conf` is a path to a "minetest.conf" file. this parameter is optional. if the file
  `PATH/TO/mod_to_test/modtest/minetest.conf` exists, that will be used unless overridden.
* `world` is a path to a minetest world folder. TODO: more doc
* `game` is a path to a minetest game. if not specified, we try to infer this from the specified world. TODO: more doc
* `mods` is a path to a minetest mods folder. TODO: more doc

### how to set up a mod repo w/ modtest configuration

if you're me (flux), you use [init_mod](???) to create your mods, and the boilerplate is provided automatically.

if you're not using init_mod, you create a subdir of your mod like the following:

```
modtest/
        init.lua
        game/
             game.conf
             mods/
                  null/
                       mod.conf
                       init.lua
        mods/
             ...
        tests/
              ...
        world/
              world.mt
```

* `init.lua` is optional, and is used to initialize global properties and utility functions for the tests
* `game/` is a
