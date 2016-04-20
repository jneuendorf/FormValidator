include_general_behavior_tests = () ->
    describe "general behavior", () ->
        log "general behavior"

        describe "return value + side fx", () ->
            log "return value + side fx"

            beforeEach () ->
                html = $ FORM_HTML
                $(document.body).append html
                @values_by_name = values_by_name =
                    text: ""
                    en_number: "asdf"
                    de_number: "0bsdf9345"
                    optional_integer: ""
                    integer: "34,-"
                    phone: "asdf"
                    email: "asdfas@domain"
                    checkbox: ""
                    radio: ""

                for name, val of values_by_name
                    html.find("[name='#{name}']").val(val)

                form_validator = FormValidator.new(html.first(), {
                    field_getter: (form) ->
                        return form.find(".general [data-fv-validate]")
                    preprocessors: {
                        integer: (val, elem) ->
                            return val.replace(/\,\-/g, "")
                    }
                    postprocessors: {
                        integer: (val, elem) ->
                            return "#{val},-"
                    }
                    locale: "de"
                })
                errors = form_validator.validate()
                console.log(errors)

                @html = html
                @errors = errors

            afterEach () ->
                @html.remove()


            it "return value", () ->
                expect(@errors.length).toBe(10)

                data_for_invalid_elements = [
                    {required: true, type: "text", value: ""}
                    {required: true, type: "number", value: @values_by_name.en_number}
                    {required: true, type: "number", value: @values_by_name.de_number}
                    {required: false, type: "phone", value: @values_by_name.phone}
                    {required: true, type: "email", value: @values_by_name.email}
                    {required: true, type: "checkbox", value: ""}
                    {required: true, type: "checkbox", value: ""}
                    {required: true, type: "radio", value: ""}
                    {required: true, type: "radio", value: ""}
                    {required: true, type: "select", value: ""}
                ]

                for error, i in @errors
                    datum = data_for_invalid_elements[i]
                    expect(error.errors.length).toBe 1
                    error = error.errors[0]
                    expect(error.type).toBe datum.type
                    expect(error.required).toBe(datum.required)
                    expect(error.value).toBe datum.value

            it "side fx", () ->
                console.log @html
                expect(@html.find(".textlabel").hasClass("red-color class2")).toBe true
                expect(@html.find("[data-fv-name='numberlabel-en']").hasClass("red-color class2")).toBe true
                expect(@html.find("[data-fv-name='numberlabel-de']").hasClass("red-color class2")).toBe true

                expect(@html.find("[name='email']").hasClass("red-color class2")).toBe true
                expect(@html.find("[data-fv-name='error1']").hasClass("red-color bold")).toBe true
                expect($(".outsider").hasClass("red-color class2")).toBe true

                expect(@html.find("[name='checkbox']").hasClass("red-color class2")).toBe true

                expect(@html.find("select").hasClass("red-color class2")).toBe true
