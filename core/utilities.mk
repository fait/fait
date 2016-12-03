# add a folder to the shell PATH
define register-bin
export PATH := $(1):$(PATH)
endef

# add a module's npm bin to the shell PATH
define register-npm-bin
$(eval $(call register-bin, $(~module-dir)node_modules/.bin))
endef

# filter by match
define filter-match
$(foreach v,$(2),$(if $(findstring $(1),$(v)),$(v),))
endef

# filter out by match
define filter-out-match
$(foreach v,$(2),$(if $(findstring $(1),$(v)),,$(v)))
endef

# automatically create a target's folder
make-target-dir = @mkdir -p $(@D)
# backwards compat
mkdir = $(make-target-dir)

# get variables that weren't defined at the start of the make session
user-defined-variables = $(filter-out $(~built-in-variables), $(.VARIABLES))

# export given variables
define export-variables
$(eval export ~dummy $(1))
endef


# provide installed version of current module
module-version = $(shell awk -v FS=\" '/"version": ".+"/ { print $$4 }' $(~module-dir)package.json)

