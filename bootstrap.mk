-include node_modules/fait/index.mk
node_modules/%/index.mk: package.json ; npm install $*

########## your rules ↓ ##########
