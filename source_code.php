<pre class="brush: ruby">
    class window.FormValidator
        ########################################################################################################################
        ########################################################################################################################
        # CLASS CONFIGURATION

        @validators =
            email: (str, elem) ->
                if str.indexOf("@") < 0
                    return {
                        error_message_type: "email_at"
                    }
                parts = str.split "@"
                if parts.length > 2
                    return {
                        error_message_type: "email_many_at"
                    }
                if parts.length is 2 and parts[0] isnt "" and parts[1] isnt ""
                    # check if there is a dot in domain parts
                    if str.indexOf(".", str.indexOf("@")) < 0 or str[str.length - 1] is "."
                        return {
                            error_message_type: "email_dot"
                        }
                    return true
                return {
                    error_message_type: "email"
                }
            integer: (str, elem, min, max, include_min, include_max) ->
                res = @_number(str, elem, min, max, include_min, include_max)
                if res.valid is true
                    if res._number is Math.floor(res._number)
                        return true
                    return {
                        error_message_type: "integer_float"
                    }

                str = res._string
                n = Math.floor(res._number)

                if isNaN(n) or not isFinite(n) or str isnt "#{n}"
                    return {
                        error_message_type: "integer"
                    }
                res.error_message_type = res.error_message_type.replace("number_", "integer_")
                return res
            number: (str, elem, min, max, include_min, include_max) ->
                res = @_number(str, elem, min, max, include_min, include_max)
                if res.valid is true
                    return true
                return res
            # "private" validator (used in other validators)
            _number: (str, elem, min, max, include_min = true, include_max = true) ->
                str = str.replace(/\s/g, "")
                if str[0] is "+"
                    str = str.slice(1)
                if str[0] is "."
                    str = "0#{str}"
                else if str[0] is "-" and str[1] is "."
                    str = "-0.#{str.slice(2)}"
                # remove trailing zeros
                if str.indexOf(".") >= 0
                    while str[str.length - 1] is "0"
                        str = str.slice(0, -1)
                    # if i.e. "0.00" became "0." make it "0"
                    if str[str.length - 1] is "."
                        str = str.slice(0, -1)

                n = parseFloat(str)

                if isNaN(n) or not isFinite(n) or str isnt "#{n}"
                    return {
                        error_message_type: "number"
                        _number: n
                        _string: str
                    }
                # max
                data_max = parseFloat(elem.attr("data-fv-max"))
                if not isNaN(data_max)
                    max = data_max
                    data_include_max = elem.attr("data-fv-include-max")
                    if data_include_max?
                        include_max = (if data_include_max.toLowerCase() is "false" then false else true)
                # min
                data_min = parseFloat(elem.attr("data-fv-min"))
                if not isNaN(data_min)
                    min = data_min
                    data_include_min = elem.attr("data-fv-include-min")
                    if data_include_min?
                        include_min = (if data_include_min.toLowerCase() is "false" then false else true)

                # max is always before min in message type in error_message_type
                error_message_type = "number"
                valid = true
                # MAX
                if max? and include_max and n > max
                    error_message_type += "_max_included"
                    valid = false
                else if max? and not include_max and n >= max
                    error_message_type += "_max"
                    valid = false

                # MIN
                if min? and include_min and n < min
                    error_message_type += "_min_included"
                    valid = false
                else if min? and not include_min and n <= min
                    error_message_type = "_min"
                    valid = false

                if not valid
                    res = {
                        error_message_type: error_message_type
                        _number: n
                        _string: str
                    }
                    if max?
                        res.max = max
                    if min?
                        res.min = min
                    return res

                # valid
                return {
                    valid: true
                    _number: n
                    _string: str
                }
            phone: (str, elem) ->
                if str.length < 3
                    return {
                        error_message_type: "phone_length"
                        length: 3
                    }
                str = str.replace(/[\s+\+\-\/\(\)]/g, "")
                while str[0] is "0"
                    str = str.slice(1)
                if str isnt "#{parseInt(str, 10)}"
                    return {
                        error_message_type: "phone"
                    }
                return true
            text: (str, elem) ->
                return str.length > 0
            radio: (str, elem) ->
                return $("[name='" + elem.attr("name") + "']:checked").length > 0
            checkbox: (str, elem) ->
                return elem.prop("checked") is true
            select: (str, elem) ->
                return @text(elem.val())

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

        @error_messages = locales.error_messages

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

            # prevent click in textfields to trigger validation
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

        constructor: (form, options = {}) ->
            CLASS = @constructor

            if form instanceof jQuery
                @form = form
            else if form?
                @form = $ form
            else if DEBUG
                throw new Error("FormValidator::constructor: Invalid form given!")
            @fields = null

            @error_classes          = options.error_classes or @form.attr("data-fv-error-classes") or ""
            @dependency_error_classes = options.dependency_error_classes or @form.attr("data-fv-dependency-error-classes") or @error_classes
            @validators             = $.extend {}, CLASS.validators, options.validators
            @validation_options     = options.validation_options or null
            @error_messages         = options.error_messages
            @error_mode             = if CLASS.ERROR_MODES[options.error_mode]? then options.error_mode else CLASS.ERROR_MODES.DEFAULT
            @error_output_mode      = if CLASS.ERROR_OUTPUT_MODES[options.error_output_mode]? then options.error_output_mode else CLASS.ERROR_OUTPUT_MODES.DEFAULT
            @locale                 = options.locale or "en"

            @error_target_getter    = options.error_target_getter or null
            @field_getter           = options.field_getter or null
            @required_field_getter  = options.required_field_getter or null
            @optional_field_getter  = options.optional_field_getter or null
            @create_dependency_error_message = options.create_dependency_error_message or null
            @preprocessors          = $.extend CLASS.default_preprocessors, options.preprocessors or {}
            @postprocessors         = options.postprocessors or {}
            @group                  = options.group or null

        ########################################################################################################################
        ########################################################################################################################
        # PRIVATE

        _update: () ->
            fields = @_get_fields(@form)

            @fields =
                all: fields
                required: @_get_required(fields)
                optional: @_get_optional(fields)

            return @

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
            # explicit
            if @required_field_getter?
                return @required_field_getter?(fields)
            # implicit
            # get all that are not optional
            if @optional_field_getter?
                result = $()
                optional_fields = @optional_field_getter(fields)
                fields.each (idx, elem) ->
                    $elem  = $ elem
                    if optional_fields.index($elem) is -1
                        result = result.add($elem)

                return result
            # get all without attribute
            return fields.not("[data-fv-optional='true']")

        _get_optional: (fields) ->
            return @optional_field_getter?(fields) or fields.filter("[data-fv-optional='true']")

        # used within FormValidator::validate()
        _get_value: (element, type) ->
            usedValFunc = true
            value = element.val()
            if not value?
                usedValFunc = false
                value = element.text()

            if @preprocessors[type]? and element.attr("data-fv-preprocess") isnt "false"
                value = @preprocessors[type].call(@preprocessors, value, element, @locale)

            return {
                usedValFunc: usedValFunc
                value: value
            }

        _find_target: (target) ->
            result = @form.find("[data-fv-name='#{target}']")
            # nothing found => try jquery selector instead of data-fv-name property
            if result.length is 0
                result = @form.find(target)
            # nothing found => try to find selector in entire document
            if result.length is 0
                result = $(target)
            return result

        _apply_error_styles: (element, error_targets, is_valid) ->
            if error_targets?
                if typeof error_targets is "string"
                    error_targets = error_targets.split /\s+/g

                targets = []
                for error_target in error_targets
                    if error_target isnt "self"
                        target = @_find_target(error_target)
                    else
                        target = element
                    targets.push target

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

        ########################################################################################################################
        ########################################################################################################################
        # PUBLIC

        set_error_target_getter: (error_target_getter) ->
            @error_target_getter = error_target_getter
            return @

        set_field_getter: (field_getter) ->
            @field_getter = field_getter
            return @

        set_required_field_getter: (required_field_getter) ->
            @required_field_getter = required_field_getter
            return @

        set_optional_field_getter: (optional_field_getter) ->
            @optional_field_getter = optional_field_getter
            return @

        register_validator: (type, validator, error_message_types) ->
            if DEBUG
                # check validator
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

        validate: (options = @validation_options or {apply_error_styles: true, all: false}) ->
            if not @fields?
                @_update()

            CLASS           = @constructor
            result          = true
            errors          = []
            prev_name       = null
            indices_by_type = {}
            usedValFunc     = false

            validate_field = (field, info) =>
                type = elem.attr("data-fv-validate")
                {value, usedValFunc} = @_get_value(field, type)

                validator = @validators[type]
                validation = validator.call(@validators, value, elem)

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

            required = @fields.required
            fields = @fields.all
            first_invalid_element = null

            for i in [1..fields.length]
                elem        = $(fields[i - 1])
                is_required = required.index(elem) >= 0

                info = {}
                validation = validate_field(elem, info)
                is_valid = (validation is true)
                {type, usedValFunc, validator, value} = info
                current_error = null

                if indices_by_type[type]?
                    index_of_type = ++indices_by_type[type]
                else
                    indices_by_type[type] = 1
                    index_of_type = 1

                # skip empty optional elements
                if options.all is false and not is_required and (value.length is 0 or type is "radio" or type is "checkbox")
                    @_apply_error_styles(
                        elem
                        @error_target_getter?(type, elem, i) or elem.attr("data-fv-error-targets") or elem.closest("[data-fv-error-targets]").attr("data-fv-error-targets")
                        true
                    )
                    continue

                name = elem.attr("data-fv-name")
                depends_on = elem.attr("data-fv-depends-on")

                # check if dependencies are fulfilled
                dependency_errors = []
                dependency_elements = []
                if depends_on?
                    dependencies = depends_on.split /\s+/g
                    for dependency, j in dependencies
                        dependency_elem = @_find_target(dependency)
                        dependency_elements.push dependency_elem
                        info = {}
                        dependency_validation = validate_field(dependency_elem, info)
                        if dependency_validation isnt true
                            dependency_errors.push $.extend(dependency_validation, {
                                element: dependency_elem
                                index:   j
                                type:    info.type
                                value:   info.value
                            })

                # element is invalid
                if not is_valid or dependency_errors.length > 0
                    result = false

                    # create error message if the element has unfulfilled dependencies
                    if dependency_errors.length > 0
                        errors.push {
                            element:    elem
                            message:    @create_dependency_error_message?(@locale, dependency_errors) or @_create_error_message(@locale, {element: elem, error_message_type: "dependency"})
                            required:   is_required
                            type:       "dependency"
                        }
                        is_valid = false
                    # create normal error message
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
                # element is valid
                else
                    # replace old value with post processed value
                    if (@postprocessors[type]? and elem.attr("data-fv-postprocess") isnt "false")
                        value = @postprocessors[type].call(@postprocessors, value, elem, @locale)
                        if usedValFunc
                            elem.val value
                        else
                            elem.text value
                    # replace old value with pre processed value
                    else if elem.attr("data-fv-output-preprocessed") is "true"
                        value = @preprocessors[type].call(@preprocessors, value, elem, @locale)
                        if usedValFunc
                            elem.val value
                        else
                            elem.text value

                prev_name = name

                if options.apply_error_styles is true
                    error_targets = @_apply_error_styles(
                        elem
                        @error_target_getter?(type, elem, i) or elem.attr("data-fv-error-targets") or elem.closest("[data-fv-error-targets]").attr("data-fv-error-targets")
                        is_valid
                    )

                    if current_error?
                        current_error.error_targets = error_targets

                    @_apply_dependency_error_styles(dependency_elements, is_valid)


            first_invalid_element?.focus()
            return errors

        get_progress: (as_percentage = false) ->
            if not @fields?
                @_update()

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
                for elem in group
                    elem = $(elem)

                    for error in errors when error.element.is(elem)
                        found_error = true
                        break
                    if found_error
                        break
                if not found_error
                    count++

            if not as_percentage
                return {
                    count: count
                    total: total
                }
            return count / total
</pre>