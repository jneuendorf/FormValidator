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
            # TODO:40 if an optional value was invalid and was emptied the error target's error classes should be removed
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
