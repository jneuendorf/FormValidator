class window.FormValidator

    ########################################################################################################################
    ########################################################################################################################
    # CONSTANTS

    for name, constant of EXPOSED_CONSTANTS
        @[name] = constant

    ########################################################################################################################
    ########################################################################################################################
    # CLASS CONFIGURATION

    # defined in constraint_validators.coffee
    @constraint_validators = constraint_validators
    # defined in validators.coffee
    @validators = validators
    # defined in dependency_change_actions.coffee
    @dependency_change_actions = dependency_change_actions
    # defined in locales.coffee and error_messages.coffee
    @locales = locales
    @default_preprocessors =
        number: (str, elem, locale) ->
            return switch locale
                when "de"
                    str.replace(/\,/g, ".")
                else
                    str
        integer: (str, elem, locale) ->
            return switch locale
                when "de"
                    str.replace(/\,/g, ".")
                else
                    str


    ########################################################################################################################
    ########################################################################################################################
    # CLASS METHODS

    # can be used to modify unexposed configuration variables
    @configure: (callback) ->
        callback {
            constraint_validator_groups: constraint_validator_groups
            constraint_validator_options_in_locale_key: constraint_validator_options_in_locale_key
            constraint_validator_options: constraint_validator_options
            locale_message_builders: locale_message_builders
            message_builders: message_builders
            message_data_creators: message_data_creators
        }
        return @

    # for FormValidator.new see CONSTRUCTORS section

    # define an error_message_type for each error mode (of ERROR_MODES) (for each validator that supports different error modes)
    @get_error_message_type: (special_type, error_mode) ->
        # define more simple error message types for the detailed ones
        if error_mode is @ERROR_MODES.SIMPLE
            base_type = special_type.split("_")[0]
            # here would be types that don't follow the convention that the base type is the most general type, i.e.:
            # if base_type is "my_unconventional_type"
            #     return "my_unconventional_type_general"
            return base_type
        return special_type

    @_build_error_message: (phase, errors, build_mode, locale) ->
        data = message_data_creators[phase].create_data(errors, phase, build_mode, locale)
        return message_builders[build_mode].build_message(data, phase, build_mode, locale)

    # from the list of errors generate an error message for a certain element (this combines the error messages of the errors belonging to the element)
    # message = concatenation of each validation-phase-message string if they are errors for that part (generated independently, defined in ERROR_MESSAGE_CONFIG.ORDER)
    # each part of the message can be generated differently (defined in ERROR_MESSAGE_CONFIG.BUILD_MODE)
    @_get_error_message_for_element: (element, errors, build_mode, locale, delimiter = " ") ->
        error_message_parts = []
        grouped_errors = {}
        # group by errors by .phase
        for phase of VALIDATION_PHASES
            grouped_errors[phase] = (error for error in errors when error.phase is phase)

        for phase in ERROR_MESSAGE_CONFIG.PHASE_ORDER when grouped_errors[phase].length > 0
            error_message_parts.push @_build_error_message(phase, grouped_errors[phase], build_mode, locale)

        return error_message_parts.join(delimiter)

    ########################################################################################################################
    ########################################################################################################################
    # CONSTRUCTORS
    @new: (form, options) ->
        if DEBUG and form not instanceof jQuery
            throw new Error("FormValidator::constructor: Invalid form given (must be a jQuery object)!")
        form_validator = new @(form, null, options)
        form_modifier = new FormModifier(form_validator, options)
        form_validator.form_modifier = form_modifier
        return form_validator

    @new_without_modifier: (form, options) ->
        return new @(form, null, options)

    ###*
    * @param form {Form}
    * @param options {Object}
    *###
    constructor: (form, form_modifier, options = {}) ->
        CLASS = @constructor

        @form = form
        @fields = null
        @form_modifier = form_modifier
        @last_validation = null

        @error_classes = options.error_classes or @form.attr("data-fv-error-classes") or "fv-invalid"
        @success_classes = options.success_classes or @form.attr("data-fv-success-classes") or "fv-valid"
        @dependency_error_classes = options.dependency_error_classes or @form.attr("data-fv-dependency-error-classes") or "fv-invalid-dependency"
        @dependency_change_action = options.dependency_change_action or @form.attr("data-fv-dependency-change-action") or DEPENDENCY_CHANGE_ACTIONS.DEFAULT

        @validators = $.extend {}, CLASS.validators, options.validators
        @validation_options = options.validation_options or null
        @constraint_validators = $.extend {}, CLASS.constraint_validators, options.constraint_validators

        @validator_call_context = $.extend {}, @validators, @constraint_validators

        @build_mode = options.build_mode or BUILD_MODES.DEFAULT
        # option for always using the simplest error message (i.e. the value '1.2' for 'integer' would print the error message 'integer' instead of 'integer_float')
        @error_mode = if CLASS.ERROR_MODES[options.error_mode]? then options.error_mode else CLASS.ERROR_MODES.DEFAULT
        @locale = options.locale or "en"

        @error_target_getter = options.error_target_getter or null
        @dependency_action_target_getter = options.dependency_action_target_getter or null
        @field_getter = options.field_getter or null
        @required_field_getter = options.required_field_getter or null
        @preprocessors = $.extend CLASS.default_preprocessors, options.preprocessors or {}
        @postprocessors = options.postprocessors or {}

        @group = options.group or null
        # modification of the errors possible before they are applied to DOM
        @process_errors = options.process_errors or null
        @_field_order = null


    ########################################################################################################################
    ########################################################################################################################
    # PRIVATE

    _get_fields: (form) ->
        return @field_getter?(form) or form.find("[data-fv-validate]").filter (idx, elem) ->
            return $(elem).closest("[data-fv-ignore-children]").length is 0

    _get_required: (fields) ->
        return @required_field_getter?(fields) or fields.not("[data-fv-optional='true']")

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

        if not value?
            value = DEFAULT_ATTR_VALUES[key.toUpperCase()]

        data[key] = value
        return data

    # END - CACHING

    _get_value: (element, data) ->
        {type} = data
        usedValFunc = true
        if type is "checkbox" or type is "radio"
            value = if element.prop("checked") is true then "checked" else "unchecked"
            method = "checkbox"
        else if type is "select"
            value = element.children(":selected").val()
            method = "val"
        else
            value = element.val()
            method = "val"

        if not value?
            usedValFunc = false
            value = element.text()
            method = "text"

        return {
            method: method
            value: value
        }

    _set_value: (element, data, method, value) ->
        if method is "checkbox"
            element.prop("checked", if value is "checked" then true else false)
        else if method is "val"
            element.val(value)
        # text
        else
            element.text(value)
        return @

    _get_value_info: (element, data) ->
        {type, preprocess} = data
        {method, value} = @_get_value(element, data)

        value_has_changed = value isnt data.value
        # cache latest element's value
        data.value = value

        if @preprocessors[type]? and preprocess isnt false
            value = @preprocessors[type].call(@preprocessors, value, element, @locale)

        return {
            method: method
            value: value
            value_has_changed: value_has_changed
        }

    _find_targets: (targets, element, delimiter = /\s*\;\s*/g) ->
        if typeof targets is "string"
            return (@_find_target(target, element) for target in targets.split(delimiter) when target.trim())
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
    _get_error_targets: (element, type) ->
        target_list = @error_target_getter?(element, type) or
            element.attr("data-fv-error-targets") or
            element.closest("[data-fv-error-targets]").attr("data-fv-error-targets") or
            DEFAULT_ATTR_VALUES.ERROR_TARGETS
        return @_find_targets(target_list, element)

    # how to find the correct data-fv-error-targets attribute for an element
    _get_dependency_action_targets: (element, type) ->
        target_list = @dependency_action_target_getter?(element, type) or
            element.attr("data-fv-dependency-action-targets") or
            element.closest("[data-fv-dependency-action-targets]").attr("data-fv-dependency-action-targets") or
            DEFAULT_ATTR_VALUES.DEPENDENCY_ACTION_TARGETS
        return @_find_targets(target_list, element)

    # create list of sets where each set is 1 unit for counting progress
    # returns: 1. array of arrays, 2. jquery set, or 3. array of jquery
    _group: (fields) ->
        dict = {}
        for i in [0...fields.length]
            elem = fields.eq(i)
            data = @_get_element_data(elem)

            if not data.group?
                data.group = elem.attr("data-fv-group") or elem.attr("name") or ""
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
            # filter errors of 1st invalid phase
            grouped_by_phase = group_arr_by elem_errors, (error) ->
                return error.phase
            for phase of VALIDATION_PHASES when (phase_errors = grouped_by_phase[phase])?.length > 0
                elem_errors = phase_errors
                break

            if elem_errors.length > 0
                if options.messages is true
                    message = CLASS._get_error_message_for_element(elem, elem_errors, @build_mode, @locale)
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

    _validate_value: (element, data, value_info) ->
        {type} = data
        {value} = value_info
        validator = @validators[type]
        if not validator?
            throw new Error("FormValidator::_validate_value: No validator found for type '#{type}'. Make sure the type is correct or define an according validator!")
        validation = validator.call(@validator_call_context, value, element)

        # if a simple return value was used (false/string containing the error message type) => create object
        if validation is false
            validation = {
                error_message_type: type
            }
        else if typeof validation is "string"
            validation = {
                error_message_type: validation
            }
        if validation isnt true
            validation.error_message_type = @constructor.get_error_message_type(validation.error_message_type, @error_mode)

        return validation

    # validation - phase 1
    _validate_dependencies: (element, data, options) ->
        errors = []
        elements = data.depends_on
        for dependency_elem, i in elements
            dependency_data = @_get_element_data(dependency_elem)
            elem_errors = @_validate_element(
                dependency_elem
                dependency_data
                @_get_value_info(dependency_elem, dependency_data)
                options
            )
            if elem_errors.length > 0
                errors.push {
                    dependency_element: dependency_elem
                    element: element
                    index: i
                    type: dependency_data.type
                    name: dependency_data.name
                }

        # cache dependency mode
        if not data.dependency_mode?
            # data.dependency_mode = element.attr("data-fv-dependency-mode") or DEFAULT_ATTR_VALUES.DEPENDENCY_MODE
            @_cache_attribute(element, data, "dependency_mode")
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
        # use cache
        if data.constraints?
            constraints = data.constraints
        # fill cache
        else
            CLASS = @constructor
            constraints = []
            for constraint_name, constraint_validator of @constraint_validators
                if (constraint_value = @_get_attribute_value_for_key(element, constraint_name))?
                    # get options
                    if (constraint_validator_options = CONSTRAINT_VALIDATOR_OPTIONS[constraint_name])?
                        options = {}
                        for option in constraint_validator_options
                            options[option] = @_get_attribute_value_for_key(element, option) or DEFAULT_ATTR_VALUES[option.toUpperCase()]
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
            if constraint.validator.call(@validator_call_context, value, constraint.value, constraint.options) is true
                results[constraint.name] = true
            else
                # create object with details about what's wrong
                result = {}
                result.options = constraint.options
                result[constraint.name] = constraint.value

                results[constraint.name] = result

        return results

    _validate_element: (elem, data, value_info, options) ->
        # if this function has been called before in the recursion (i.e. when validating dependencies)
        if data.last_validation is @last_validation
            return data.errors[VALIDATION_PHASES.DEPENDENCIES].concat(
                data.errors[VALIDATION_PHASES.VALUE]
                data.errors[VALIDATION_PHASES.CONSTRAINTS]
            )

        errors = []
        # accumulator (AND of each phase's valid state)
        prev_phases_valid = true
        is_required = data.required
        {type} = data
        {value, value_has_changed, method} = value_info

        #########################################################
        # PHASE 1: validate dependencies (no matter if the value has changed because dependencies could have changed)
        phase = VALIDATION_PHASES.DEPENDENCIES
        {dependency_errors, dependency_elements, dependency_mode, valid_dependencies} = @_validate_dependencies(elem, data, options)
        if not valid_dependencies
            prev_phases_valid = false
            $.extend(dependency_error, {
                element:    elem
                required:   is_required
                type:       "dependency"
                phase:      phase
                mode:       dependency_mode
            }) for dependency_error in dependency_errors
            data.errors[phase] = dependency_errors
        else
            data.errors[phase] = []

        data.dependency_changed = valid_dependencies isnt data.valid_dependencies
        data.valid_dependencies = valid_dependencies

        errors = errors.concat data.errors[phase]

        #########################################################
        # PHASE 2: validate the value
        phase = VALIDATION_PHASES.VALUE
        if prev_phases_valid or not options.stop_on_error
            # NOTE: the 2nd part of the disjunction is implied by "dependency has changed from invalid to valid AND no errors have been generated before". but we cannot know if errors where generated before so we use length == 0 to get as close as possible...
            if value_has_changed or (data.dependency_changed and data.valid_dependencies and data.errors[phase].length is 0)
                validation_res = @_validate_value(elem, data, value_info)
                # element is invalid
                if validation_res isnt true
                    prev_phases_valid = false
                    data.valid_value = false
                    data.errors[phase] = [{
                        element: elem
                        error_message_type: validation_res.error_message_type
                        phase: phase
                        required: is_required
                        type: type
                        value: value
                    }]
                else
                    data.valid_value = true
                    data.errors[phase] = []
            # value has not changed (data is unchanged)
            else if not value_has_changed
                if prev_phases_valid or not options.stop_on_error
                    if data.valid_value isnt true
                        prev_phases_valid = false

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
        # value has not changed (data is unchanged)
        else
            if prev_phases_valid or not options.stop_on_error
                if data.valid_constraints isnt true
                    prev_phases_valid = false

        errors = errors.concat data.errors[phase]

        if data.valid_dependencies and data.valid_value and data.valid_constraints
            # update data.valid and cache uncached data
            if data.valid isnt true or not data.postprocess? or not data.output_preprocessed?
                data.valid = true
                @_cache_attribute(elem, data, "postprocess")
                @_cache_attribute(elem, data, "output_preprocessed")

            if data.postprocess is true or data.output_preprocessed is true
                # replace old value with post processed value
                if data.postprocess is true
                    value = @postprocessors[type]?.call(@postprocessors, value, elem, @locale)
                # replace old value with pre processed value
                else if data.output_preprocessed is true
                    if @preprocessors[type]?
                        value = @preprocessors[type].call(@preprocessors, value, elem, @locale)

                @_set_value(elem, data, method, value)

                for error in errors
                    error.value = value
        else
            if data.valid isnt false
                data.valid = false

        if not data.dependency_action_targets?
            @_cache_attribute elem, data, "dependency_action_targets", () ->
                return @_get_dependency_action_targets(elem, type)
            @_cache_attribute(elem, data, "dependency_action_duration")
            data.dependency_action_duration = parseInt(data.dependency_action_duration, 10)

        # cache error targets because error classes will be applied to them in the next step (form modifcation)
        if options.apply_error_classes is true and not data.error_targets?
            @_cache_attribute elem, data, "error_targets", () ->
                return @_get_error_targets(elem, type)

        data.last_validation = @last_validation

        # make element's data persistent
        @_set_element_data(elem, data)
        return errors
    # END - VALIDATION HELPERS


    ########################################################################################################################
    ########################################################################################################################
    # PUBLIC

    # can be used to eagerly load all data
    cache: () ->
        fields = @_get_fields(@form)
        dependency_data = {}
        id_to_elem = {}
        for i in [0...fields.length]
            elem = fields.eq(i)
            data = {}

            for key in REQUIRED_CACHE
                data[key] = @_get_attribute_value_for_key(elem, key)
            # already parse the list of dependencies as list of jquery elements ("" => [], null => []), delimiter = ';'
            data.depends_on = @_find_targets(data.depends_on, elem, /^\s*\;\s*$/g)
            # needed for toposort (see TODOs)
            data.id = i
            # fallback to global change action
            if not data.dependency_change_action?
                data.dependency_change_action = @dependency_change_action
            # set keys that are cached later (lazily) to null (which means unknow)
            for key in OPTIONAL_CACHE
                data[key] = null
            data.errors = {}
            data.errors[VALIDATION_PHASES.DEPENDENCIES] = []
            data.errors[VALIDATION_PHASES.VALUE] = []
            data.errors[VALIDATION_PHASES.CONSTRAINTS] = []

            @_set_element_data(elem, data)

            # determine validation order according to defined dependencies
            id_to_elem[data.id] = elem
            dependency_data[data.id] = (@_get_element_data(dep).id for dep in data.depends_on)

        @fields =
            all: fields
            required: @_get_required(fields)
            ordered: (id_to_elem[id] for id in toposort(dependency_data))

        console.log "validation order:", toposort(dependency_data)

        return @

    ###*
    * @method validate
    * @param options {Object}
    * Default is this.validation_option. Otherwise:
    * Valid options are:
    *  - all:                   {Boolean} (default is false)
    *    -> force validation on optional fields
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

        @last_validation = Date.now()

        CLASS = @constructor
        errors = []
        usedValFunc = false
        fields = @fields.ordered

        for elem in fields
            data = @_get_element_data(elem)
            is_required = data.required
            {type, name} = data
            value_info = @_get_value_info(elem, data)

            # skip empty optional elements
            if options.all is false and not is_required and (value_info.value.length is 0 or type is "radio" or type is "checkbox")
                # NOTE:40 if an optional value was invalid and was emptied the error target's error classes should be removed
                if not data.error_targets?
                    data = @_cache_attribute elem, data, "error_targets", () ->
                        return @_get_error_targets(elem, type)
                    @_set_element_data(elem, data)
                continue

            elem_errors = @_validate_element(elem, data, value_info, options)
            if elem_errors.length > 0
                errors = errors.concat elem_errors

        grouped_errors =  @_group_errors(errors, options)
        @process_errors?(grouped_errors)
        if options.modify isnt false
            @form_modifier?.modify(grouped_errors, options)
        return grouped_errors

    get_progress: (options = {mode: PROGRESS_MODES.DEFAULT, recache: false}) ->
        if not @fields? or options.recache is true
            @cache()

        fields = @fields.all
        # TODO: cache groups
        groups = @group?(fields) or @_group(fields)
        result = []

        errors = @validate({
            all: true
            messages: false
            modify: false
            recache: false
            stop_on_error: true
        })

        {mode} = options

        for group, i in groups
            console.log "group ##{i+1}:", group
            num_required = 0
            num_optional = 0
            num_valid_required = 0
            num_valid_optional = 0
            for elem, j in group
                if elem not instanceof jQuery
                    elem = group.eq?(j) or $(elem)
                data = @_get_element_data(elem)
                if data.required is true
                    num_required++
                    if data.valid is true
                        num_valid_required++
                else
                    num_optional++
                    if data.valid is true
                        num_valid_optional++

            # at least 1 required field
            if num_required > 0
                if mode is PROGRESS_MODES.PERCENTAGE
                    result.push num_valid_required / num_required
                else if mode is PROGRESS_MODES.ABSOLUTE
                    result.push {
                        count: num_valid_required
                        total: num_required
                    }
            # optionals only
            else if num_optional > 0
                if num_valid_optional > 0
                    if mode is PROGRESS_MODES.PERCENTAGE
                        result.push 1
                    else if mode is PROGRESS_MODES.ABSOLUTE
                        result.push {
                            count: num_optional
                            total: num_optional
                        }
                else
                    if mode is PROGRESS_MODES.PERCENTAGE
                        result.push 0
                    else if mode is PROGRESS_MODES.ABSOLUTE
                        result.push {
                            count: 0
                            total: num_optional
                        }
            # empty group
            else
                result.push null

        sum = 0
        n = 0
        for r in result when r?
            sum += r
            n++
        result.average = sum / n
        return result
