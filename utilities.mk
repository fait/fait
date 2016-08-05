# add a folder to the shell PATH
define register-bin
export PATH := $(1):$(PATH)
endef

# add a module's npm bin to the shell PATH
define register-npm-bin
$(eval $(call register-bin, $(~module-dir)node_modules/.bin))
endef

# automatically create a target's folder
make-target-dir = @mkdir -p $(@D)
# backwards compat
mkdir = $(make-target-dir)
