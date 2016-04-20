PROJECT_NAME = FormValidator

COFFEE_FILES = namespaces.coffee \
				algorithms.coffee \
				constants.coffee \
				validators.coffee constraint_validators.coffee \
				locales.coffee error_messages.coffee \
				error_message_builders.coffee \
				dependency_change_actions.coffee \
				FormModifier.coffee $(PROJECT_NAME).coffee \
				event_handlers.coffee
DEBUG_FILE = debug.coffee
TEST_FILES = spec/test_validators.coffee \
				spec/test_general_behavior.coffee \
				spec/test_dependencies.coffee \
				spec/test_constraints.coffee \
				spec/$(PROJECT_NAME).test.coffee

CSS_FILES = theme.default theme.bootstrap


make:
	# compile coffee
	# compile coffee with --bare because we add our own function wrapper for jQuery namespace
	cat $(DEBUG_FILE) $(COFFEE_FILES) | coffee --compile --stdio --bare > $(PROJECT_NAME).js
	echo '(function($$){' | cat - $(PROJECT_NAME).js > temp && mv temp $(PROJECT_NAME).js
	echo '})(jQuery)' >> $(PROJECT_NAME).js
	sh ./make_sass.sh $(CSS_FILES)


test: make
	cat $(TEST_FILES) | coffee --compile --stdio > ./spec/$(PROJECT_NAME).test.js

min:
	cat $(COFFEE_FILES) | coffee --compile --stdio --bare > $(PROJECT_NAME).temp.js
	echo '(function($$){' | cat - $(PROJECT_NAME).temp.js > temp && mv temp $(PROJECT_NAME).temp.js
	echo '})(jQuery)' >> $(PROJECT_NAME).temp.js
	uglifyjs $(PROJECT_NAME).temp.js -o $(PROJECT_NAME).min.js -c drop_console=true -d DEBUG=false -m
	rm -f $(PROJECT_NAME).temp.js
	sh ./make_sass_compressed.sh $(CSS_FILES)

dist: make min
	cp $(PROJECT_NAME).js dist
	cp $(PROJECT_NAME).min.js dist
	sh ./make_dist_copy.sh $(CSS_FILES)

all: make test min dist

clean:
	rm -f $(PROJECT_NAME).js
	rm -f $(PROJECT_NAME).test.js
	rm -f $(PROJECT_NAME).min.js
