# warn about things to help us catch typos.
MAKEFLAGS += --warn-undefined-variables --warn-undefined-functions

# where is this folder?
orig-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
current-dir = $(orig-dir)

# allow node's module resolution algorithm to be used for includes.
#
# eval is slightly quirky in that any variables defined in an eval don't actually
# get set until after the entire eval has run. so we need to split require into
# four parts that are eval'd separately.
#
# all this dancing around is to make sure that current-dir is actually the
# directory of the current makefile, without messing around with MAKEFILE_LISTs
# at tops of makefiles.
define ~require-pre
include-path = $(shell $(orig-dir)resolve.js $(1) $(current-dir))
prev-dir = $(current-dir)
endef

define ~require-pre-2
current-dir = $(dir $(include-path))
endef

define ~require-post
current-dir = $(prev-dir)
endef

define ~require
$(eval $(~require-pre))
$(eval $(~require-pre-2))
include $(include-path)
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
$(call require, ./variables)

# set current-dir to pwd so that the originating makefile has it correct
current-dir = $(shell pwd)
