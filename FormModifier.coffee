# This class takes the errors to a FormValidator instance and modifies the form according to these errors.
class FormModifier

    # CONSTRUCTOR
    constructor: (form_validator, options) ->
        @form_validator = form_validator
        if ERROR_OUTPUT_MODES[options.error_output_mode]? or options.error_output_mode instanceof Function
            @error_output_mode = options.error_output_mode
        else
            @error_output_mode = ERROR_OUTPUT_MODES.DEFAULT

    # class_kind is either "error_classes" or "dependency_error_classes"
    _apply_classes: (element, error_targets, classes, is_valid) ->
        if error_targets?
            targets = @form_validator._find_targets(error_targets, element)
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
                    return false
                .blur () ->
                    element.popover("hide")
                    return true
                .click () ->
                    if document.activeElement is @
                        element.popover("toggle")
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

    modify: (grouped_errors, options) ->
        form_validator = @form_validator
        fields = form_validator.fields.all
        error_output_mode = form_validator.error_output_mode

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
                valid_dependencies = true
                message = ""
            # grouped_error => elem is invalid
            else
                is_valid = false
                valid_dependencies = true
                for error in grouped_error.errors when error.phase is VALIDATION_PHASES.DEPENDENCIES
                    valid_dependencies = false
                    break
                message = grouped_error.message

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
                    valid_dependencies
                )

            @_process_error_message(message, elem, data)

        return @
