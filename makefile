PROJECT_NAME = FormValidator

COFFEE_FILES = setup.coffee namespaces.coffee validators.coffee constraint_validators.coffee error_messages.coffee $(PROJECT_NAME).coffee
DEBUG_FILE = debug.coffee
TEST_FILES = $(PROJECT_NAME).test.coffee


make:
	# compile coffee
	cat $(DEBUG_FILE) $(COFFEE_FILES) | coffee --compile --stdio > $(PROJECT_NAME).js

test: make
	cat $(TEST_FILES) | coffee --compile --stdio > $(PROJECT_NAME).test.js

min:
	cat $(COFFEE_FILES) | coffee --compile --stdio > $(PROJECT_NAME).temp.js
	uglifyjs $(PROJECT_NAME).temp.js -o $(PROJECT_NAME).min.js -c drop_console=true -d DEBUG=false -m
	rm -f $(PROJECT_NAME).temp.js

all: make test min

clean:
	rm -f $(PROJECT_NAME).js
	rm -f $(PROJECT_NAME).test.js
	rm -f $(PROJECT_NAME).min.js
