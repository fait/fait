#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   utilities.mk
#   
#   Functions to *make* your life easier.
#
#   Add a folder to the shell PATH.
define register-bin
export PATH := $(1):$(PATH)
endef
#
#   Add this module's npm bin to the shell PATH.
define register-npm-bin
$(eval $(call register-bin, $(~module-dir)node_modules/.bin))
endef
#
#   Filter by match
define filter-match
$(foreach v,$(2),$(if $(findstring $(1),$(v)),$(v),))
endef
#
#   Filter out by match
define filter-out-match
$(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))
endef
#
#   Automatically create a target's folder
make-target-dir = @mkdir -p $(@D)
#
#   Backwards compatibility for 1.2
mkdir = $(make-target-dir)
#
#   Get variables that weren't defined at the start of the make session
user-defined-variables = $(filter-out $(~built-in-variables), $(.VARIABLES))
#
#   Export given variables
define export-variables
$(eval export ~dummy $(1))
endef
#
#   Provide installed version of current module
module-version = $(shell awk -v FS=\" '/"version": ".+"/ { print $$4 }' $(~module-dir)package.json)
