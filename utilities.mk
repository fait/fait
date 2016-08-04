# add a module's npm bin to the shell PATH
define register-npm-bin
export PATH := $(~module-dir)node_modules/.bin:$(PATH)
endef

# automatically create a target's folder
make-target-dir = @mkdir -p $(@D)
# backwards compat
mkdir = $(make-target-dir)
