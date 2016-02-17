class window.FormValidator
    # TODO: performance: be lazy: whenever a form field is analyzed cache that information in form validator (because the validation is very likely to be done several times before submitting actually happens)
    # TODO: create graph with meta data so single elements can be validated (even if they have dependencies)
    # TODO: add onchange handler to standard elements: check only changed elements (also for real time validation)
    # TODO: add effects for dependencies
    # TODO: define constraint validators for constraints that are independent from type validators

    ########################################################################################################################
    ########################################################################################################################
    # CLASS CONFIGURATION

    # defined in constraint_validators.coffee
    @constraint_validators = constraint_validators

    # defined in validators.coffee
    @validators = validators

    # defined in error_messages.coffee
    @error_messages = error_messages

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


    @ERROR_MODES =
        NORMAL: "NORMAL"
        SIMPLE: "SIMPLE"
    @ERROR_MODES.DEFAULT = @ERROR_MODES.NORMAL

    @ERROR_OUTPUT_MODES =
        BELOW: "BELOW"
        BOOTSTRAP_POPOVER: "BOOTSTRAP_POPOVER"
        BOOTSTRAP_POPOVER_ON_FOCUS: "BOOTSTRAP_POPOVER_ON_FOCUS"
        NONE: "NONE"
    @ERROR_OUTPUT_MODES.DEFAULT = @ERROR_OUTPUT_MODES.NONE

    # list of meta data that can be cached right away because each item is needed for a basic validation (all other data will be cached when it is needed)
    # => this is the list of data that is always cached
    CACHED_FIELD_DATA = [
        "depends_on"
        "name"
        "preprocess"
        "required"
        "type"
    ]

    ########################################################################################################################
    ########################################################################################################################
    # INIT

    # enable autobound buttons
    $(document).on "click", "[data-fv-start!='']", () ->
        $elem = $(@)
        container = $elem.closest($elem.attr("data-fv-start"))
        if container.length is 1
            if not (form_validator = container.data("_form_validator"))?
                form_validator = new FormValidator(container)
                container.data("_form_validator", form_validator)
            form_validator.validate()
        return true

    # enable real-time validation
    $(document).on "change click keyup", "[data-fv-real-time] [data-fv-validate]", (evt) ->
        $elem = $(@)

        # prevent click in textfields (which also triggers the change event on previously focussed inputs) to trigger validation
        if (evt.type is "click" or evt.type is "change") and $elem.filter("textarea, input[type='text'], input[type='number'], input[type='date'], input[type='month'], input[type='week'], input[type='time'], input[type='datetime'], input[type='datetime-local'], input[type='email'], input[type='search'], input[type='url']").length is $elem.length
            return true

        container = $elem.closest("[data-fv-real-time]")
        if container.length is 1
            if not (form_validator = container.data("_form_validator"))?
                form_validator = new FormValidator(container)
                container.data("_form_validator", form_validator)
            errors = form_validator.validate()
            # if there are errors, keep the focus on the current element because it would otherwise move elsewhere
            #  without errors we just keep the focus because the form validator would not change it
            if errors.length > 0
                $elem.focus()
        return true

    ########################################################################################################################
    ########################################################################################################################
    # CONSTRUCTORS
    @new: (form, options) ->
        return new @(form, options)

    ###*
    * @param form {Form}
    * @param options {Object}
    *###
    constructor: (form, options = {}) ->
        CLASS = @constructor

        if form instanceof jQuery
            @form = form
        else if form?
            @form = $ form
        else if DEBUG
            throw new Error("FormValidator::constructor: Invalid form given!")
        @fields = null

        # default css error classes. can be overridden by data-fv-error-classes on any error target
        @error_classes          = options.error_classes or @form.attr("data-fv-error-classes") or ""
        @dependency_error_classes = options.dependency_error_classes or @form.attr("data-fv-dependency-error-classes") or ""
        @validators             = $.extend {}, CLASS.validators, options.validators
        @validation_options     = options.validation_options or null
        @error_messages         = options.error_messages
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
    # STATIC METHODS

    ########################################################################################################################
    ########################################################################################################################
    # PRIVATE

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

        value = element.attr(attribute).trim()

        if key in boolean
            value = if value is "true" then true else false

        # special because 'required' corresponds to 'optional'
        if key is "required"
            value = not value

        return value


    # data is the last validation result + the last validated value
    _set_element_data: (element, data) ->
        $.data(element, "_fv", data)
        return @

    _get_element_data: (element) ->
        return $.data(element, "_fv")


    _create_error_message: (locale, params) ->
        CLASS = @constructor

        type = params.error_message_type or params.element.attr("data-fv-validate")
        type = CLASS.get_error_message_type(type, @error_mode)
        message = (@error_messages or @constructor.error_messages)[@locale][type]
        if not message?
            return null

        # string => insert variables (mustache-like)
        # TODO: just use mustache!?
        if typeof message is "string"
            for key, val of params when message.indexOf("{{#{key}}}") >= 0
                message = message.replace("{{#{key}}}", val)
            res = message
        else if message instanceof Function
            res = message(params)

        return res

    _get_fields: (form) ->
        return @field_getter?(form) or form.find("[data-fv-validate]").filter (idx, elem) ->
            return $(elem).closest("[data-fv-ignore-children]").length is 0

    _get_required: (fields) ->
        return @required_field_getter?(fields) or fields.not("[data-fv-optional='true']")

    _get_value: (element, data) ->
        {type, preprocess} = data
        usedValFunc = true
        value = element.val()
        if not value?
            usedValFunc = false
            value = element.text()


        if @preprocessors[type]? and preprocess isnt false
            value = @preprocessors[type].call(@preprocessors, value, element, @locale)

        return {
            usedValFunc: usedValFunc
            value: value
        }

    _find_targets: (targets, element) ->
        if typeof targets is "string"
            return (@_find_target(target, element) for target in targets.split(/\s+/g))
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

    # apply error classes and styles to element if invalid
    _apply_error_styles: (element, error_targets, is_valid) ->
        if error_targets?
            # split and trim
            if typeof error_targets is "string"
                error_targets = error_targets.split /\s+/g

            targets = @_find_targets(error_targets, element)
            for target in targets
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

    _apply_dependency_error_styles: (error_targets, is_valid) ->
        if error_targets?
            for target in error_targets
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
        return @

    # create list of sets where each set is 1 unit for counting progress
    _group: (fields) ->
        dict = {}
        fields.each (idx, elem) ->
            $elem = $ elem
            name = $elem.attr("data-fv-group") or $elem.attr("name")
            if not dict[name]?
                dict[name] = [$elem]
            else
                dict[name].push $elem
            return true

        return (elems for name, elems of dict)

    # VALIDATION HELPERS

    _validate_element: (element, type, value, usedValFunc, info) ->
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

        if info?
            info.type = type
            info.usedValFunc = usedValFunc
            info.validator = validator
            info.value = value

        return validation

    # validation - phase 1
    _validate_dependencies: (element, type) ->
        errors = []
        elements = []
        if (depends_on = element.attr("data-fv-depends-on"))?
            elements = @_find_targets(depends_on, element)
            for dependency_elem, i in elements
                elements.push dependency_elem
                info = {}
                # TODO: use cached validation results
                # FIXME: do not use given elements type and value BUT THE DEPENDENCY FIELD'S
                dependency_validation = @_validate_element(dependency_elem, type, @_get_value(element, type) info)
                if dependency_validation isnt true
                    errors.push $.extend(dependency_validation, {
                        element: dependency_elem
                        index:   i
                        type:    info.type
                        value:   info.value
                    })

        # at least 1 dependency is valid <=> valid
        if element.attr("data-fv-dependency-mode") is "any"
            valid = errors.length < elements.length
            mode = "any"
        # no dependency is invalid <=> valid
        else
            valid = errors.length is 0
            mode = "all"

        return {
            dependency_errors: errors
            dependency_elements: elements
            valid_dependencies: valid
            dependency_mode: mode
        }

    _validate_constraints: (element) ->
        return {

        }


    ########################################################################################################################
    ########################################################################################################################
    # PUBLIC

    # GETTERS + SETTERS

    set_error_target_getter: (error_target_getter) ->
        @error_target_getter = error_target_getter
        return @

    set_field_getter: (field_getter) ->
        @field_getter = field_getter
        return @

    set_required_field_getter: (required_field_getter) ->
        @required_field_getter = required_field_getter
        return @

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
            data = @_get_element_data(elem)
            if not data?
                keys = CACHED_FIELD_DATA
                # set keys that are cached later to null (which means unknow)
                data =
                    # field data
                    dependency_mode: null
                    error_targets: null
                    group: null
                    output_preprocessed: null
                    postprocess: null
                    # validation (meta) data
                    constraints: null
                    valid: null
                    value: null
                for key in keys
                    data[key] = @_get_attribute_value_for_key(key)
                # already parse the list of dependencies as list of jquery elements ("" => [], null => [])
                data.depends_on = @_find_targets(data.depends_on, elem)

                @_set_element_data(elem, data)

        return @

    ###*
    * @method validate
    * @param options {Object}
    * Default is this.validation_option. Otherwise:
    * Valid options are:
    *  - apply_error_styles:    {Boolean} (default is true)
    *  - all:                   {Boolean} (default is false)
    *  - focus_invalid:         {Boolean} (default is true)
    *  - recache:               {Boolean} (default is false)
    *###
    validate: (options = @validation_options or {apply_error_styles: true, all: false, focus_invalid: true, recache: false}) ->
        default_options =
            apply_error_styles: true
            all: false
            focus_invalid: true
            recache: false

        options = $.extend default_options, @validation_options, options

        if not @fields? or options.recache is true
            @cache()

        CLASS           = @constructor
        errors          = []
        prev_name       = null
        indices_by_type = {}
        usedValFunc     = false

        # NOTE: remerge required and optional fields in order to:
        # 1. have 1 loop only
        # 2. continuous and correct indices

        required = @fields.required
        fields = @fields.all
        first_invalid_element = null

        for i in [0...fields.length]
            elem = fields.eq(i)
            data = @_get_element_data(elem)
            is_required = data.required
            {type, name} = data
            {value, usedValFunc} = @_get_value(elem, data)

            if indices_by_type[type]?
                index_of_type = ++indices_by_type[type]
            else
                indices_by_type[type] = 1
                index_of_type = 1

            # skip empty optional elements
            if options.all is false and not is_required and (value.length is 0 or type is "radio" or type is "checkbox")
                # NOTE: if an optional value was invalid and was emptied the error target's error classes should be removed
                @_apply_error_styles(
                    elem
                    @error_target_getter?(type, elem, i) or elem.attr("data-fv-error-targets") or elem.closest("[data-fv-error-targets]").attr("data-fv-error-targets")
                    true
                )
                # TODO also reset dependency styles
                continue

            prev_phase_valid = true

            # PHASE 1: check if dependencies are fulfilled
            {dependency_errors, dependency_elements, dependency_mode, valid_dependencies} = @_validate_dependencies(elem, type)
            if not valid_dependencies
                is_valid = false
                prev_phase_valid = false
                # create error if the element has unfulfilled dependencies
                errors.push {
                    element:    elem
                    message:    @create_dependency_error_message?(@locale, dependency_errors) or @_create_error_message(@locale, {
                        element: elem
                        error_message_type: "dependency"
                        dependency_mode: dependency_mode
                        dependency_errors: dependency_errors
                    })
                    required:   is_required
                    type:       "dependency"
                    mode:       dependency_mode
                }
                if not first_invalid_element?
                    first_invalid_element = elem
                # TODO skip remaing loop content until error classes are applied

            # PHASE 2: validate the value
            if prev_phase_valid
                info = {}
                # TODO: cache validation result (for dependency validation)
                validation = @_validate_element(elem, type, value, usedValFunc, info)
                is_valid = (validation is true)
                {validator} = info
                current_error = null

                # element is invalid
                if not is_valid
                    error_message_params = $.extend validation, {
                        element:        elem
                        index:          i
                        index_of_type:  index_of_type
                        name:           name
                        previous_name:  prev_name
                        value:          value
                    }
                    current_error =
                        element:    elem
                        message:    @_create_error_message(@locale, error_message_params)
                        required:   is_required
                        type:       type
                        validator:  validator
                        value:      value
                    errors.push current_error

                    if not first_invalid_element?
                        first_invalid_element = elem


            # PHASE 3 - validate constraints
            if prev_phase_valid
                # TODO
                @_validate_constraints(elem)
                true

            # no validation phase was invalid => element is valid
            if prev_phase_valid
                # replace old value with post processed value
                if elem.attr("data-fv-postprocess") is "true"
                    value = @postprocessors[type]?.call(@postprocessors, value, elem, @locale)
                    if usedValFunc
                        elem.val value
                    else
                        elem.text value
                    current_error?.value = value
                # replace old value with pre processed value
                else if elem.attr("data-fv-output-preprocessed") is "true"
                    value = @preprocessors[type]?.call(@preprocessors, value, elem, @locale)
                    if usedValFunc
                        elem.val value
                    else
                        elem.text value
                    current_error?.value = value

            if options.apply_error_styles is true
                error_targets = @_apply_error_styles(
                    elem
                    @error_target_getter?(type, elem, i) or elem.attr("data-fv-error-targets") or elem.closest("[data-fv-error-targets]").attr("data-fv-error-targets")
                    is_valid
                )

                if current_error?
                    current_error.error_targets = error_targets

                @_apply_dependency_error_styles(dependency_elements, is_valid)

            prev_name = name

        if options.focus_invalid is true
            first_invalid_element?.focus()
        return errors

    get_progress: (options = {as_percentage: false, recache: false}) ->
        if not @fields? or options.recache is true
            @cache()

        fields = @fields.all
        required = @fields.required
        groups = @group?(fields) or @_group(fields)

        total = groups.length
        count = 0

        errors = @validate({
            apply_error_styles: false
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
