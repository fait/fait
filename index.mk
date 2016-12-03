#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   index.mk
#
#   The main entry point for fait. This file should only contain:
#
#     1. Variables that need to be in the entry point so we can set up folder detection
#     2. Includes/requires of things in core
#
#   Not being included from the entry makefile breaks a number of assumptions we've made,
#   so we need to assert that that's the case.
ifneq ($(words $(MAKEFILE_LIST)),2)
$(error fait must be included from the entry makefile)
endif
#
#   Hopefully, this is the first variable Make sees, so the only currently-defined
#   variables are built-ins.
~built-in-variables := $(.VARIABLES)
#
#   This is the only point we can assume that the last-included makefile is the current
#   one, so let's take this opportunity to find out where it is and what directory it's
#   in. 
~orig-file := $(abspath $(lastword $(MAKEFILE_LIST)))
~orig-dir := $(dir $(~orig-file))
#
#   ~module-file and ~module-dir are how makefile-relative requires work. They usually
#   get set by require itself but this file's just been included.
~module-file := $(~orig-file)
~module-dir = $(dir $(~module-file))
#
#   Load fait core. Of course, we couldn't require require unless we'd already required require.
include $(~orig-dir)core/require.mk
$(call require, ./core/base)
$(call require, ./core/utilities)
$(call require, ./core/rules)
#
#   Need to be in the same directory as package.json to get the version.
fait-version := $(module-version)
#
#   Immediately after this file we're in the entry makefile. Usually, ~module-file would
#   be restored by ~post-require but that won't work here. We know that the entry file
#   is the first one in the MAKEFILE_LIST, so we can use that.
~module-file := $(abspath $(firstword $(MAKEFILE_LIST)))
