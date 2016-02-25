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

                # remove jquery elements and validators for easier checking
                for error in @errors
                    delete error.element
                    delete error.validator

                # TODO: replace hard coded messages with FormValidator.error_messages
                expect(@errors).toEqual [
                    {
                        # "message": "Bitte füllen Sie das 1. Textfeld aus",
                        "message": FormValidator.error_messages.de.text({index_of_type: 1}),
                        "required": true,
                        "type": "text",
                        "value": ""
                    }, {
                        "message": FormValidator.error_messages.de.number.replace("{{value}}", @values_by_name.en_number),
                        "required": true,
                        "type": "number",
                        "value": @values_by_name.en_number
                    }, {
                        "message": FormValidator.error_messages.de.number.replace("{{value}}", @values_by_name.de_number),
                        "required": true,
                        "type": "number",
                        "value": @values_by_name.de_number
                    }, {
                        "message": FormValidator.error_messages.de.phone.replace("{{value}}", @values_by_name.phone),
                        "required": false,
                        "type": "phone",
                        "value": @values_by_name.phone
                    }, {
                        "message": FormValidator.error_messages.de.email_dot.replace("{{value}}", @values_by_name.email),
                        "required": true,
                        "type": "email",
                        "value": @values_by_name.email
                    }, {
                        # "message": "Die 1. Checkbox wurde nicht ausgewählt",
                        "message": FormValidator.error_messages.de.checkbox.replace("{{index_of_type}}", 1),
                        "required": true,
                        "type": "checkbox",
                        "value": ""
                    }, {
                        "message": FormValidator.error_messages.de.checkbox.replace("{{index_of_type}}", 2),
                        "required": true,
                        "type": "checkbox",
                        "value": ""
                    }, {
                        # "message": "Die 1. Auswahlbox wurde nicht ausgewählt",
                        "message": FormValidator.error_messages.de.radio.replace("{{index_of_type}}", 1),
                        "required": true,
                        "type": "radio",
                        "value": ""
                    }, {
                        "message": FormValidator.error_messages.de.radio.replace("{{index_of_type}}", 2),
                        "required": true,
                        "type": "radio",
                        "value": ""
                    }, {
                        "message": FormValidator.error_messages.de.select.replace("{{index_of_type}}", 1),
                        "required": true,
                        "type": "select",
                        "value": ""
                    }
                ]

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
