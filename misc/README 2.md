# FormValidator

This project is a library for validating forms or miscellaneous HTML elements.


### Usage

Just include `FormValidator.js` (for development) or `FormValidator.min.js` (for production).

### How it works

#### Validated elements

Each FormValidator instance expects a jQuery or HTML element as its form.
Within that element all elements with a `data-fv-validate` attribute will be validated. The value of that attribute determines the `validator` and is referred to as `type` in the rest of the document.
Any of the validated elements with a `data-fv-optional="true"` attribute will only be validated if it has a value that's not empty (except radio buttons and checkboxes: for those the `selected` or `checked` state is checked, relatively).

#### Highlighting invalid elements

The form element can have a `data-fv-error-classes` attribute which then must contain a space separated string. This attribute defines the CSS classes that will be applied when an element is invalid.
Each validated element may also have that attribute to override the global setting.

Each validated element should also specify a `data-fv-error-targets` attribute. This will be used to determine what element(s) will get the CSS error classes. The targets are trying to be found like so:

1. within the form by the `data-fv-name` attribute
2. within the form by selector
3. within the entire document by selector
	- this makes it possible to target elements outside the form! :)

#### Pre- and postprocessing elements

A validated element's value can also be preprocessed (before the validation happens) by using the `data-fv-preprocess='true'`. Additionally, an according preprocessor has to be registered using the `register_preprocessor()` method. See the API documentation for details.
Technically, the `data-fv-preprocess` attribute doesn't have to be set in order to trigger preprocessing, because once the preprocessor was registered preprocessing will become the default behavior (for the according type). In order to prevent that default behavior the `data-fv-preprocess` must be set to `false`.

Similarly, an element's value can be postprocessed BUT a value only gets postprocessed if the validation was successful. That means an invalid value will remain in the form field as is until it becomes valid. That also means the output of the postprocessor should be a valid value for the preprocessor or the validator, relatively. The according attribute is `data-fv-postprocess='true|false'` and the registration happens with `register_postprocessor()`.

### FYI

#### Naming elements

As already mentioned the `data-fv-name` attribute can be used to set an element as error target for any validated form element. Additionally, this attribute will be used (if it's set) to enhance the error reporting because the will make the `name` variable accessible in error messages.

#### Error messages

Error messages are locale dependent. Also, certain variables can be used. Those variables are:

- element (`jQuery`)
	- the form element as jQuery object
- index (`number`)
	- the index over all validated form elements
- index_of_type (`number`)
	- the index over all validated form elements of the current type
- name (`string`)
	- the value of the `data-fv-name` attribute
- previous_name (`string`)
	- the name of the previously validated element
- value (`string`)
	- the value (or text) of the current element (possibly preprocessed)

In most cases an error message is a plain `string`. Any of the above variables can be accessed *magically* by writing `"{{<VAR_NAME>}}"`, i.e. this would be a valid message: `"The {{index}}th element has the name '{{name}}'."` and could print `"The 4th element has the name 'user name'."`

For more flexibility an error message can also be a function. In such a function no magic happens. Simply an object gets passed containing all the variables.


In order to change the default error messages the following must be done: For each locale a message has to be defined for the according form field type. All error message belong the `FormValidator` class because the assumption is that all forms on the same web page are supposed to be validated in the same manner. Therefore, the `FormValidator.error_messages` object has to be modified before validation. The strucure is:

```javascript
FormValidator.error_messages = {
	locale1: {
		type11: "error_message11",
		type12: "error_message12"
		// ...
	},
	locale2: {
		type21: "error_message21",
		type22: "error_message22"
		// ...
	}
}
```

___
___

### API

Example:

```javascript
var form_validator = FormValidator.new($("form"), {
    // formatting german style numbers
    preprocessors: {
        number: function(val, elem) {
            return val.replace(/\./g, "").replace(/\,/g, ".");
        }
    },
    postprocessors: {
        number: function(val, elem) {
            return (val + "").replace(/\./g, ",");
        }
    },
    locale: "de"
});
var res = form_validator.validate();
```

#### Constructor options

The constructor takes the form (as HTML or jQuery element) and the options object. This object can contain any of the following properties:

- error_classes (`String`)
	- This options only takes effect if the form does not have a `data-fv-error-classes` attribute.
	- Globally (for the form) defines the CSS classes that are applied when an element is invalid.
	- This can still be overriden by single elements using the `data-fv-error-classes` attribute.
- error_target_getter
	- function that determines the error targets for an element.
	- Signature: `error_target_getter(type, element, index)`
- field_getter
	- function that determines all relevant fields for the `FormValidator`
- required_field_getter
	- function that returns a subset of the fields (returned by `field_getter`)
- optional_field_getter
	- function that returns a subset (should be disjoint of what is returned by `required_field_getter`)
- validators
	- an object defining validators
	- all validators will be merged with default ones
- validation_options
	- an object containing options for the validation (could also be passed into the `validate()` function itself)
- locale
	- can be either of `de`, or `en`
- preprocessors
	- an object defining a function for any type in the validator
	- a preprocessor's signature is: `function(value, element)`
- postprocessors
	- same as with preprocessors

**FormValidator objects can also and should be instantiated using `FormValidator.new(form, options)`**

#### Properties

The 'public' properties correspond to the constructor options but should not be of interest...using the constructor options is recommended.


#### Instance methods

- `set_error_target_getter(error_target_getter)`
	- define what elements will be error targets for a validated element
	- the `error_target_getter` callback's signature is `function(type, element, index)`
		- type - `string`
		- element - `jQuery`
		- index - `number` (1-based)
- `set_field_getter(field_getter)`
	- defines what fields are relevant in the form (the set of returned fields is usually split into `required` and `optional` fields)
	- the callback's signature is `function(form)`
		- form - `jQuery`
- `set_required_field_getter(required_field_getter)`
	- define what subset of the form fields are required
	- the callback's signature is: `function(elements)`
		- elements - `jQuery`
- `set_optional_field_getter(optional_field_getter)`
	- works just like `set_required_field_getter` but is meant for optional fields
- `register_validator(type, validator)`
	- register a validator for a certain `type`
	- type - `string`
	- validator - `function` (or anything with a `.call()` method that returns a `boolean`)
		- signature is `function(value, element)`
			- value - `string`
			- element - `jQuery`
- `deregister_validator(type)`
	- remove a registered validator
	- type - `string`
- `register_preprocessor(type, processor)`
	- register a preprocessor for a certain `type`
	- type - `string`
	- processor - `function`
		- signature is `function(value, element)`
			- value - `string`
			- element - `jQuery`
- `deregister_preprocessor(type)`
	- remove a registered preprocessor
	- type - `string`
- `register_postprocessor(type, processor)`
	- same as `register_preprocessor`
- `deregister_postprocessor(type)`
	- same as `deregister_preprocessor`
- `validate(options = this.validation_options or {apply_error_styles: true})`
	- **this is the most important method!**
	- validates a form using the instance settings and the passed options (if given)
	- the default options should suffice but if **ONLY** an analysis is needed set `apply_error_styles` to `false`
	- if error styles are applied then: already applied error styles will be removed once an element's value turns valid


#### Built-in validators

Here is a list of the built-in validators and what values/elements are valid.
They should do pretty much what you'd expect them to do. ;)

- email
	- <ANYTHING+>@<ANYTHING_WITH_A_DOT+>
- integer
	- N
- positive_integer
	- N+ (incl. 0)
- negative_integer
	- N-
- number
	- (-Infinity, +Infinity)
- positive_number
	- [0, +Infinity)
- negative_number
	- (-Infinity, 0)
- phone
	- any combination of `"0123456789+-/() "` that's longer than 2 characters
- text
	- anything longer than 0 characters
- radio
	- a radio button of the group (= all with the same name) must be checked and have a non-empty value
- checkbox
	- a checked checkbox
- select
	- the selected item's value is non-empty
