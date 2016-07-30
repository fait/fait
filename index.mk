# warn about things to help us catch typos.
MAKEFLAGS += --warn-undefined-variables --warn-undefined-functions

# where is this folder?
~current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(warning $(~current-dir))

# allow node's module resolution algorithm to be used for includes.
define require
$(eval ~include-path = $(shell $(~current-dir)resolve.js $(1) $(~current-dir)))
$(eval ~prev-dir := $(~current-dir))
$(eval ~current-dir := $(dir $(~include-path)))
$(eval $(warning include-path:$(~include-path) prev-dir:$(~prev-dir) current-dir:$(~current-dir)))
$(eval include $(~include-path))
$(eval ~current-dir := $(~prev-dir))
endef

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
