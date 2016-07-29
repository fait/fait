# allow node's module resolution algorithm to be used for includes.
require = $(eval include $(shell ./resolve.js $(1)))

# disable built-in rules. we probably don't need them and they clutter up e.g.
# debug output.
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

# warn about things to help us catch typos.
MAKEFLAGS += --warn-undefined-variables --warn-undefined-functions
