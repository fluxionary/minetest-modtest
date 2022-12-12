# modtest

a framework for testing minetest mods

## what's it do?

* provides a command-line utility for running tests on minetest mods. it uses
  [busted](https://lunarmodules.github.io/busted/) under the hood.
* aims to provide full support for the minetest lua API, without actually requiring a functional engine.

  engine events can be triggered through a callback API

## how to use it?

### dependencies

* luajit 2.1-beta
  * lua 5.1 might also work fine, but that is not tested.
* busted

  most easily installed via luarocks

* some version of the minetest engine

  we need the "builtin" lua from it.

### how to use it ad-hoc

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

### how to set up a mod directory w/ modtest configuration
