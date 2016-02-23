# NOTE: the name gets converted to kebap case => max_length -> data-fv-max-length
constraint_validators =
    blacklist: (value, blacklist) ->
        for char in value when blacklist.indexOf(char) >= 0
            return false
        return true
    max: (value, max, options) ->
        if options.include_max is "false"
            return value < max
        return value <= max
    max_length: (value, max_length) ->
        return value.length <= max_length
    min: (value, min, options) ->
        if options.include_min is "false"
            return value > min
        return value >= min
    min_length: (value, min_length) ->
        return value.length >= min_length
    regex: (value, regex, options) ->
        return (new RegExp(regex, options.flags)).test(value)
    whitelist: (value, whitelist) ->
        for char in value when blacklist.indexOf(char) < 0
            return false
        return true


# define which constraint-validator options are compatible with a constraint validator
# they are accessible in the according constraint validator in the options object
# used in _validate_constraints()
# => constraint validator options:
#    - data-fv-include-max
#    - data-fv-include-min
#    - data-fv-regex-flags
constraint_validator_options =
    max: [
        "include_max"
    ]
    mix: [
        "include_mix"
    ]
    regex: [
        "regex_flags"
    ]
