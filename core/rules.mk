#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   rules.mk
#
#   fait's built-in rules, to define main and ensure the npm installer is set up
#   if it's been removed from the bootstrap.
#
#   Dummy task to ensure that main is always defined first, i.e. is what runs when
#   make is run with no arguments.
main :: ; @:
#
#   This is in the bootstrap, but just in case, define it here as well. When trying
#   to include a module, install it if it doesn't exist or package.json has changed.
node_modules/%/index.mk: package.json
	npm install $*
