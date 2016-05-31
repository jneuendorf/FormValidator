PROJECT_NAME = FormValidator

# sets DEBUG = true (otherwise set to false by uglifyjs)
DEBUG_FILE = debug.coffee
# files the core AND complete bundle files depend on
COMMON_FILES = algorithms.coffee \
				constants.coffee

# files for the core (only validation)
CORE_FILES = validators.coffee constraint_validators.coffee \
				locales.coffee error_messages.coffee \
				error_message_builders.coffee \
				$(PROJECT_NAME).coffee \
				event_handlers.coffee
# files for the complete bundle (incl. form modifier)
COMPLETE_FILES = dependency_change_actions.coffee \
				FormModifier.coffee
TEST_FILES = spec/test_validators.coffee \
				spec/test_general_behavior.coffee \
				spec/test_dependencies.coffee \
				spec/test_constraints.coffee \
				spec/$(PROJECT_NAME).test.coffee

CSS_FILES = theme.default theme.bootstrap



complete: pre sass
	php $(PROJECT_NAME).coffee -- '_sync.coffee' 'false' > temp && mv temp $(PROJECT_NAME).coffee
	# core files must be after complete files because FormValidator needs the dependency_change_actions on load
	# compile coffee with --bare because we add our own function wrapper for jQuery namespace
	cat $(DEBUG_FILE) $(COMMON_FILES) $(COMPLETE_FILES) $(CORE_FILES) | coffee --compile --stdio --bare > dist/$(PROJECT_NAME).js
	# add function wrapper for jQuery namespace
	sh make/make_jquery_wrapper.sh dist/$(PROJECT_NAME).js
	# restore original coffee file
	mv $(PROJECT_NAME).orig.coffee $(PROJECT_NAME).coffee

complete_async: pre sass
	php $(PROJECT_NAME).coffee -- '_async.coffee' 'false' > temp && mv temp $(PROJECT_NAME).coffee
	cat $(DEBUG_FILE) $(COMMON_FILES) $(COMPLETE_FILES) $(CORE_FILES) | coffee --compile --stdio --bare > dist/$(PROJECT_NAME).async.js
	sh make/make_jquery_wrapper.sh dist/$(PROJECT_NAME).async.js
	mv $(PROJECT_NAME).orig.coffee $(PROJECT_NAME).coffee

core: pre sass
	php $(PROJECT_NAME).coffee -- '_sync.coffee' 'true' > temp && mv temp $(PROJECT_NAME).coffee
	cat $(DEBUG_FILE) $(COMMON_FILES) $(CORE_FILES) | coffee --compile --stdio --bare > dist/$(PROJECT_NAME).core.js
	sh make/make_jquery_wrapper.sh dist/$(PROJECT_NAME).core.js
	mv $(PROJECT_NAME).orig.coffee $(PROJECT_NAME).coffee

min: complete complete_async core sass_min
	# complete
	sed -e 's/DEBUG = true//g' dist/$(PROJECT_NAME).js > temp
	uglifyjs temp -o dist/$(PROJECT_NAME).min.js -c drop_console=true -m
	# async
	sed -e 's/DEBUG = true//g' dist/$(PROJECT_NAME).async.js > temp
	uglifyjs temp -o dist/$(PROJECT_NAME).async.min.js -c drop_console=true -m
	# core
	sed -e 's/DEBUG = true//g' dist/$(PROJECT_NAME).core.js > temp
	uglifyjs temp -o dist/$(PROJECT_NAME).core.min.js -c drop_console=true -m
	rm temp


dist: complete async core min
	# copy css files (incl. minified versions)
	sh make/make_dist_copy.sh $(CSS_FILES)

all: dist test

test: complete
	cat $(TEST_FILES) | coffee --compile --stdio > ./spec/$(PROJECT_NAME).test.js
	# TODO: run tests!

########################################
# HELPERS
pre:
	cp $(PROJECT_NAME).coffee $(PROJECT_NAME).orig.coffee
	sed -e 's/###<?php/<?php/g' -e 's/?>###/?>/g' $(PROJECT_NAME).coffee > temp && mv temp $(PROJECT_NAME).coffee

sass:
	sh make/make_sass.sh $(CSS_FILES)

sass_min:
	sh make/make_sass_compressed.sh $(CSS_FILES)
