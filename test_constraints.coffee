include_constraint_tests = () ->
    describe "constraints", () ->
        log "constraints"

        beforeEach () ->
            html = $ FORM_HTML
            $(document.body).append html

            form_validator = FormValidator.new(html.first(), {
                locale: "de"
                field_getter: (form) ->
                    return form.find(".constraints input")
            })
            errors = form_validator.validate()
            console.log(errors)

            @html = html
            @errors = errors

        afterEach () ->
            @html.remove()


        it "error messages", () ->
            expect(@errors.length).toBe(2)

            message = FormValidator.locales.de.constraint_enumerate_prefix + " " + FormValidator.locales.de.constraint_max
            message = message
                .replace("{{value}}", @errors[0].element.val())
                .replace("{{max}}", @errors[0].element.attr("data-fv-max"))
            expect(@errors[0].message).toBe(message)

            message = FormValidator.locales.de.constraint_enumerate_prefix + " " + FormValidator.locales.de.constraint_blacklist + " #{FormValidator.locales.de.and} " + FormValidator.locales.de.constraint_regex
            message = message
                .replace("{{value}}", @errors[1].element.val())
                .replace("{{blacklist}}", @errors[1].element.attr("data-fv-blacklist"))
                .replace("{{regex}}", @errors[1].element.attr("data-fv-regex"))
            expect(@errors[1].message).toBe(message)
