PROJECT_NAME = FormValidator

COFFEE_FILES = setup.coffee namespaces.coffee \
				algorithms.coffee \
				constants.coffee \
				validators.coffee constraint_validators.coffee \
				locales.coffee error_messages.coffee \
				error_message_builders.coffee \
				FormModifier.coffee $(PROJECT_NAME).coffee
DEBUG_FILE = debug.coffee
TEST_FILES = test_validators.coffee test_general_behavior.coffee test_dependencies.coffee test_constraints.coffee $(PROJECT_NAME).test.coffee

CSS_FILES = theme.default theme.bootstrap


make:
	# compile coffee
	cat $(DEBUG_FILE) $(COFFEE_FILES) | coffee --compile --stdio > $(PROJECT_NAME).js
	sh ./make_sass.sh $(CSS_FILES)


test: make
	cat $(TEST_FILES) | coffee --compile --stdio > $(PROJECT_NAME).test.js

min:
	cat $(COFFEE_FILES) | coffee --compile --stdio > $(PROJECT_NAME).temp.js
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
