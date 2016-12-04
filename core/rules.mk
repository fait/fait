#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   rules.mk
#
#   fait's built-in rules. Currently there's only one of these but there may be more
#   in the future.
#
#   This is in the bootstrap, but just in case, define it here as well. When trying
#   to include a module, install it if it doesn't exist or package.json has changed.
node_modules/%/index.mk: package.json
	npm install $*
