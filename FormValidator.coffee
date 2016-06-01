###<?php
// this PHP code is for making the file only
require_once __DIR__.'/make/make_funcs.php';
$part = __DIR__.'/'.$argv[2];
$target = $argv[3];
?>###
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
        form_validator = @new_without_modifier(form, options)
        ###<?php
        if ($target !== 'core') {
            echo "form_validator.form_modifier = new FormModifier(form_validator, options)\n";
        }
        else {
            echo "\n";
        }
        ?>###
        return form_validator

    @new_without_modifier: (form, options) ->
        if DEBUG and form not instanceof jQuery
            throw new Error("FormValidator::constructor: Invalid form given (must be a jQuery object)!")
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

    ########################################################################################################################
    # INCLUDE FILE FOR SYNC/ASYNC VERSION
    ###<?php
    readfile_indent($part, 4);
    ?>###
