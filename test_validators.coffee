include_validator_tests = () ->
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
        #
        # it "positive integer", () ->
        #     log "positive integer"
        #     validator = (str, elem) ->
        #         res = validators.integer.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='0' />")
        #     # valid
        #     expect(validator("0", $elem)).toBe(true)
        #     expect(validator("1", $elem)).toBe(true)
        #     expect(validator("100", $elem)).toBe(true)
        #     expect(validator("+5", $elem)).toBe(true)
        #     expect(validator("+ 5", $elem)).toBe(true)
        #     expect(validator("+ 5 ", $elem)).toBe(true)
        #     expect(validator(" + 5 ", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("-5", $elem)).toEqual({
        #         error_message_type: 'integer_min_included'
        #         min: 0
        #     })
        #     expect(validator("- 5", $elem)).toEqual({
        #         error_message_type: 'integer_min_included'
        #         min: 0
        #     })
        #     expect(validator(" - 5", $elem)).toEqual({
        #         error_message_type: 'integer_min_included'
        #         min: 0
        #     })
        #     expect(validator("- 5 ", $elem)).toEqual({
        #         error_message_type: 'integer_min_included'
        #         min: 0
        #     })
        #     expect(validator("1e7", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #     expect(validator("Infinity", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #     expect(validator("1.25", $elem)).toEqual({
        #         error_message_type: 'integer_float'
        #     })
        #     expect(validator("0.1", $elem)).toEqual({
        #         error_message_type: 'integer_float'
        #     })
        #     expect(validator(" - 0.1", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #     expect(validator(" - 0.1 ", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #
        # it "negative integer", () ->
        #     log "negative integer"
        #     validator = (str, elem) ->
        #         res = validators.integer.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='integer' data-fv-max='0' data-fv-include-max='false' />")
        #     # valid
        #     expect(validator("-5", $elem)).toBe(true)
        #     expect(validator("- 5", $elem)).toBe(true)
        #     expect(validator(" - 5", $elem)).toBe(true)
        #     expect(validator("- 5 ", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("0", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #     })
        #     expect(validator("1", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #     })
        #     expect(validator("100", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #     })
        #     expect(validator("+5", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #     })
        #     expect(validator("+ 5", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #     })
        #     expect(validator("+ 5 ", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #     })
        #     expect(validator(" + 5 ", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #     })
        #     expect(validator("1e7", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #     expect(validator("-Infinity", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #     expect(validator("1.25", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #     expect(validator("0.1", $elem)).toEqual({
        #         error_message_type: 'integer'
        #     })
        #     expect(validator(" - 0.1", $elem)).toEqual({
        #         error_message_type: 'integer_float'
        #     })
        #     expect(validator(" - 0.1 ", $elem)).toEqual({
        #         error_message_type: 'integer_float'
        #     })
        #
        # it "positive integer with max", () ->
        #     log "positive integer with max"
        #     validator = (str, elem) ->
        #         res = validators.integer.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='0' data-fv-max='10' />")
        #     # valid
        #     expect(validator("0", $elem)).toBe(true)
        #     expect(validator("1", $elem)).toBe(true)
        #     expect(validator("2", $elem)).toBe(true)
        #     expect(validator("3", $elem)).toBe(true)
        #     expect(validator("4", $elem)).toBe(true)
        #     expect(validator("5", $elem)).toBe(true)
        #     expect(validator("6", $elem)).toBe(true)
        #     expect(validator("7", $elem)).toBe(true)
        #     expect(validator("8", $elem)).toBe(true)
        #     expect(validator("9", $elem)).toBe(true)
        #     expect(validator("10", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("-1", $elem)).toEqual({
        #         error_message_type: 'integer_min_included'
        #         max: 10
        #         min: 0
        #     })
        #     expect(validator("11", $elem)).toEqual({
        #         error_message_type: 'integer_max_included'
        #         max: 10
        #         min: 0
        #     })
        #
        # it "negative integer with min", () ->
        #     log "negative integer with min"
        #     validator = (str, elem) ->
        #         res = validators.integer.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='-10' data-fv-max='0' data-fv-include-max='false' />")
        #     # valid
        #     expect(validator("-1", $elem)).toBe(true)
        #     expect(validator("-2", $elem)).toBe(true)
        #     expect(validator("-3", $elem)).toBe(true)
        #     expect(validator("-4", $elem)).toBe(true)
        #     expect(validator("-5", $elem)).toBe(true)
        #     expect(validator("-6", $elem)).toBe(true)
        #     expect(validator("-7", $elem)).toBe(true)
        #     expect(validator("-8", $elem)).toBe(true)
        #     expect(validator("-9", $elem)).toBe(true)
        #     expect(validator("-10", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("-11", $elem)).toEqual({
        #         error_message_type: 'integer_min_included'
        #         max: 0
        #         min: -10
        #     })
        #     expect(validator("0", $elem)).toEqual({
        #         error_message_type: 'integer_max'
        #         max: 0
        #         min: -10
        #     })

        ############################################################################################################
        # NUMBER
        # TODO:60 add min and max tests
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


        # it "positive number", () ->
        #     log "positive number"
        #     validator = (str, elem) ->
        #         res = validators.number.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='number' data-fv-min='0' />")
        #     # valid
        #     expect(validator("0", $elem)).toBe(true)
        #     expect(validator("1", $elem)).toBe(true)
        #     expect(validator("100", $elem)).toBe(true)
        #     expect(validator("+5", $elem)).toBe(true)
        #     expect(validator("+ 5", $elem)).toBe(true)
        #     expect(validator("+ 5 ", $elem)).toBe(true)
        #     expect(validator(" + 5 ", $elem)).toBe(true)
        #     expect(validator("1.25", $elem)).toBe(true)
        #     expect(validator("0.1", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("-5", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         min: 0
        #     })
        #     expect(validator("- 5.2", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         min: 0
        #     })
        #     expect(validator(" - 5", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         min: 0
        #     })
        #     expect(validator("- 5 ", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         min: 0
        #     })
        #     expect(validator("1e7", $elem)).toEqual({
        #         error_message_type: 'number'
        #     })
        #     expect(validator(" - 0.1", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         min: 0
        #     })
        #     expect(validator(" - 0.1 ", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         min: 0
        #     })
        #
        # it "negative number", () ->
        #     log "negative number"
        #     validator = (str, elem) ->
        #         res = validators.number.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='number' data-fv-max='0' data-fv-include-max='false' />")
        #     # valid
        #     expect(validator("-5", $elem)).toBe(true)
        #     expect(validator("- 5.1", $elem)).toBe(true)
        #     expect(validator(" - 5", $elem)).toBe(true)
        #     expect(validator("- 5.3 ", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("0", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator("1", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator("100", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator("+5", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator("+ 5", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator("+ 5 ", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator(" + 5 ", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator("1e7", $elem)).toEqual({
        #         error_message_type: 'number'
        #     })
        #     expect(validator("-Infinity", $elem)).toEqual({
        #         error_message_type: 'number'
        #     })
        #     expect(validator("1.25", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #     expect(validator("0.1", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #     })
        #
        # it "positive number with max", () ->
        #     log "positive number with max"
        #     validator = (str, elem) ->
        #         res = validators.number.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='number' data-fv-min='0' data-fv-max='10.5' />")
        #     # valid
        #     expect(validator("0", $elem)).toBe(true)
        #     expect(validator("1.1", $elem)).toBe(true)
        #     expect(validator("2.2", $elem)).toBe(true)
        #     expect(validator("3.3", $elem)).toBe(true)
        #     expect(validator("4.4", $elem)).toBe(true)
        #     expect(validator("5.5", $elem)).toBe(true)
        #     expect(validator("6.6", $elem)).toBe(true)
        #     expect(validator("7.7", $elem)).toBe(true)
        #     expect(validator("8.8", $elem)).toBe(true)
        #     expect(validator("9.9", $elem)).toBe(true)
        #     expect(validator("10.10", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("-.1", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         max: 10.5
        #         min: 0
        #     })
        #     expect(validator("10.6", $elem)).toEqual({
        #         error_message_type: 'number_max_included'
        #         max: 10.5
        #         min: 0
        #     })
        #
        # it "negative number with min", () ->
        #     log "negative number with min"
        #     validator = (str, elem) ->
        #         res = validators.number.call(validators, str, elem)
        #         if res is true
        #             return true
        #         # remove helper items for easier testing
        #         for key, val of res when key[0] is "_"
        #             delete res[key]
        #         return res
        #     $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='-10.1' data-fv-max='0' data-fv-include-max='false' />")
        #     # valid
        #     expect(validator("-1.1", $elem)).toBe(true)
        #     expect(validator("-2.2", $elem)).toBe(true)
        #     expect(validator("-3.3", $elem)).toBe(true)
        #     expect(validator("-4.4", $elem)).toBe(true)
        #     expect(validator("-5.5", $elem)).toBe(true)
        #     expect(validator("-6.6", $elem)).toBe(true)
        #     expect(validator("-7.7", $elem)).toBe(true)
        #     expect(validator("-8.8", $elem)).toBe(true)
        #     expect(validator("-9.9", $elem)).toBe(true)
        #     expect(validator("-10.10", $elem)).toBe(true)
        #     # invalid
        #     expect(validator("-10.2", $elem)).toEqual({
        #         error_message_type: 'number_min_included'
        #         max: 0
        #         min: -10.1
        #     })
        #     expect(validator("0.01", $elem)).toEqual({
        #         error_message_type: 'number_max'
        #         max: 0
        #         min: -10.1
        #     })

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
