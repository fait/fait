#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   require.mk

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