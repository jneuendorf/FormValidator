PROJECT_NAME = FormValidator

# sets DEBUG = true (otherwise set to false by uglifyjs)
DEBUG_FILE = debug.coffee
# files the core and bundle files depend on
COMMON_FILES = algorithms.coffee \
				constants.coffee

# files for the core (only validation)
CORE_FILES = validators.coffee constraint_validators.coffee \
				locales.coffee error_messages.coffee \
				error_message_builders.coffee \
				$(PROJECT_NAME).coffee \
				event_handlers.coffee
# remaing files for the complete bundle (incl. form modifier, sequence)
BUNDLE_FILES = async/Sequence.coffee \
				dependency_change_actions.coffee \
				FormModifier.coffee
TEST_FILES = spec/test_validators.coffee \
				spec/test_general_behavior.coffee \
				spec/test_dependencies.coffee \
				spec/test_constraints.coffee \
				spec/$(PROJECT_NAME).test.coffee

CSS_FILES = theme.default theme.bootstrap


bundle:
	# compile coffee with --bare because we add our own function wrapper for jQuery namespace
	cat $(DEBUG_FILE) $(COMMON_FILES) $(BUNDLE_FILES) $(CORE_FILES) | coffee --compile --stdio --bare > $(PROJECT_NAME).js
	echo '(function($$){' | cat - $(PROJECT_NAME).js > temp && mv temp $(PROJECT_NAME).js
	echo '})(jQuery)' >> $(PROJECT_NAME).js
	sh make/make_sass.sh $(CSS_FILES)

core:
	# compile coffee with --bare because we add our own function wrapper for jQuery namespace
	cat $(DEBUG_FILE) $(COMMON_FILES) $(CORE_FILES) | coffee --compile --stdio --bare > $(PROJECT_NAME).core.js
	echo '(function($$){' | cat - $(PROJECT_NAME).core.js > temp && mv temp $(PROJECT_NAME).core.js
	echo '})(jQuery)' >> $(PROJECT_NAME).core.js
	sh make/make_sass.sh $(CSS_FILES)

bundle_min:
	cat $(COMMON_FILES) $(BUNDLE_FILES) $(CORE_FILES) | coffee --compile --stdio --bare > $(PROJECT_NAME).temp.js
	echo '(function($$){' | cat - $(PROJECT_NAME).temp.js > temp && mv temp $(PROJECT_NAME).temp.js
	echo '})(jQuery)' >> $(PROJECT_NAME).temp.js
	uglifyjs $(PROJECT_NAME).temp.js -o $(PROJECT_NAME).min.js -c drop_console=true -d DEBUG=false -m
	rm -f $(PROJECT_NAME).temp.js
	sh make/make_sass_compressed.sh $(CSS_FILES)

core_min:
	cat $(COMMON_FILES) $(CORE_FILES) | coffee --compile --stdio --bare > $(PROJECT_NAME).temp.js
	echo '(function($$){' | cat - $(PROJECT_NAME).temp.js > temp && mv temp $(PROJECT_NAME).temp.js
	echo '})(jQuery)' >> $(PROJECT_NAME).temp.js
	uglifyjs $(PROJECT_NAME).temp.js -o $(PROJECT_NAME).core.min.js -c drop_console=true -d DEBUG=false -m
	rm -f $(PROJECT_NAME).temp.js
	sh make/make_sass_compressed.sh $(CSS_FILES)

dist: bundle core bundle_min core_min
	cp $(PROJECT_NAME).js dist
	cp $(PROJECT_NAME).min.js dist
	sh make/make_dist_copy.sh $(CSS_FILES)

all: dist test

test: bundle
	cat $(TEST_FILES) | coffee --compile --stdio > ./spec/$(PROJECT_NAME).test.js
	# TODO: run tests!

# clean:
# 	rm -f $(PROJECT_NAME).js
# 	rm -f $(PROJECT_NAME).test.js
# 	rm -f $(PROJECT_NAME).min.js
