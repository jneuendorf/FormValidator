# NOTE:50 the name gets converted to kebap case => max_length -> data-fv-max-length
constraint_validators =
    blacklist: (value, blacklist) ->
        for char in value when blacklist.indexOf(char) >= 0
            return false
        return true
    max: (value, max, options) ->
        if options?.include_max is "false"
            return value < max
        return value <= max
    max_length: (value, max_length) ->
        return value.length <= max_length
    min: (value, min, options) ->
        if options?.include_min is "false"
            return value > min
        return value >= min
    min_length: (value, min_length) ->
        return value.length >= min_length
    regex: (value, regex, options) ->
        return (new RegExp(regex, options.flags)).test(value)
    whitelist: (value, whitelist) ->
        for char in whitelist when value.indexOf(char) < 0
            return false
        return true

# define which constraint validators are logically connected (and thus can potentially be combined to a new error message i.e. max + min => ...is not between... (instead of ...is not greater than or not less than...))
# the groups must be disjoint (-> equivalence classes)
constraint_validator_groups = [
    # ["max", "min"]
    # ["max_length", "min_length"]
]

# define when to include a constraint validator option in the locale key (and when not - if not matching the below value)
# value can also be: function(String locale) -> Mixed value
# i.e. for include_max a function could be defined if different locales formulate the according error message differently:
# - EN could be like 'the value is not less than {{max}}' (max is not included in valid range => locale key = "constraint_max") and
# - DE could be like 'is not less than or equal to {{max}}' (max is included in valid range => locale key = "constraint_max_include_max")
# => in that case the function would look like:
# (locale) ->
#   if locale is "en"
#       return false
#   if locale is "de"
#       return true
#   # all other locales...
#   return something
constraint_validator_options_in_locale_key =
    include_max: true
    include_min: true
    enforce_max_length: true
    enforce_min_length: true

include_constraint_option_in_locale_key = (option, value, locale) ->
    if value?
        # REVIEW: consider if string matching does the job
        if constraint_validator_options_in_locale_key[option] not instanceof Function
            return "#{constraint_validator_options_in_locale_key[option]}" is "#{value}"
        return "#{constraint_validator_options_in_locale_key[option](locale)}" is "#{value}"
    return false
