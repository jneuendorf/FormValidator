# content validators.
# in all those function 'this' refers to the validators object so other validators are accessible from within any validator
# A validator is valid iff.:
# - it has a call() method,
# - it expects a string and a jquery object,
# - it returns
#   - for valid elements: TRUE
#   - for invalid elements:
#     - FALSE or String containing the error_message_type (those 2 are equivalent)
#     - an object
#       -> error_message_type: String (required)
#       -> properties needed for the according error message (-> parameters)
#       -> properties needed for other validators (as they will be able to access other validators' results)
validators =
    # "private" validator (used in other validators)
    _number: (str, elem, min, max, include_min = true, include_max = true) ->
        str = str.replace(/\s/g, "")
        if str[0] is "+"
            str = str.slice(1)
        # ".4"
        if str[0] is "."
            str = "0#{str}"
        # "-.4"
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

        # TODO: this doesnt work for inputs like 10e4 or 1e+5
        if isNaN(n) or not isFinite(n) or str isnt "#{n}"
            return {
                error_message_type: "number"
                _number: n
                _string: str
            }
        # # max
        # data_max = parseFloat(elem.attr("data-fv-max"))
        # if not isNaN(data_max)
        #     max = data_max
        #     data_include_max = elem.attr("data-fv-include-max")
        #     if data_include_max?
        #         include_max = (if data_include_max.toLowerCase() is "false" then false else true)
        # # min
        # data_min = parseFloat(elem.attr("data-fv-min"))
        # if not isNaN(data_min)
        #     min = data_min
        #     data_include_min = elem.attr("data-fv-include-min")
        #     if data_include_min?
        #         include_min = (if data_include_min.toLowerCase() is "false" then false else true)
        #
        # # max is always before min in message type in error_message_type
        # error_message_type = "number"
        # valid = true
        # # MAX
        # if max? and include_max and n > max
        #     error_message_type += "_max_included"
        #     valid = false
        # else if max? and not include_max and n >= max
        #     error_message_type += "_max"
        #     valid = false
        #
        # # MIN
        # if min? and include_min and n < min
        #     error_message_type += "_min_included"
        #     valid = false
        # else if min? and not include_min and n <= min
        #     error_message_type = "_min"
        #     valid = false
        #
        # if not valid
        #     res = {
        #         error_message_type: error_message_type
        #         _number: n
        #         _string: str
        #     }
        #     if max?
        #         res.max = max
        #     if min?
        #         res.min = min
        #     return res

        # valid
        return {
            valid: true
            _number: n
            _string: str
        }
    _text: (str, elem, min, max) ->
        return str.length > 0
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
        # TODO: check for trailing dot?
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
    phone: (str, elem) ->
        if str.length < 3
            return {
                error_message_type: "phone_length"
                length: 3
            }
        str = str.replace(/[\s+\+\-\/\(\)]/g, "")
        # remove leading zeros because parseInt will drop them
        while str[0] is "0"
            str = str.slice(1)
        if str isnt "#{parseInt(str, 10)}"
            return {
                error_message_type: "phone"
            }
        return true
    # TODO: add options for minlength, maxlength
    text: (str, elem, min, max) ->
        return str.length > 0
    # element validators: expect jquery object
    radio: (str, elem) ->
        return $("[name='" + elem.attr("name") + "']:checked").length > 0
    checkbox: (str, elem) ->
        return elem.prop("checked") is true
    select: (str, elem) ->
        return @text(elem.val())
