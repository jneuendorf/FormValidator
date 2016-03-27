$(document).ready () ->
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
                    try
                        options = window[options]()
                    catch error
                        options = {}

            form_validator = FormValidator.new(container, options)
            container.data("_form_validator", form_validator)
        form_validator.validate()
        return false

    # enable real-time validation
    $(document).on "change keyup", "[data-fv-real-time] [data-fv-validate]", (evt) ->
        $elem = $(@)
        # prevent change event for textfields (keyup will trigger validation instead)
        type = $elem.attr("type")?.toLowerCase() or ""
        is_textfield = $elem.filter("textarea").length is 1 or $elem.filter("input").length and type in [
            "button", "checkbox", "color", "file", "image", "radio", "range", "submit"
        ]
        if evt.type is "change" and is_textfield
            return true

        container = $elem.closest("[data-fv-real-time]")
        if container.length is 1
            if not (form_validator = container.data("_form_validator"))?
                form_validator = FormValidator.new(container)
                container.data("_form_validator", form_validator)
            if DEBUG
                console.log form_validator.validate({focus_invalid: false})
            else
                form_validator.validate({focus_invalid: false})
        return false


    return true
