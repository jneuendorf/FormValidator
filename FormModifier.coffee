# This class takes the errors to a FormValidator instance and modifies the form according to these errors.
class FormModifier

    # CONSTRUCTOR
    constructor: (form_validator, options = {}) ->
        @form_validator = form_validator
        if ERROR_OUTPUT_MODES[options.error_output_mode]? or options.error_output_mode instanceof Function
            @error_output_mode = options.error_output_mode
        else
            @error_output_mode = ERROR_OUTPUT_MODES.DEFAULT

    # class_kind is either "error_classes" or "dependency_error_classes"
    _apply_classes: (element, targets, classes, is_valid) ->
        if targets?
            # targets = @form_validator._find_targets(error_targets, element)
            for target, i in targets
                if target not instanceof jQuery
                    target = targets.eq(i)

                if is_valid is false
                    target.addClass classes
                else
                    target.removeClass classes
            return targets
        return []

    _set_message_below: (message, element, data) ->
        if not (target = element.data("_fv_error_container"))?
            # put errors for radio buttons BEHIND the LAST instead of after the 1st
            if data.type is "radio"
                element = $("input[name='#{element.attr("name")}']").last()

            if (target = element.next(".fv-error-message")).length is 0
                target = $ """<div class="fv-error-message" />"""
                element.after target
            element.data("_fv_error_container", target)
        target.html message
        return @

    _set_message_tooltip: (message, element, data) ->
        # 1st initialization
        if not element.data("_fv_tooltip")?
            element
                .tooltip {
                    html: true
                    placement: element.attr("data-placement") or "top"
                    title: () ->
                        return $(@).data("_fv_tooltip")
                }
        element.data("_fv_tooltip", message).tooltip("hide")
        return @

    _set_message_popover: (message, element, data) ->
        # fallback for some elements where an error message on click does not make sense
        if data.type is "checkbox" or data.type is "radio" or data.type is "select"
            element.attr("title", message)
            return @
        # else:
        # 1st initialization
        if not element.data("_fv_popover")?
            element_focussed = null
            element
                .popover {
                    html: true
                    placement: element.attr("data-placement") or "right"
                    content: () ->
                        return $(@).data("_fv_popover")
                    trigger: "manual"
                }
                .focus () ->
                    element.popover("show")
                    element_focussed = true
                    return false
                .blur () ->
                    element.popover("hide")
                    element_focussed = false
                    return true
                .click () ->
                    if document.activeElement is @
                        if not element_focussed
                            element.popover("toggle")
                    element_focussed = false
                    return true
        element.data("_fv_popover", message).popover("hide")
        return @

    _process_error_message: (message, element, data) ->
        if @error_output_mode is ERROR_OUTPUT_MODES.NONE
            return @

        if @error_output_mode instanceof Function
            target = @error_output_mode(element, data, message)
            target.html message
        else
            error_output_mode = @error_output_mode.toLowerCase()
            @["_set_message_#{error_output_mode}"](message, element, data)
        return @

    _process_max_length: (constraint, element, data) ->
        if constraint.options.enforce_max_length is "true"
            length = parseInt(constraint.value, 10)
            val = data.value.slice(0, length)
            data.value = val
            element.val(val)
            return true
        return false

    _process_min_length: (constraint, element, data) ->
        if constraint.options.enforce_min_length is "true"
            length = parseInt(constraint.value, 10)
            val = data.value + ("." for i in [0...(data.value.length - length)]).join("")
            data.value = val
            element.val(val)
            return true
        return false

    _process_constraint: (constraint, element, data) ->
        return @["_process_#{constraint.name}"]?(constraint, element, data) or false

    _on_dependency_change: (action, element, data, valid) ->
        if data.depends_on.length > 0 and data.dependency_action_targets?
            if @form_validator.dependency_change_action not instanceof Function
                FormValidator.dependency_change_actions[action]?.call(
                    FormValidator.dependency_change_actions
                    $_from_arr(data.dependency_action_targets)
                    valid
                    data.dependency_action_duration
                )
            else
                @form_validator.dependency_change_action(element, valid)
        return @

    modify: (grouped_errors, options) ->
        form_validator = @form_validator
        fields = form_validator.fields.all
        error_output_mode = form_validator.error_output_mode
        first_invalid_element = null

        for i in [0...fields.length]
            elem = fields.eq(i)
            data = form_validator._get_element_data(elem)
            grouped_error = null

            for err in grouped_errors when err.element.is(elem)
                grouped_error = err
                break

            # no grouped_error => elem is valid
            if not grouped_error?
                is_valid = true
                message = ""
            # grouped_error => elem is invalid
            else
                is_valid = false
                first_invalid_element ?= elem
                for error in grouped_error.errors
                    # set flag for dependency error classes
                    if error.phase is VALIDATION_PHASES.DEPENDENCIES
                        valid_dependencies = false
                    # call according function for processing invalid constraints (i.e. max_length + enforce_max_length)
                    else if error.phase is VALIDATION_PHASES.CONSTRAINTS
                        for constraint in data.constraints when constraint.name is error.type
                            data_has_changed = @_process_constraint(constraint, elem, data)
                            if data_has_changed
                                form_validator._set_element_data(elem, data)
                            break

                message = grouped_error.message

            if data.dependency_changed
                @_on_dependency_change(data.dependency_change_action, elem, data, data.valid_dependencies)

            if options.apply_error_classes is true
                @_apply_classes(
                    elem
                    data.error_targets
                    data.error_classes or form_validator.error_classes
                    is_valid
                )
                @_apply_classes(
                    elem
                    data.error_targets
                    data.success_classes or form_validator.success_classes
                    not is_valid
                )
                @_apply_classes(
                    elem
                    data.depends_on
                    data.dependency_error_classes or form_validator.dependency_error_classes
                    data.valid_dependencies
                )

            @_process_error_message(message, elem, data)

        if options.focus_invalid is true
            first_invalid_element?.focus()

        return @
