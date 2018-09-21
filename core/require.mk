#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   require.mk
#
#   This file defines a require function that behaves much like node.js' require:
#
#     1. If any of these rules resolve to a folder, search for index.mk or the main
#        field from package.json in the folder if it exists.
#     2. Relative paths (prefixed with `./` or `../`) are searched for relative to the
#        file that called require.
#     3. Non-relative paths are searched for in node_modules in the directory of the
#        file that called require, or node_modules in its ancestors.
#
#   Most of this functionality is provided by resolve.js and the resolve module on npm.
#
#   For requires relative to the current file/directory, we need to know where that
#   is. Make doesn't provide any way of doing that apart for `MAKEFILE_LIST`, which is
#   only usable if queried in each file at the very top, before any includes. Since
#   we don't want modules to have to have any boilerplate, that's out of the question.
#
#   However, we know right before requiring a file where it is. That can inform
#   relative requires in the module itself. So we need to wrap require in functions
#   that set a variable to the required file and restore that variable to the previous
#   value after the require.
#
#   In `~require-pre`, we store the old `~module-file` so it can be restored by
#   `~require-post`, and we shell out to resolve.js to perform the actual module search.
define ~require-pre
~prev-module-file := $(~module-file)
~module-file := $(shell $(~orig-dir)resolve.js $(1) $(~module-dir))
endef
#
#   Restore the old ~module-file after a require.
define ~require-post
~module-file := $(~prev-module-file)
endef
#
#   Perform the actual include, wrapped in pre and post, and handle errors from
#   resolve.js.
#
#   We need to be really careful about ordering here. Although this is a multi-line
#   eval, it's still evaluated all at once, so variables defined in here aren't
#   actually set until it's all been evaluated. That's why pre and post need to be
#   separate functions. We also need to eval the include, even though the whole
#   function is eval'd, so it actually happens between pre and post, and not after.
#
#   Finally, it's a conditional include to support lazy installation of modules. If
#   a require call that looks like a bare module is run but the file isn't found,
#   resolve.js returns the likely path anyway instead of erroring. The nonexistent
#   include file is then made by the target in rules.mk, which installs the probable
#   module name from npm. This allows first use of fait without installing the entire
#   dependency tree.
define ~require
$(eval $(~require-pre))

$(if $(findstring ✘, $(~module-file)), $(eval $(error $(~module-file))),)

$(eval -include $(~module-file))
$(eval $(~require-post))
endef
#
#   Wrap `~require` itself in an eval so it can be used with just call.
require = $(eval $(call ~require, $(1)))
