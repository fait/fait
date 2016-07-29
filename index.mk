# allow node's module resolution algorithm to be used for includes.
require = $(eval include $(shell ./resolve.js $(1)))

# add node_modules to $PATH so we don't have to prefix it everywhere. also set
# the shell because mac os seems to need it for path to work
export SHELL := /bin/bash
export PATH := $(shell npm bin):$(PATH)

# disable built-in rules. we probably don't need them and they clutter up e.g.
# debug output.
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

# warn about things to help us catch typos.
MAKEFLAGS += --warn-undefined-variables --warn-undefined-functions

# secondary expansion is really really useful and doesn't get in people's way
# if they don't want to use it
.SECONDEXPANSION:

# load fait's utilities
$(call require, ./variables.mk)
