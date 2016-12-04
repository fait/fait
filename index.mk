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
#   Hopefully, this is the first variable Make sees, so the only currently-defined
#   variables are built-ins.
~built-in-variables := $(.VARIABLES)
#
#   This is the only point we can assume that the last-included makefile is the current
#   one, so let's take this opportunity to find out where it is and what directory it's
#   in. 
~orig-file := $(abspath $(lastword $(MAKEFILE_LIST)))
~orig-dir := $(dir $(~orig-file))
~entry-makefile := $(abspath $(firstword $(MAKEFILE_LIST)))
~including-makefile := $(abspath $(lastword $(filter-out $(lastword $(MAKEFILE_LIST)), $(MAKEFILE_LIST))))
#
#   Shell out to chalk to format colours.
~chalk = $(shell /usr/bin/env FORCE_COLOR=1 $(~orig-dir)node_modules/.bin/chalk $(1) $(2))
#
#   Somewhat nicer error messages.
~error = $(eval $(error $(call ~chalk, red, ✘)$(1)))
#
#   Not being included from the entry makefile breaks a number of assumptions we've made,
#   so we need to assert that that's the case.
ifneq ($(~including-makefile),$(~entry-makefile))
define ~error-message
$(call ~chalk, grey bold, "fait must be included from the entry makefile")

Expected include in: $(call ~chalk, cyan italic, $(~entry-makefile))
Include actually in: $(call ~chalk, cyan italic, $(~including-makefile))
endef
$(call ~error, $(~error-message))
endif
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
