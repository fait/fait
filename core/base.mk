#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   base.mk
#
#   Best practices and sensible defaults for makefiles.
#
#   Set main as the default target, i.e. the target that runs when make is called
#   with no arguments.
.DEFAULTGOAL := main
#
#   Warn about undefined things to help us catch typos.
MAKEFLAGS += --warn-undefined-variables --warn-undefined-functions
#
#   Add node_modules to `$PATH` so we don't have to prefix it everywhere. Also set
#   the shell because macOS's make seems to need it for `$PATH` to work.
export SHELL := /bin/bash
export PATH := $(shell npm bin):$(PATH)
#
#   Disable built-in rules. we probably don't need them and they clutter up e.g.
#   debug output.
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules
#
#   Secondary expansion is really really useful and doesn't get in people's way
#   if they don't want to use it.
.SECONDEXPANSION: