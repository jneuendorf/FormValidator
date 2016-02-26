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


        it "return value", () ->
            expect(@errors.length).toBe(10)
