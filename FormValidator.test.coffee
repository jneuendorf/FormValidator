FORM_HTML = """
<form action="" method="get" data-fv-error-classes="red-color class2">

    <span class="textlabel">text:</span>
    <input type="text" name="text" value="" data-fv-validate="text" data-fv-error-targets=".textlabel" /><br />

    <span data-fv-name="numberlabel-en">english format number:</span>
    <input type="text" name="en_number" value="" data-fv-validate="number" data-fv-preprocess="false" data-fv-postprocess="false" data-fv-error-targets="numberlabel-en" /><br />

    <span data-fv-name="numberlabel-de">german format number:</span>
    <input type="text" name="de_number" value="" data-fv-validate="number" data-fv-error-targets="numberlabel-de" /><br />

    <span data-fv-name="integerlabel">optional integer:</span>
    <input type="text" name="optional_integer" value="" data-fv-validate="integer" data-fv-optional="true" data-fv-error-targets="self" /><br />

    <span data-fv-name="integerlabel">integer:</span>
    <input type="text" name="integer" value="" data-fv-validate="integer" /><br />

    <span data-fv-name="phonelabel">optional phone:</span>
    <input type="text" name="phone" value="" data-fv-validate="phone" data-fv-optional="true" /><br />

    <span data-fv-name="emaillabel">email:</span>
    <input type="text" name="email" value="" data-fv-validate="email" data-fv-error-targets="self error1 .outsider" /><br />

    <span data-fv-name="checkboxlabel">checkbox:</span>
    <input type="checkbox" name="checkbox" value="v1" data-fv-validate="checkbox" data-fv-error-targets="self checkboxlabel" />
    <input type="checkbox" name="checkbox" value="v2" data-fv-validate="checkbox" />
    <br />

    <span data-fv-name="radiolabel">radio button:</span>
    <input type="radio" name="radio" value="v1" data-fv-validate="radio" />
    <input type="radio" name="radio" value="v2" data-fv-validate="radio" />
    <br />

    <select data-fv-validate="select" data-fv-error-targets="self">
        <option value="">Bitte wählen</option>
        <option value="mr">Herr</option>
        <option value="mrs">Frau</option>
    </select>
    <br />
    <hr />
    <div data-fv-name="error1" data-fv-error-classes="red-color bold">
        text in some div (INSIDE THE FORM TAG, USING data-fv-name) that should become red and bold for any form field with 'error1' as error target
    </div>
</form>

<div class="outsider">
    text in some div (OUTSIDE THE FORM TAG, USING class) that should become red and bold for any form field with '.outsider' as error target
</div>
"""

describe "Reusables", () ->


    describe "FormValidator", () ->
        log = (name) ->
            str = "***********************************************************************"

            if name?
                padStr = "*****"
                rem = (str.length - name.length - 2) / 2
                s = padStr
                for i in [padStr.length..Math.floor(rem)]
                    s += " "
                s += name
                for i in [padStr.length..Math.ceil(rem)]
                    s += " "
                s += padStr
                console.log s

            console.log str
            return true

        beforeEach () ->
            log()



        describe "validators", () ->
            log "validators"
            validators = FormValidator.validators
            # for type, validator of validators

            it "email", () ->
                log "email"
                validator = validators.email
                # valid
                expect(validator("some@valid-email.com")).toBe(true)
                # invalid
                expect(validator("so@me@invalid-email_no_dot_com")).toEqual({
                    error_message_type: "email_many_at"
                })
                expect(validator("so@me@valid-email.com")).toEqual({
                    error_message_type: "email_many_at"
                })
                expect(validator("some_invalid-email.com")).toEqual({
                    error_message_type: "email_at"
                })
                expect(validator("totally wrong!")).toEqual({
                    error_message_type: "email_at"
                })

            it "integer", () ->
                log "integer"
                validator = (str, elem) ->
                    validators.integer.call(validators, str, elem)
                $elem = $("<input type='text' data-fv-validate='integer' />")
                # valid
                expect(validator("0", $elem)).toBe(true)
                expect(validator("1", $elem)).toBe(true)
                expect(validator("100", $elem)).toBe(true)
                expect(validator("+5", $elem)).toBe(true)
                expect(validator("+ 5", $elem)).toBe(true)
                expect(validator("+ 5 ", $elem)).toBe(true)
                expect(validator(" + 5 ", $elem)).toBe(true)
                expect(validator("-5", $elem)).toBe(true)
                expect(validator("- 5", $elem)).toBe(true)
                expect(validator(" - 5", $elem)).toBe(true)
                expect(validator("- 5 ", $elem)).toBe(true)
                # invalid
                expect(validator("1e7", $elem)).toEqual({
                    error_message_type: "integer"
                })
                expect(validator("Infinity", $elem)).toEqual({
                    error_message_type: "integer"
                })
                expect(validator("1.25", $elem)).toEqual({
                    error_message_type: "integer_float"
                })
                expect(validator("0.1", $elem)).toEqual({
                    error_message_type: "integer_float"
                })
                expect(validator(" - 0.1", $elem)).toEqual({
                    error_message_type: "integer_float"
                })
                expect(validator(" - 0.1 ", $elem)).toEqual({
                    error_message_type: "integer_float"
                })
                expect(validator("0.1a2", $elem)).toEqual({
                    error_message_type: "integer"
                })
                expect(validator("asdf", $elem)).toEqual({
                    error_message_type: "integer"
                })

            it "positive integer", () ->
                log "positive integer"
                validator = (str, elem) ->
                    res = validators.integer.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='0' />")
                # valid
                expect(validator("0", $elem)).toBe(true)
                expect(validator("1", $elem)).toBe(true)
                expect(validator("100", $elem)).toBe(true)
                expect(validator("+5", $elem)).toBe(true)
                expect(validator("+ 5", $elem)).toBe(true)
                expect(validator("+ 5 ", $elem)).toBe(true)
                expect(validator(" + 5 ", $elem)).toBe(true)
                # invalid
                expect(validator("-5", $elem)).toEqual({
                    error_message_type: 'integer_min_included'
                    min: 0
                })
                expect(validator("- 5", $elem)).toEqual({
                    error_message_type: 'integer_min_included'
                    min: 0
                })
                expect(validator(" - 5", $elem)).toEqual({
                    error_message_type: 'integer_min_included'
                    min: 0
                })
                expect(validator("- 5 ", $elem)).toEqual({
                    error_message_type: 'integer_min_included'
                    min: 0
                })
                expect(validator("1e7", $elem)).toEqual({
                    error_message_type: 'integer'
                })
                expect(validator("Infinity", $elem)).toEqual({
                    error_message_type: 'integer'
                })
                expect(validator("1.25", $elem)).toEqual({
                    error_message_type: 'integer_float'
                })
                expect(validator("0.1", $elem)).toEqual({
                    error_message_type: 'integer_float'
                })
                expect(validator(" - 0.1", $elem)).toEqual({
                    error_message_type: 'integer'
                })
                expect(validator(" - 0.1 ", $elem)).toEqual({
                    error_message_type: 'integer'
                })

            it "negative integer", () ->
                log "negative integer"
                validator = (str, elem) ->
                    res = validators.integer.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='integer' data-fv-max='0' data-fv-include-max='false' />")
                # valid
                expect(validator("-5", $elem)).toBe(true)
                expect(validator("- 5", $elem)).toBe(true)
                expect(validator(" - 5", $elem)).toBe(true)
                expect(validator("- 5 ", $elem)).toBe(true)
                # invalid
                expect(validator("0", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                })
                expect(validator("1", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                })
                expect(validator("100", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                })
                expect(validator("+5", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                })
                expect(validator("+ 5", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                })
                expect(validator("+ 5 ", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                })
                expect(validator(" + 5 ", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                })
                expect(validator("1e7", $elem)).toEqual({
                    error_message_type: 'integer'
                })
                expect(validator("-Infinity", $elem)).toEqual({
                    error_message_type: 'integer'
                })
                expect(validator("1.25", $elem)).toEqual({
                    error_message_type: 'integer'
                })
                expect(validator("0.1", $elem)).toEqual({
                    error_message_type: 'integer'
                })
                expect(validator(" - 0.1", $elem)).toEqual({
                    error_message_type: 'integer_float'
                })
                expect(validator(" - 0.1 ", $elem)).toEqual({
                    error_message_type: 'integer_float'
                })

            it "positive integer with max", () ->
                log "positive integer with max"
                validator = (str, elem) ->
                    res = validators.integer.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='0' data-fv-max='10' />")
                # valid
                expect(validator("0", $elem)).toBe(true)
                expect(validator("1", $elem)).toBe(true)
                expect(validator("2", $elem)).toBe(true)
                expect(validator("3", $elem)).toBe(true)
                expect(validator("4", $elem)).toBe(true)
                expect(validator("5", $elem)).toBe(true)
                expect(validator("6", $elem)).toBe(true)
                expect(validator("7", $elem)).toBe(true)
                expect(validator("8", $elem)).toBe(true)
                expect(validator("9", $elem)).toBe(true)
                expect(validator("10", $elem)).toBe(true)
                # invalid
                expect(validator("-1", $elem)).toEqual({
                    error_message_type: 'integer_min_included'
                    max: 10
                    min: 0
                })
                expect(validator("11", $elem)).toEqual({
                    error_message_type: 'integer_max_included'
                    max: 10
                    min: 0
                })

            it "negative integer with min", () ->
                log "negative integer with min"
                validator = (str, elem) ->
                    res = validators.integer.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='-10' data-fv-max='0' data-fv-include-max='false' />")
                # valid
                expect(validator("-1", $elem)).toBe(true)
                expect(validator("-2", $elem)).toBe(true)
                expect(validator("-3", $elem)).toBe(true)
                expect(validator("-4", $elem)).toBe(true)
                expect(validator("-5", $elem)).toBe(true)
                expect(validator("-6", $elem)).toBe(true)
                expect(validator("-7", $elem)).toBe(true)
                expect(validator("-8", $elem)).toBe(true)
                expect(validator("-9", $elem)).toBe(true)
                expect(validator("-10", $elem)).toBe(true)
                # invalid
                expect(validator("-11", $elem)).toEqual({
                    error_message_type: 'integer_min_included'
                    max: 0
                    min: -10
                })
                expect(validator("0", $elem)).toEqual({
                    error_message_type: 'integer_max'
                    max: 0
                    min: -10
                })

            ############################################################################################################
            # NUMBER
            # TODO: add min and max tests
            it "number", () ->
                log "number"
                validator = (str, elem) ->
                    res = validators.number.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='number' />")
                # valid
                expect(validator("0", $elem)).toBe(true)
                expect(validator("0.00", $elem)).toBe(true)
                expect(validator("1", $elem)).toBe(true)
                expect(validator("100", $elem)).toBe(true)
                expect(validator("+5", $elem)).toBe(true)
                expect(validator("+ 5", $elem)).toBe(true)
                expect(validator("+ 5 ", $elem)).toBe(true)
                expect(validator(" + 5 ", $elem)).toBe(true)
                expect(validator("-5", $elem)).toBe(true)
                expect(validator("- 5", $elem)).toBe(true)
                expect(validator(" - 5", $elem)).toBe(true)
                expect(validator("- 5 ", $elem)).toBe(true)
                expect(validator("-.4", $elem)).toBe(true)
                expect(validator("1.25", $elem)).toBe(true)
                expect(validator("0.1", $elem)).toBe(true)
                expect(validator(" - 0.1", $elem)).toBe(true)
                expect(validator(" - 0.1 ", $elem)).toBe(true)
                # invalid
                expect(validator("1e7", $elem)).toEqual({
                    error_message_type: "number"
                })
                expect(validator("Infinity", $elem)).toEqual({
                    error_message_type: "number"
                })
                expect(validator("-Infinity", $elem)).toEqual({
                    error_message_type: "number"
                })
                expect(validator("0.1a2", $elem)).toEqual({
                    error_message_type: "number"
                })
                expect(validator("asdf", $elem)).toEqual({
                    error_message_type: "number"
                })


            it "positive number", () ->
                log "positive number"
                validator = (str, elem) ->
                    res = validators.number.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='number' data-fv-min='0' />")
                # valid
                expect(validator("0", $elem)).toBe(true)
                expect(validator("1", $elem)).toBe(true)
                expect(validator("100", $elem)).toBe(true)
                expect(validator("+5", $elem)).toBe(true)
                expect(validator("+ 5", $elem)).toBe(true)
                expect(validator("+ 5 ", $elem)).toBe(true)
                expect(validator(" + 5 ", $elem)).toBe(true)
                expect(validator("1.25", $elem)).toBe(true)
                expect(validator("0.1", $elem)).toBe(true)
                # invalid
                expect(validator("-5", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    min: 0
                })
                expect(validator("- 5.2", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    min: 0
                })
                expect(validator(" - 5", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    min: 0
                })
                expect(validator("- 5 ", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    min: 0
                })
                expect(validator("1e7", $elem)).toEqual({
                    error_message_type: 'number'
                })
                expect(validator(" - 0.1", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    min: 0
                })
                expect(validator(" - 0.1 ", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    min: 0
                })

            it "negative number", () ->
                log "negative number"
                validator = (str, elem) ->
                    res = validators.number.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='number' data-fv-max='0' data-fv-include-max='false' />")
                # valid
                expect(validator("-5", $elem)).toBe(true)
                expect(validator("- 5.1", $elem)).toBe(true)
                expect(validator(" - 5", $elem)).toBe(true)
                expect(validator("- 5.3 ", $elem)).toBe(true)
                # invalid
                expect(validator("0", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator("1", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator("100", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator("+5", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator("+ 5", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator("+ 5 ", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator(" + 5 ", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator("1e7", $elem)).toEqual({
                    error_message_type: 'number'
                })
                expect(validator("-Infinity", $elem)).toEqual({
                    error_message_type: 'number'
                })
                expect(validator("1.25", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })
                expect(validator("0.1", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                })

            it "positive number with max", () ->
                log "positive number with max"
                validator = (str, elem) ->
                    res = validators.number.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='number' data-fv-min='0' data-fv-max='10.5' />")
                # valid
                expect(validator("0", $elem)).toBe(true)
                expect(validator("1.1", $elem)).toBe(true)
                expect(validator("2.2", $elem)).toBe(true)
                expect(validator("3.3", $elem)).toBe(true)
                expect(validator("4.4", $elem)).toBe(true)
                expect(validator("5.5", $elem)).toBe(true)
                expect(validator("6.6", $elem)).toBe(true)
                expect(validator("7.7", $elem)).toBe(true)
                expect(validator("8.8", $elem)).toBe(true)
                expect(validator("9.9", $elem)).toBe(true)
                expect(validator("10.10", $elem)).toBe(true)
                # invalid
                expect(validator("-.1", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    max: 10.5
                    min: 0
                })
                expect(validator("10.6", $elem)).toEqual({
                    error_message_type: 'number_max_included'
                    max: 10.5
                    min: 0
                })

            it "negative number with min", () ->
                log "negative number with min"
                validator = (str, elem) ->
                    res = validators.number.call(validators, str, elem)
                    if res is true
                        return true
                    # remove helper items for easier testing
                    for key, val of res when key[0] is "_"
                        delete res[key]
                    return res
                $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='-10.1' data-fv-max='0' data-fv-include-max='false' />")
                # valid
                expect(validator("-1.1", $elem)).toBe(true)
                expect(validator("-2.2", $elem)).toBe(true)
                expect(validator("-3.3", $elem)).toBe(true)
                expect(validator("-4.4", $elem)).toBe(true)
                expect(validator("-5.5", $elem)).toBe(true)
                expect(validator("-6.6", $elem)).toBe(true)
                expect(validator("-7.7", $elem)).toBe(true)
                expect(validator("-8.8", $elem)).toBe(true)
                expect(validator("-9.9", $elem)).toBe(true)
                expect(validator("-10.10", $elem)).toBe(true)
                # invalid
                expect(validator("-10.2", $elem)).toEqual({
                    error_message_type: 'number_min_included'
                    max: 0
                    min: -10.1
                })
                expect(validator("0.01", $elem)).toEqual({
                    error_message_type: 'number_max'
                    max: 0
                    min: -10.1
                })

            it "phone", () ->
                log "phone"
                validator = (str) ->
                    validators.phone.call(validators, str)
                # valid
                expect(validator("030/1234-67")).toBe(true)
                expect(validator("(+49) 30/1234-678")).toBe(true)

                # invalid
                expect(validator("03")).toEqual({
                    error_message_type: "phone_length"
                    length: 3
                })
                expect(validator("030 / asfd")).toEqual({
                    error_message_type: "phone"
                })
                expect(validator("(+1) 603-USA")).toEqual({
                    error_message_type: "phone"
                })

            it "text", () ->
                log "text"
                validator = (str) ->
                    validators.text.call(validators, str)
                # valid
                expect(validator("f***ing anything is valid!")).toBe(true)
                expect(validator("even")).toBe(true)
                expect(validator("null")).toBe(true)
                expect(validator("or")).toBe(true)
                expect(validator("undefined")).toBe(true)

                # invalid
                expect(validator("")).toBe(false)

            it "radio", () ->
                log "radio"
                validator = (str, elem) ->
                    validators.radio.call(validators, str, elem)

                valid_buttons = $ """
                            <input type="radio" name="my_name" value="value1" />
                            <input type="radio" name="my_name" value="value2"  />
                            <input type="radio" name="my_name" value="value3" checked />
                            <input type="radio" name="my_name" value="value4" />
                            <input type="radio" name="my_name" value="value5" />
                            """

                invalid_buttons = $ """
                            <input type="radio" name="my_name2" value="value1" />
                            <input type="radio" name="my_name2" value="value2" />
                            <input type="radio" name="my_name2" value="value3" />
                            <input type="radio" name="my_name2" value="value4" />
                            <input type="radio" name="my_name2" value="value5" />
                            """

                $(document.body)
                    .append(valid_buttons)
                    .append(invalid_buttons)

                # valid
                expect(validator(null, valid_buttons.first())).toBe(true)
                expect(validator("any string...totally not interesting", valid_buttons.first())).toBe(true)

                # invalid
                expect(validator("", invalid_buttons.first())).toBe(false)

                valid_buttons.remove()
                invalid_buttons.remove()

            it "checkbox", () ->
                log "checkbox"
                validator = (str, elem) ->
                    validators.checkbox.call(validators, str, elem)

                valid_buttons = $ """
                            <input type="checkbox" name="my_name" value="value1" checked />
                            """

                invalid_buttons = $ """
                            <input type="checkbox" name="my_name2" value="value1" />
                            """

                $(document.body)
                    .append(valid_buttons)
                    .append(invalid_buttons)

                # valid
                expect(validator(null, valid_buttons)).toBe(true)
                expect(validator("any string...totally not interesting", valid_buttons)).toBe(true)

                # invalid
                expect(validator("", invalid_buttons)).toBe(false)

                valid_buttons.remove()
                invalid_buttons.remove()

            it "select", () ->
                log "select"
                validator = (str, elem) ->
                    validators.select.call(validators, str, elem)

                valid_buttons = $ """
                            <select name="my_name">
                                <option value="value1">val1<option>
                                <option value="value2" selected>val2<option>
                                <option value="value3">val3<option>
                            </select>
                            """

                valid_buttons2 = $ """
                            <select name="my_name">
                                <option value="value1">val1<option>
                                <option value="value2" selected>val2<option>
                                <option value="value3">val3<option>
                            </select>
                            """

                invalid_buttons = $ """
                            <select name="my_name2">
                                <option value="">- please select an option -<option>
                                <option value="value2">val2<option>
                                <option value="value3">val3<option>
                            </select>
                            """

                $(document.body)
                    .append(valid_buttons)
                    .append(valid_buttons2)
                    .append(invalid_buttons)

                # valid
                expect(validator(null, valid_buttons)).toBe(true)
                expect(validator("any string...totally not interesting", valid_buttons)).toBe(true)
                expect(validator(null, valid_buttons2)).toBe(true)

                # invalid
                expect(validator("", invalid_buttons)).toBe(false)

                valid_buttons.remove()
                valid_buttons2.remove()
                invalid_buttons.remove()


        #####################################################################################################################
        #####################################################################################################################
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


            describe "dependencies among fields", () ->
                # TODO

        describe "progress", () ->
            # TODO
