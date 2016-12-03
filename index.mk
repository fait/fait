# The only currently-defined variables are built-ins.
~built-in-variables := $(.VARIABLES)

# warn about things to help us catch typos.
MAKEFLAGS += --warn-undefined-variables --warn-undefined-functions

# where is this folder?
~orig-file := $(abspath $(lastword $(MAKEFILE_LIST)))
~orig-dir := $(dir $(~orig-file))

# for requires in this file we want module-file to point to this directory
~module-file := $(~orig-file)

# the directory of the current file
~module-dir = $(dir $(~module-file))

define ~require-pre
~prev-module-file := $(~module-file)
~module-file := $(shell $(~orig-dir)resolve.js $(1) $(~module-dir))
endef

define ~require-post
~module-file := $(~prev-module-file)
endef

# allow node's module resolution algorithm to be used for includes.
#
# eval is slightly weird in that any variables defined in an eval don't actually
# get set until after the entire eval has run. so we need to split require into
# several parts that are eval'd separately.
#
# all this dancing around is to make sure that current-dir is actually the
# directory of the current makefile, without messing around with MAKEFILE_LISTs
# at tops of makefiles.
define ~require
$(eval $(~require-pre))

$(if $(findstring ✘, $(~module-file)), $(eval $(error $(~module-file))),)

$(eval -include $(~module-file))
$(eval $(~require-post))
endef

require = $(eval $(call ~require, $(1)))

# add node_modules to $PATH so we don't have to prefix it everywhere. also set
# the shell because mac os seems to need it for path to work
export SHELL := /bin/bash
export PATH := $(shell npm bin):$(PATH)

# disable built-in rules. we probably don't need them and they clutter up e.g.
# debug output.
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

# secondary expansion is really really useful and doesn't get in people's way
# if they don't want to use it
.SECONDEXPANSION:

# load fait's utilities
$(call require, ./utilities)

# provide installed version of current module
module-version = $(shell awk -v FS=\" '/"version": ".+"/ { print $$4 }' $(~module-dir)package.json)

fait-version := $(module-version)

# immediately after this file we're in the entry makefile. it's not been required
# so prev-include-path won't usually be set for it. we know it's the first
# makefile in the list by definition though.
~module-file := $(abspath $(firstword $(MAKEFILE_LIST)))

# dummy task to ensure that main is always defined first, i.e. is what runs when
# make is run with no arguments
main :: ; @:

# this is in the bootstrap, but just in case, define it here as well. when trying
# to include a module, install it if it doesn't exist or package.json has changed
node_modules/%/index.mk: package.json
	npm install $*
