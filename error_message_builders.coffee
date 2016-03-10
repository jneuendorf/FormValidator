# TODO: structure this file for better maintainance
# override build_mode_helpers here if needed (same signature as a build_mode_helper). i.e. enumeration could be different in other languages
locale_build_mode_helpers =
    de: {}
    en: {}


# build-mode helpers (1 for each build mode): they define how parts of an error message are concatenated
build_mode_helpers = {}

build_mode_helpers[BUILD_MODES.ENUMERATE] = (parts, locale, phase, build_mode) ->
    if parts.length > 1
        # no key info passed => just join the messages
        if not parts[0].key?
            return "#{(part.message for part in parts.slice(0, -1)).join(", ")} #{locales["and"]} #{parts.slice(-1).message}".trim()

        lang_data = locales[locale]
        default_prefix = lang_data["#{phase}_#{build_mode}_prefix".toLowerCase()] or ""
        parts_grouped_by_prefix = group_arr_by parts, (part) ->
            return lang_data["#{part.key}_prefix"] or default_prefix
        # parts_grouped_by_prefix = {}
        # for part in parts
        #     prefix = lang_data["#{part.key}_prefix"] or default_prefix
        #     if parts_grouped_by_prefix[prefix]?
        #         parts_grouped_by_prefix[prefix].push part
        #     else
        #         parts_grouped_by_prefix[prefix] = [part]

        # adjust parts' prefixes (only the first of each group may keep its prefix)
        new_parts = []
        for prefix, parts of parts_grouped_by_prefix
            parts = [parts[0]].concat(part.slice(prefix.length) for part, i in parts when i > 0)
            # parts = (part.slice(prefix.length) for part in parts)
            # parts[0] = prefix + parts[0]
            new_parts = new_parts.concat parts
        parts = new_parts

        return "#{(part.message for part in parts.slice(0, -1)).join(", ")} #{lang_data["and"]} #{parts.slice(-1).message}".trim()
    return parts[0].message

build_mode_helpers[BUILD_MODES.SENTENCE] = (parts, locale, build_mode) ->
    return ("#{part.message[0].toUpperCase()}#{part.message.slice(1)}" for part in parts).join(". ").trim()

build_mode_helpers[BUILD_MODES.LIST] = (parts, locale, build_mode) ->
    return "<ul><li>#{parts.join("</li><li>")}</li></ul>"


# this function concatenates the prefix, mid part (== joined parts), and the suffix (used in the error message builders)
# key = locale key used to find pre- and suffix
# prefix, suffix = either a (ready) string (which won't be modified) or a function that generates the prefix or suffix respectively
#   signature: (String locale_key, String locale, ) -> String
default_message_builder = (key, phase, build_mode, locale, parts, prefix, suffix, prefix_delimiter = " ", suffix_delimiter = " ") ->
    prefix = prefix or locales[locale]["#{key}_prefix"] or ""
    suffix = suffix or locales[locale]["#{key}_suffix"] or ""
    if parts instanceof Array
        message = locale_build_mode_helpers[locale][build_mode]?(parts, locale, phase, build_mode) or build_mode_helpers[build_mode](parts, locale, phase, build_mode)
    else #if typeof parts is "string"
        message = parts

    if prefix
        if prefix instanceof Function
            prefix = prefix()
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
        parts = ({message: "'#{name}'", key: null} for name in names)
        return default_message_builder(VALIDATION_PHASES_SINGULAR[phase].toLowerCase(), phase, build_mode, locale, parts)
    return locales[locale]["#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_general"]


error_message_builders[VALIDATION_PHASES.VALUE] = (errors, phase, build_mode, locale) ->
    # NOTE: each error in errors (exactly 1 because of the phase) contains an error_message_type. that type is prefered over the normal type
    error = errors[0]
    key = "#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_#{error.error_message_type or error.type}"
    # here only 1 error is in the 'errors' list => therefore we just use the simplest build mode
    part =
        message: part_evaluator(locales[locale][key], error)
        key: null
    return default_message_builder(key, phase, BUILD_MODES.ENUMERATE, locale, [part])


error_message_builders[VALIDATION_PHASES.CONSTRAINTS] = (errors, phase, build_mode, locale) ->
    parts = []
    # group by error.type as defined in constraint_validator_groups (if an error is in no group it implicitely creates an own group)
    grouped_errors = []
    ungrouped_errors = []
    for error in errors
        error_in_group = false
        # TODO: make constraint_validator_groups accessible from class and use this ref here
        for group, i in constraint_validator_groups
            if error.type in group
                error_in_group = true
                if grouped_errors[i]?
                    grouped_errors[i].push(error)
                else
                    grouped_errors[i] = [error]

        if not error_in_group
            ungrouped_errors.push error

    for error in ungrouped_errors
        grouped_errors.push [error]

    phase_singular = VALIDATION_PHASES_SINGULAR[phase].toLowerCase()

    # find combinable locale keys (errors with the same type may use a special locale key)
    key_prefix = "#{phase_singular}_"
    # go through groups of errors (and skip empty entries caused in the above loop)
    for errors in grouped_errors when errors?
        keys = []
        for error in errors
            keys.push error.type
            if error.options?
                for option, val of error.options when include_constraint_option_in_locale_key(option, val)
                    keys.push option

        key = get_combined_key(keys, locale, key_prefix)
        if key?
            parts.push {
                message: part_evaluator(locales[locale][key], error)
                key: key
            }
        else if DEBUG
            throw new Error("Could not find a translation for key while trying to create an error message during the constraint validation phase. The keys that were retrieved from the generated errors are: #{JSON.stringify(keys)}. Define an according key in the 'locales' variable (e.g. '#{key_prefix}#{keys.join("_")}')!")

    # add prefixes to parts
    parts = ({message: "#{locales[locale]["#{key}_prefix" or ""]}#{part.message}", key: part.key} for part in parts)

    key = "#{phase_singular}_#{build_mode.toLowerCase()}"
    # replace {{value}} with the actual value
    prefix = part_evaluator("#{locales[locale]["#{key}_prefix"]}", errors[0])

    return default_message_builder(
        key
        phase
        build_mode
        locale
        parts
        prefix
    )



#####################################################################################################
# USED FOR CONSTRAINT ERROR MESSAGES

# mapping from group to locale key: Set -> String
# max_min == min_max
# ==> the order does not matter because its a set (and all permutations of the set map to the same value)

# intially use permutation to find the actually existing locale key for the given set
# upon a match cache the key. whenever the match becomes invalid (-> returns null) return to the initial state (so permutation is used)

# TODO: test caching
permutation_cache = {}

get_combined_key = (keys, locale, key_prefix = "", key_suffix = "") ->
    # clone keys
    keys = keys.slice(0)
    # sort because cached keys had been sorted and the convention is that locales are alphabetically sorted (joined with '_')
    keys.sort()
    cache_key = keys.join("_")

    # try to get the key from the cache
    if permutation_cache[cache_key]?
        return permutation_cache[cache_key]

    # no cache hit => try to find a key
    # get all subsets (by size, from big to small), permute each subset
    for k in [keys.length...0] by -1
        for subset in get_subsets(keys, k)
            for permutation in get_permutations(subset)
                key = key_prefix + permutation.join("_") + key_suffix
                if locales[locale][key]?
                    permutation_cache[cache_key] = key
                    return key

    return null
