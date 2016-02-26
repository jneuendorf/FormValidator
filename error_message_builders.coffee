# TODO: structure this file for better maintainance
# override build_mode_helpers here if needed (same signature as a build_mode_helper). i.e. enumeration could be different in other languages
locale_build_mode_helpers =
    de: {}
    en: {}


# build-mode helpers (1 for each build mode): they define how parts of an error message are concatenated
build_mode_helpers = {}

build_mode_helpers[BUILD_MODES.ENUMERATE] = (parts, locale) ->
    if parts.length > 1
        return "#{parts.slice(0, -1).join(", ")} #{locales[locale]["and"]} #{parts.slice(-1)}"
    return parts[0]

build_mode_helpers[BUILD_MODES.SENTENCE] = (parts, locale) ->
    return parts.join(". ").trim()

build_mode_helpers[BUILD_MODES.LIST] = (parts, locale) ->
    return "<ul><li>#{parts.join("</li><li>")}</li></ul>"


# this function concatenates the prefix, mid part (== joined parts), and the suffix (used in the error message builders)
# key = locale key used to find pre- and suffix
default_message_builder = (key, build_mode, locale, parts, prefix, suffix, prefix_delimiter = " ", suffix_delimiter = " ") ->
    prefix = prefix or locales[locale]["#{key}_prefix"] or ""
    suffix = suffix or locales[locale]["#{key}_suffix"] or ""
    if parts instanceof Array
        message = locale_build_mode_helpers[locale][build_mode]?(parts, locale) or build_mode_helpers[build_mode](parts, locale)
    else #if typeof parts is "string"
        message = parts
    if prefix
        message = prefix + prefix_delimiter + message
    if suffix
        message += suffix_delimiter + suffix
    return message

# use this function to parse mustache-like strings or evaluate functions (used in the error message builders)
part_evaluator = (part, values) ->
    # string => mustache-like
    if typeof part is "string"
        for key, val of values when part.indexOf("{{#{key}}}") >= 0
            part = part.replace("{{#{key}}}", val)
        return part

    if part instanceof Function
        return part(values)

    return ""


# error-message builders (1 for each validation phase): they define how error messages are generated (generally) based on a set of errors
# param 'errors' = all error objects of a certain phase belonging to the same field
error_message_builders = {}

error_message_builders[VALIDATION_PHASES.DEPENDENCIES] = (errors, phase, build_mode, locale) ->
    names = (error.name for error in errors when error.name?)

    # if all errors have a name property (<=> all dependencies are named)
    if names.length is errors.length
        # sentence does not make sense in this case => fallback to enumerate
        if build_mode is BUILD_MODES.SENTENCE
            build_mode = BUILD_MODES.ENUMERATE
        parts = ("'#{name}'" for name in names)
        return default_message_builder(VALIDATION_PHASES_SINGULAR[phase].toLowerCase(), build_mode, locale, parts)
    return locales[locale]["#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_general"]

error_message_builders[VALIDATION_PHASES.VALUE] = (errors, phase, build_mode, locale) ->
    error = errors[0]
    type = error.type
    # here only 1 error is in the 'errors' list => therefore we just use the simplest build mode
    part = part_evaluator(locales[locale][type], error)
    return default_message_builder("#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_#{type}", BUILD_MODES.ENUMERATE, locale, [part])

error_message_builders[VALIDATION_PHASES.CONSTRAINTS] = (errors, phase, build_mode, locale) ->
    parts = []
    grouped_errors = []
    for group in constraint_validator_groups
        for error in errors
            idx = group.indexOf(error.type)
            if idx >= 0
                if grouped_errors[idx]?
                    grouped_errors[idx].push(error)
                else
                    grouped_errors[idx] = [error]


    # find combinable locale keys
    key_prefix = "#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_"
    for errors in grouped_errors
        keys = ("#{error.type}" for error in errors)
        key = get_combined_key(keys, locale, key_prefix)
        if key?
            parts.push locales[locale][key]
        else if DEBUG
            throw new Error("Could not find a translation for key while trying to create an error message during the constraint validation phase. Those keys were retrieved from the generated errors: #{JSON.stringify(keys)}. Define an according key in the 'locales' variable!")

    return default_message_builder(
        "#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_#{build_mode.toLowerCase()}"
        build_mode
        locale
        parts
    )



#####################################################################################################
# USED FOR CONSTRAINT ERROR MESSAGES

# mapping from group to locale key: Set -> String
# max_min == min_max
# ==> the order does not matter because its a set (and all permutations of the set map to the same value)

# intially use permutation to find the actually existing locale key for the given set
# upon a match cache the key. whenever the match becomes invalid (-> returns null) return to the initial state (so permutation is used)
# from http://stackoverflow.com/questions/9960908/permutations-in-javascript
_get_permutations = (input) ->
    permute = (arr, results, memo = []) ->
        for i in [0...arr.length]
            cur = arr.splice(i, 1)
            if arr.length is 0
                results.push memo.concat(cur)
            permute(arr.slice(), memo.concat(cur))
            arr.splice(i, 0, cur[0])

    results = []
    permute(input, results)
    return results


# TODO: test caching
permutation_cache = {}

get_combined_key = (keys, locale, key_prefix = "", key_suffix = "") ->
    # clone keys
    keys = keys.slice(0)
    # sort because cached keys had been sorted and the convention is that locales are sorted lists of constraints (joined with '_')
    keys.sort()

    while keys.length > 0
        # check the cache for an entry
        key = key_prefix + keys.join("_") + key_suffix
        if permutation_cache[key]?
            return key
        # no cache hit => try all permutations
        for permutation in _get_permutations(keys)
            key = key_prefix + permutation.join("_") + key_suffix
            if locales[locale][key]?
                permutation_cache[key] = true
                return key
        keys.pop()

    return null
