#   ╭─╮   •
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#
#  install missing modules
#
node_modules/%/index.mk: package.json ; npm install $*
#
#  load fait
#
-include node_modules/fait/index.mk
#
#  ╺══════════╸
#
#  over to you

