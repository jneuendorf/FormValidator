class window.FormValidator
    # TODO: add effects for dependencies
    # TODO: create bootstrap theme that uses bootstrap validation states (+ maybe icons)


    ########################################################################################################################
    ########################################################################################################################
    # CONSTANTS

    @ERROR_MODES = ERROR_MODES
    @ERROR_OUTPUT_MODES = ERROR_OUTPUT_MODES
    @VALIDATION_PHASES = VALIDATION_PHASES
    @BUILD_MODES = BUILD_MODES
    @ERROR_MESSAGE_CONFIG = ERROR_MESSAGE_CONFIG

    # NOTE: REQUIRED_CACHE is already available in the closure


    ########################################################################################################################
    ########################################################################################################################
    # CLASS CONFIGURATION

    # defined in constraint_validators.coffee
    @constraint_validators = constraint_validators
    @constraint_validator_options = constraint_validator_options
    @constraint_validator_groups = constraint_validator_groups

    # defined in validators.coffee
    @validators = validators

    # defined in locales.coffee and error_messages.coffee
    @locales = locales

    # defined in error_message_builders.coffee
    @error_message_builders = error_message_builders

    @default_preprocessors =
        number: (str, elem, locale) ->
            if locale is "de"
                return str.replace(/\./g, "").replace(/\,/g, ".")
            if locale is "en"
                return str.replace(/\,/g, "")
            return str
        integer: (str, elem, locale) ->
            if locale is "de"
                return str.replace(/\./g, "").replace(/\,/g, ".")
            if locale is "en"
                return str.replace(/\,/g, "")
            return str


    ########################################################################################################################
    ########################################################################################################################
    # CLASS METHODS

    # NOTE: for @new see CONSTRUCTORS section

    # define an error_message_type for each error mode (of ERROR_MODES) (for each validator that supports different error modes)
    @get_error_message_type: (special_type, error_mode) ->
        if error_mode is @ERROR_MODES.SIMPLE
            base_type = special_type.split("_")[0]
            switch base_type
                when "integer"
                    return "integer"
                when "number"
                    return "number"
        return special_type

    @_build_error_message: (phase, errors, build_mode, locale) ->
        return @error_message_builders[phase](errors, phase, build_mode, locale)

    # from the list of errors generate an error message for a certain element (this combines the error messages of the errors belonging to the element)
    # message = concatenation of each validation-phase-message string if they are errors for that part (generated independently, defined in ERROR_MESSAGE_CONFIG.ORDER)
    # each part of the message can be generated differently (defined in ERROR_MESSAGE_CONFIG.BUILD_MODE)
    @get_error_message_for_element: (element, errors, build_mode, locale, delimiter = " ") ->
        error_message_parts = []
        grouped_errors = {}
        # group by errors by .phase
        for phase of VALIDATION_PHASES
            grouped_errors[phase] = (error for error in errors when error.phase is phase)

        for phase in @ERROR_MESSAGE_CONFIG.PHASE_ORDER when grouped_errors[phase].length > 0
            error_message_parts.push @_build_error_message(phase, grouped_errors[phase], build_mode, locale)

        return error_message_parts.join(delimiter)


    ########################################################################################################################
    ########################################################################################################################
    # INIT

    # enable autobound buttons
    $(document).on "click", "[data-fv-start]", () ->
        $elem = $(@)
        # find container element
        if not (container = $elem.data("_form_validator_container"))?
            container = $elem.closest($elem.attr("data-fv-start"))
            if container.length is 0
                container = $($elem.attr("data-fv-start"))
            $elem.data("_form_validator_container", container)

        if DEBUG and container.length is 0
            throw new Error("FormValidator (in validation on click triggered by 'data-fv-start'): No container found. Check the value of the 'data-fv-start' attribute (so it matches a closest element or any element in the document)!")

        # get form validator
        if not (form_validator = container.data("_form_validator"))?
            options = $elem.attr("data-fv-start-options")
            if options?
                try
                    options = JSON.parse(options)
                catch error
                    options = window[options]()

            form_validator = FormValidator.new(container, options)
            container.data("_form_validator", form_validator)
        form_validator.validate()
        return false

    # enable real-time validation
    $(document).on "change click keyup", "[data-fv-real-time] [data-fv-validate]", (evt) ->
        $elem = $(@)

        # prevent click in textfields (which also triggers the change event on previously focussed inputs) to trigger validation
        # TODO: negate selector to be like not(input[type=hidden], ...)
        if (evt.type is "click" or evt.type is "change") and $elem.filter("textarea, input[type='text'], input[type='number'], input[type='date'], input[type='month'], input[type='week'], input[type='time'], input[type='datetime'], input[type='datetime-local'], input[type='email'], input[type='search'], input[type='url']").length is $elem.length
            return true

        container = $elem.closest("[data-fv-real-time]")
        if container.length is 1
            if not (form_validator = container.data("_form_validator"))?
                form_validator = FormValidator.new(container)
                container.data("_form_validator", form_validator)
            errors = form_validator.validate()
            # if there are errors, keep the focus on the current element because it would otherwise move elsewhere
            #  without errors we just keep the focus because the form validator would not change it
            if errors.length > 0
                $elem.focus()
        return false

    ########################################################################################################################
    ########################################################################################################################
    # CONSTRUCTORS
    @new: (form, options) ->
        if DEBUG and form not instanceof jQuery
            throw new Error("FormValidator::constructor: Invalid form given (must be a jQuery object)!")
        return new @(form, options)

    ###*
    * @param form {Form}
    * @param options {Object}
    *###
    constructor: (form, options = {}) ->
        CLASS = @constructor

        @form = form
        @fields = null

        # default css error classes. can be overridden by data-fv-error-classes on any error target
        @error_classes          = options.error_classes or @form.attr("data-fv-error-classes") or ""
        @dependency_error_classes = options.dependency_error_classes or @form.attr("data-fv-dependency-error-classes") or ""
        @validators             = $.extend {}, CLASS.validators, options.validators
        @validation_options     = options.validation_options or null
        @constraint_validators  = $.extend {}, CLASS.constraint_validators, options.constraint_validators
        # @error_messages         = options.error_messages
        @build_mode             = options.build_mode or BUILD_MODES.DEFAULT
        # option for always using the simplest error message (i.e. the value '1.2' for 'integer' would print the error message 'integer' instead of 'integer_float')
        @error_mode             = if CLASS.ERROR_MODES[options.error_mode]? then options.error_mode else CLASS.ERROR_MODES.DEFAULT
        # TODO: choose how to output the generated errors (i.e. print below element (maybe even getbootstrap.com/javascript/#popovers))
        @error_output_mode      = if CLASS.ERROR_OUTPUT_MODES[options.error_output_mode]? then options.error_output_mode else CLASS.ERROR_OUTPUT_MODES.DEFAULT
        @locale                 = options.locale or "en"

        @error_target_getter    = options.error_target_getter or null
        @field_getter           = options.field_getter or null
        @required_field_getter  = options.required_field_getter or null
        @create_dependency_error_message = options.create_dependency_error_message or null
        @preprocessors          = $.extend CLASS.default_preprocessors, options.preprocessors or {}
        @postprocessors         = options.postprocessors or {}
        @group                  = options.group or null


    ########################################################################################################################
    ########################################################################################################################
    # PRIVATE

    ########################################################################################################################
    # CACHING

    # used to get the element's attribute's value for a given part of the cache
    _get_attribute_value_for_key: (element, key) ->
        prefix = "data-fv-"
        special =
            type: "validate"
            required: "optional"
        boolean = [
            "preprocess"
            "required"
        ]

        if not special[key]?
            attribute = prefix + key.replace(/\_/g, "-")
        else
            attribute = prefix + special[key]

        value = element.attr(attribute)
        has_attr = (value?)

        if has_attr
            value = value.trim()
        # set defaults for undefined attributes
        else
            if (k = key.toUpperCase()) in Object.keys(DEFAULT_ATTR_VALUES)
                value = DEFAULT_ATTR_VALUES[k]

        # "cast" to Boolean
        if key in boolean
            value = if (value is "true" or value is true) then true else false

        # special because 'required' corresponds to 'optional' => must be negated (but only if it was defined by the data-fv-optional attribute - otherwise the default value is already correct)
        if key is "required" and has_attr
            value = not value

        return value

    # data is the last validation result + the last validated value
    _set_element_data: (element, data) ->
        $.data(element[0], "_fv", data)
        return @

    _get_element_data: (element) ->
        return $.data(element[0], "_fv")

    _cache_attribute: (element, data, key, value) ->
        if not value?
            value = element.attr("data-fv-#{key.replace(/\_/g, "-")}")
        else if value instanceof Function
            value = value.call(@)

        data[key] = value
        return data

    # END - CACHING

    _get_fields: (form) ->
        return @field_getter?(form) or form.find("[data-fv-validate]").filter (idx, elem) ->
            return $(elem).closest("[data-fv-ignore-children]").length is 0

    _get_required: (fields) ->
        return @required_field_getter?(fields) or fields.not("[data-fv-optional='true']")

    _get_value_info: (element, data) ->
        {type, preprocess} = data
        usedValFunc = true
        value = element.val()
        if not value?
            usedValFunc = false
            value = element.text()

        original_value = value
        value_has_changed = original_value isnt data.value

        # cache latest element's value
        data.value = original_value

        if @preprocessors[type]? and preprocess isnt false
            value = @preprocessors[type].call(@preprocessors, value, element, @locale)

        return {
            usedValFunc: usedValFunc
            value: value
            original_value: original_value
            value_has_changed: value_has_changed
        }

    _find_targets: (targets, element, delimiter = /\s+/g) ->
        if typeof targets is "string"
            return (@_find_target(target, element) for target in targets.split(delimiter))
        return targets or []

    _find_target: (target, element) ->
        if target is "self"
            return element
        result = @form.find("[data-fv-name='#{target}']")
        # nothing found => try closest matching jquery selector instead of data-fv-name property
        if result.length is 0
            result = element.closest(target)
        # nothing found => try jquery selector in from
        if result.length is 0
            result = @form.find(target)
        # nothing found => try to find selector in entire document
        if result.length is 0
            result = $(target)
        return result

    # how to find the correct data-fv-error-targets attribute for an element
    _get_error_targets: (element, type, index) ->
        return @error_target_getter?(element, type, index) or
            element.attr("data-fv-error-targets") or
            element.closest("[data-fv-error-targets]").attr("data-fv-error-targets") or
            DEFAULT_ATTR_VALUES.ERROR_TARGETS

    # TODO: use only 1 function that gets classes as param
    # apply error classes and styles to element if invalid
    _apply_error_classes: (element, error_targets, is_valid) ->
        if error_targets?
            targets = @_find_targets(error_targets, element)
            for target, i in targets
                if target not instanceof jQuery
                    target = targets.eq(i)
                # apply element's or the form's error classes
                if (error_classes = target.attr("data-fv-error-classes"))?
                    if is_valid is false
                        target.addClass error_classes
                    else
                        target.removeClass error_classes
                else
                    if is_valid is false
                        target.addClass @error_classes
                    else
                        target.removeClass @error_classes
            return targets
        return []

    _apply_dependency_error_classes: (element, error_targets, is_valid) ->
        if error_targets?
            targets = @_find_targets(error_targets, element)
            for target in targets
                if (error_classes = target.attr("data-fv-dependency-error-classes"))?
                    if is_valid is false
                        target.addClass error_classes
                    else
                        target.removeClass error_classes
                else
                    if is_valid is false
                        target.addClass @dependency_error_classes
                    else
                        target.removeClass @dependency_error_classes
            return targets
        return []

    # create list of sets where each set is 1 unit for counting progress
    _group: (fields) ->
        dict = {}
        for i in [0...fields.length]
            elem = fields.eq(i)
            data = @_get_element_data(elem)

            if not data.group?
                data.group = elem.attr("data-fv-group") or data.name
                @_set_element_data(elem, data)

            group_name = data.group
            if not dict[group_name]?
                dict[group_name] = [elem]
            else
                dict[group_name].push elem

        return (elems for name, elems of dict)

    # group by .element (as list of array tuples), create "big" error message
    _group_errors: (errors, options) ->
        CLASS = @constructor
        result = []
        fields = @fields.all
        # traverse fields in the order they appear in the DOM
        for i in [0...fields.length]
            elem = fields.eq(i)
            elem_errors = (error for error in errors when error.element.is(elem))

            if elem_errors.length > 0
                if options.messages is true
                    message = CLASS.get_error_message_for_element(elem, elem_errors, @build_mode, @locale)
                else
                    message = ""

                result.push {
                    element: elem
                    errors: elem_errors
                    message: message
                }
        return result

    ########################################################################################################################
    # VALIDATION HELPERS

    _validate_element: (element, data, value_info) ->
        {type} = data
        {value} = value_info
        validator = @validators[type]
        if not validator?
            throw new Error("FormValidator::_validate_element: No validator found for type '#{type}'. Make sure the type is correct or define a validator!")
        validation = validator.call(@validators, value, element)

        # if a simple return value was used (false/string containing the error message type) => create object
        if validation is false
            validation = {
                error_message_type: type
            }
        else if typeof validation is "string"
            validation = {
                error_message_type: validation
            }

        return validation

    # validation - phase 1
    _validate_dependencies: (element, data) ->
        errors = []
        elements = []
        if data.depends_on?
            elements = data.depends_on
            for dependency_elem, i in elements
                dependency_data = @_get_element_data(dependency_elem)
                dependency_validation = @_validate_element(
                    dependency_elem
                    dependency_data
                    @_get_value_info(dependency_elem, dependency_data)
                )
                if dependency_validation isnt true
                    errors.push $.extend(dependency_validation, {
                        dependency_element: dependency_elem
                        element: element
                        index: i
                        type: dependency_data.type
                        name: dependency_data.name
                    })
        else if DEBUG
            throw new Error("FormValidator::_validate_dependencies: For some reason the dependencies were not cached before validation! This should never happen so this is probably a bug.")

        # cache dependency mode
        if not data.dependency_mode?
            data.dependency_mode = element.attr("data-fv-dependency-mode") or DEFAULT_ATTR_VALUES.DEPENDENCY_MODE
            @_set_element_data(element, data)

        # at least 1 dependency is valid <=> valid
        if data.dependency_mode is "any"
            valid = errors.length < elements.length
        # no dependency is invalid <=> valid
        else
            valid = errors.length is 0

        return {
            dependency_errors: errors
            dependency_elements: elements
            valid_dependencies: valid
            dependency_mode: data.dependency_mode
        }

    _validate_constraints: (element, data, value) ->
        results = {}
        if data.constraints?
            constraints = data.constraints
        else
            CLASS = @constructor
            constraints = []
            for constraint_name, constraint_validator of @constraint_validators
                if (constraint_value = element.attr("data-fv-#{constraint_name.replace(/\_/g, "-")}"))?
                    # get options
                    if (constraint_validator_options = CLASS.constraint_validator_options[constraint_name])?
                        options = {}
                        for option in constraint_validator_options
                            options[option] = element.attr("data-fv-#{option.replace(/\_/g, "-")}")
                    else
                        options = null
                    constraints.push {
                        name: constraint_name
                        options: options
                        # type: constraint_name
                        validator: constraint_validator
                        value: constraint_value
                    }
            # cache constraints
            data.constraints = constraints
            @_set_element_data(element, data)

        for constraint in constraints
            if constraint.validator.call(@constraint_validators, value, constraint.value, constraint.options) is true
                results[constraint.name] = true
            else
                # create object with details about what's wrong
                result = {}
                result.options = constraint.options
                result[constraint.name] = constraint.value

                results[constraint.name] = result

        return results

    # END - VALIDATION HELPERS


    ########################################################################################################################
    ########################################################################################################################
    # PUBLIC

    # GETTERS + SETTERS

    register_validator: (type, validator, error_message_types) ->
        # check validator in dev mode
        if DEBUG
            if validator.call instanceof Function and typeof(validator.call(@validators, "", $())) is "boolean" and validator.error_message_types instanceof Array
                @validators[type] = validator
            else
                console.warn "FormValidator::register_validator: Invalid validator given (has no call method or not returning a boolean)!"
        else
            @validators[type] = validator
        return @

    deregister_validator: (type) ->
        delete @validators[type]
        return @

    register_preprocessor: (type, processor) ->
        @preprocessors[type] = processor
        return @

    deregister_preprocessor: (type) ->
        delete @preprocessors
        return @

    register_postprocessor: (type, processor) ->
        @postprocessors[type] = processor
        return @

    deregister_postprocessor: (type) ->
        delete @postprocessors[type]
        return @

    # ACTUAL FUNCTIONALITY

    # can be used to eagerly load all data
    cache: () ->
        fields = @_get_fields(@form)
        @fields =
            all: fields
            required: @_get_required(fields)

        for i in [0...fields.length]
            elem = fields.eq(i)
            data = {}

            for key in REQUIRED_CACHE
                data[key] = @_get_attribute_value_for_key(elem, key)
            # already parse the list of dependencies as list of jquery elements ("" => [], null => []), delimiter = ';'
            data.depends_on = @_find_targets(data.depends_on, elem, /^\s*\;\s*$/g)

            # set keys that are cached later (lazily) to null (which means unknow)
            for key in OPTIONAL_CACHE
                data[key] = null
            data.errors = {}
            data.errors[VALIDATION_PHASES.DEPENDENCIES] = []
            data.errors[VALIDATION_PHASES.VALUE] = []
            data.errors[VALIDATION_PHASES.CONSTRAINTS] = []

            @_set_element_data(elem, data)
        return @

    ###*
    * @method validate
    * @param options {Object}
    * Default is this.validation_option. Otherwise:
    * Valid options are:
    *  - all:                   {Boolean} (default is false)
    *  - apply_error_classes:   {Boolean} (default is true)
    *  - focus_invalid:         {Boolean} (default is true)
    *  - messages:              {Boolean} (default is true)
    *  - stop_on_error:         {Boolean} (default is true)
    *    -> stop the current validation after an error has been found (otherwise all errors will be collected)
    *  - recache:               {Boolean} (default is false)
    *###
    validate: (options = {}) ->
        default_options =
            all: false
            apply_error_classes: true
            focus_invalid: true
            messages: true
            stop_on_error: true
            recache: false
        options = $.extend default_options, @validation_options, options

        if not @fields? or options.recache is true
            @cache()

        CLASS = @constructor
        errors = []
        prev_name = null
        usedValFunc = false
        required = @fields.required
        fields = @fields.all
        first_invalid_element = null

        for i in [0...fields.length]
            elem = fields.eq(i)
            data = @_get_element_data(elem)
            is_required = data.required
            {type, name} = data
            value_info = @_get_value_info(elem, data)
            {value, original_value, value_has_changed, usedValFunc} = value_info

            # skip empty optional elements
            if options.all is false and not is_required and (value.length is 0 or type is "radio" or type is "checkbox")
                # NOTE: if an optional value was invalid and was emptied the error target's error classes should be removed
                if not data.error_targets?
                    data = @_cache_attribute elem, data, "error_targets", () ->
                        return @_get_error_targets(elem, type, i)
                    @_set_element_data(elem, data)
                @_apply_error_classes(elem, data.error_targets, true)
                @_apply_dependency_error_classes(elem, data.depends_on, true)
                continue

            prev_phases_valid = true


            #########################################################
            # PHASE 1: validate dependencies (no matter if the value has changed because dependencies could have changed)
            phase = VALIDATION_PHASES.DEPENDENCIES
            {dependency_errors, dependency_elements, dependency_mode, valid_dependencies} = @_validate_dependencies(elem, data)
            if not valid_dependencies
                prev_phases_valid = false
                data.valid_dependencies = false
                data.errors[phase] = dependency_errors.concat {
                    element:    elem
                    required:   is_required
                    type:       "dependency"
                    phase:      phase
                    mode:       dependency_mode
                }
                first_invalid_element ?= elem
            else
                data.valid_dependencies = true
                data.errors[phase] = []
            errors = errors.concat data.errors[phase]


            #########################################################
            # PHASE 2: validate the value
            # validate the current value only if it has changed
            phase = VALIDATION_PHASES.VALUE
            if value_has_changed
                if prev_phases_valid or not options.stop_on_error
                    # TODO is this var still needed??
                    current_error = null
                    validation_res = @_validate_element(elem, data, value_info)
                    # element is invalid
                    if validation_res isnt true
                        prev_phases_valid = false
                        data.valid_value = false
                        current_error =
                            element: elem
                            error_message_type: validation_res.error_message_type
                            phase: phase
                            required: is_required
                            type: type
                            value: value
                        data.errors[phase] = [current_error]
                        first_invalid_element ?= elem
                    else
                        data.valid_value = true
                        data.errors[phase] = []
            # value has not changed (data is unchanged)
            else
                if prev_phases_valid or not options.stop_on_error
                    if data.valid_value isnt true
                        prev_phases_valid = false
                        first_invalid_element ?= elem
            errors = errors.concat data.errors[phase]


            #########################################################
            # PHASE 3 - validate constraints
            phase = VALIDATION_PHASES.CONSTRAINTS
            if value_has_changed
                if prev_phases_valid or not options.stop_on_error
                    data.valid_constraints = true
                    temp = []
                    for constraint_name, result of @_validate_constraints(elem, data, value) when result isnt true
                        data.valid_constraints = false
                        prev_phases_valid = false
                        temp.push $.extend result, {
                            element: elem
                            required: is_required
                            type: constraint_name
                            phase: phase
                            value: value
                        }
                    data.errors[phase] = temp
                    if data.valid_constraints is false
                        first_invalid_element ?= elem
            # value has not changed (data is unchanged)
            else
                if prev_phases_valid or not options.stop_on_error
                    if data.valid_constraints isnt true
                        prev_phases_valid = false
                        first_invalid_element ?= elem
            errors = errors.concat data.errors[phase]


            is_valid = data.valid_dependencies and data.valid_value and data.valid_constraints

            # no validation phase was invalid => element is valid
            if is_valid
                # cache uncached data
                if data.valid isnt true or not data.postprocess? or not data.output_preprocessed?
                    data.valid = true
                    @_cache_attribute(elem, data, "postprocess")
                    @_cache_attribute(elem, data, "output_preprocessed")
                    @_set_element_data(elem, data)

                # replace old value with post processed value
                if data.postprocess is true
                    value = @postprocessors[type]?.call(@postprocessors, value, elem, @locale)
                    if usedValFunc
                        elem.val value
                    else
                        elem.text value
                    current_error?.value = value
                # replace old value with pre processed value
                else if data.output_preprocessed is true
                    value = @preprocessors[type]?.call(@preprocessors, value, elem, @locale)
                    if usedValFunc
                        elem.val value
                    else
                        elem.text value
                    current_error?.value = value
            else
                if data.valid isnt false
                    data.valid = false
                    @_set_element_data(elem, data)

            #########################################################
            # STYLES
            if options.apply_error_classes is true
                if not data.error_targets?
                    @_cache_attribute elem, data, "error_targets", () ->
                        return @_get_error_targets(elem, type, i)
                    @_set_element_data(elem, data)
                @_apply_error_classes(
                    elem
                    data.error_targets
                    is_valid
                )

                if current_error?
                    current_error.error_targets = data.error_targets

                @_apply_dependency_error_classes(elem, dependency_elements, is_valid)

            prev_name = name

        if options.focus_invalid is true
            first_invalid_element?.focus()

        return @_group_errors(errors, options)

    get_progress: (options = {as_percentage: false, recache: false}) ->
        if not @fields? or options.recache is true
            @cache()

        fields = @fields.all
        required = @fields.required
        groups = @group?(fields) or @_group(fields)

        total = groups.length
        count = 0

        errors = @validate({
            apply_error_classes: false
            all: true
        })

        # count only those groups that do not have any errors
        for group, i in groups
            all_optional = true
            for elem in group
                elem = $(elem)
                if required.index(elem) >= 0
                    all_optional = false
                    break

            found_error = false
            # NOTE: elem is either a jQuery object or a DOM element (but $.fn.is() can handle both!)
            for elem in group
                elem = $(elem)

                for error in errors when error.element.is(elem)
                    found_error = true
                    break
                if found_error
                    break
            if not found_error
                count++

        if not options.as_percentage
            return {
                count: count
                total: total
            }
        return count / total
