#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   bootstrap
#
#  install missing modules
node_modules/%/index.mk: package.json ; npm install $* ; touch -c $@
#
#  load fait
-include node_modules/fait/index.mk
#
#  ╺══════════╸
#
#  over to you

