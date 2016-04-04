#########################################################################################################
# WORKFLOW: error_message_builders[VALIDATION_PHASE] -> message builder

locale_message_builders =
    de: {}
    en: {}
locale_message_builders.de[BUILD_MODES.ENUMERATE] = null
locale_message_builders.de[BUILD_MODES.SENTENCE] = null
locale_message_builders.de[BUILD_MODES.LIST] = null
locale_message_builders.en[BUILD_MODES.ENUMERATE] = null
locale_message_builders.en[BUILD_MODES.SENTENCE] = null
locale_message_builders.en[BUILD_MODES.LIST] = null


message_builders = {}
message_data_creators = {}

# NOTE: This class structure overhead was made mainly for structuring/API reasons. If this causes preformance problems this should be simplified
class Maker

    # CONSTRUCTOR
    constructor: (namespace, key, func) ->
        if arguments.length is 3
            @func = func
            namespace[key] = @
        else
            @func = arguments[0]

    make: () ->
        return @func(arguments...)


# This class'es instance's method is used to create the "raw" message data from the error data
class MessageDataCreator extends Maker

    # CONSTRUCTOR
    constructor: (name, func) ->
        super(message_data_creators, name, func)

    create_data: (errors, phase, build_mode, locale) ->
        return @make(errors, phase, build_mode, locale)


# This class'es instance's method is used to transform the "raw" message data from the ErrorMessageBuilder
class MessageBuilder extends Maker

    # CONSTRUCTOR
    constructor: (name, func) ->
        super(message_builders, name, func)

    build_message: (parts, locale, phase, build_mode, error_data) ->
        return @make(parts, locale, phase, build_mode, error_data)


class OrderedDict

    # CONSTRUCTOR
    constructor: () ->
        @_dict = {}
        @_order = []

    put: (key, val, idx) ->
        @_dict[key] = val
        if not idx?
            if key not in @_order
                @_order.push key
        else
            i = @_order.indexOf(key)
            # == key in @_order => remove it first
            if i >= 0
                @_order.splice(i, 1)
            @_order.splice(idx, 0, key)
        return @

    get: (key) ->
        return @_dict[key]

    remove: (key) ->
        delete @_dict[key]
        @_order = (item for item in @_order when item isnt key)
        return @

    join: (str = "") ->
        return (@_dict[key].join?(str) or @_dict[key] for key in @_order).join(str)

    each: (callback) ->
        for key, i in @_order
            if callback.call(@, key, @_dict[key], i) is false
                return @
        return @

    to_array: () ->
        return (@_dict[key] for key in @_order)

    to_object: () ->
        res = {}
        for key, val of @_dict
            res[key] = val
        return res

    get_object: () ->
        return @_dict

    get_order: () ->
        return @_order


# this function parses and replaces mustache-like strings or evaluate functions
part_evaluator = (part, values...) ->
    if values.length is 1
        values = values[0]
    else
        values = $.extend(values...)

    # string => mustache-like
    if typeof part is "string"
        for key, val of values
            substr = "{{#{key}}}"
            if part.indexOf(substr) >= 0
                regex = new RegExp(substr, "g")
                part = part.replace(regex, val)
        return part

    if part instanceof Function
        return part(values)

    throw new Error("FormValidator: Error while building an error message. Expected mustache-like string or function but was given:", part, values)


################################################################################################
# DEFINE MESSAGE BUILDERS (FOR EACH VALIDATION PHASE)

new MessageDataCreator VALIDATION_PHASES.DEPENDENCIES, (errors, phase, build_mode, locale) ->
    names = (error.name for error in errors when error.name?)

    # if all errors have a name property (<=> all dependencies are named)
    if names.length is errors.length
        # sentence does not make sense in this case => fallback to enumerate
        # if build_mode is BUILD_MODES.SENTENCE
        #     build_mode = BUILD_MODES.ENUMERATE
        lang_data = locales[locale]
        key = VALIDATION_PHASES_SINGULAR[phase].toLowerCase()
        if names.length is 1
            key += "_singular"
        prefix_key = "#{key}_prefix"
        suffix_key = "#{key}_suffix"
        parts = ({message: "'#{name}'", prefix: lang_data[prefix_key], suffix: lang_data[suffix_key]} for name in names)
    else
        key = "#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_general"
        parts = []
    return {parts}
    # return locales[locale]["#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_general"]

new MessageDataCreator VALIDATION_PHASES.VALUE, (errors, phase, build_mode, locale) ->
    # NOTE each error in errors (exactly 1 because of the phase) contains an error_message_type. that type is prefered over the normal type
    error = errors[0]
    key = "#{VALIDATION_PHASES_SINGULAR[phase].toLowerCase()}_#{error.error_message_type or error.type}"
    # here only 1 error is in the 'errors' list => therefore we just use the simplest build mode
    part =
        message: part_evaluator(locales[locale][key], error)
        prefix: ""
        suffix: ""
    # return message_builders[build_mode.toLowerCase()](key, phase, build_mode, locale, [part])
    return {key, parts: [part]}

new MessageDataCreator VALIDATION_PHASES.CONSTRAINTS, (errors, phase, build_mode, locale) ->
    parts = []
    # group by error.type as defined in constraint_validator_groups (if an error is in no group it implicitely creates an own group)
    grouped_errors = []
    ungrouped_errors = []
    for error in errors
        error_in_group = false
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
    default_prefix = locales[locale]["#{phase_singular}_#{build_mode}_prefix".toLowerCase()] or ""
    default_suffix = locales[locale]["#{phase_singular}_#{build_mode}_suffix".toLowerCase()] or ""
    # go through groups of errors (and skip empty entries caused in the above loop)
    for errors in grouped_errors when errors?
        keys = []
        for error in errors
            keys.push error.type
            if error.options?
                for option, val of error.options when include_constraint_option_in_locale_key(option, val, locale)
                    keys.push option

        key = get_combined_key(keys, locale, key_prefix)
        if key?
            parts.push {
                message: part_evaluator(locales[locale][key], errors...)
                prefix: part_evaluator(locales[locale]["#{key}_prefix"], error) or default_prefix
                suffix: part_evaluator(locales[locale]["#{key}_suffix"], error) or default_suffix
            }
        else if DEBUG
            throw new Error("Could not find a translation for key while trying to create an error message during the constraint validation phase. The keys that were retrieved from the generated errors are: #{JSON.stringify(keys)}. Define an according key in the 'locales' variable (e.g. '#{key_prefix}#{keys.join("_")}')!")

    key = "#{phase_singular}_#{build_mode.toLowerCase()}"
    # replace {{value}} with the actual value
    prefix = part_evaluator("#{locales[locale]["#{key}_prefix"]}", errors[0])
    error_data = $.extend([{}].concat(errors)...)

    return {key, parts, error_data, prefix}


# this function concatenates the prefix, mid part (== joined parts), and the suffix (used in the error message builders)
# key = locale key used to find pre- and suffix
message_builder_helper = new Maker (data, phase, build_mode, locale, prefix, suffix, prefix_delimiter = " ", suffix_delimiter = " ") ->
    # unpack data and set defaults
    {key, parts, error_data = {}} = data
    prefix = prefix or data.prefix or locales[locale]["#{key}_prefix"] or ""
    suffix = suffix or data.suffix or locales[locale]["#{key}_suffix"] or ""

    data.prefix = prefix?() or prefix
    data.suffix = suffix?() or suffix

    for part, i in parts
        dict = new OrderedDict()
        # if prefix instanceof Function
        #     prefix = prefix()
        if part.prefix
            dict.put("prefix", part.prefix)
            dict.put("prefix_delimiter", part.prefix_delimiter or prefix_delimiter)

        dict.put("message", part.message)

        # if suffix instanceof Function
        #     suffix = suffix()
        if part.suffix
            dict.put("suffix_delimiter", part.suffix_delimiter or suffix_delimiter)
            dict.put("suffix", part.suffix)

        parts[i] = dict

    new_parts = new OrderedDict()
    for part, i in parts
        new_parts.put(i, part)

    data.parts = new_parts
    return data

new MessageBuilder BUILD_MODES.ENUMERATE, (data, phase, build_mode, locale) ->
    data = message_builder_helper.make(data, phase, build_mode, locale)
    parts = data.parts.to_array()

    lang_data = locales[locale]
    parts_grouped_by_suffix = group_arr_by parts, (part) ->
        return part.get("suffix") or ""

    parts = []
    for suffix, suffix_group of parts_grouped_by_suffix
        parts_grouped_by_prefix = group_arr_by suffix_group, (part) ->
            return part.get("prefix") or ""
        # let the common prefix remain only in 1st part of the group
        for prefix, prefix_group of parts_grouped_by_prefix
            for p, i in prefix_group when i > 0
                p.remove("prefix")
                p.remove("prefix_delimiter")

        # let the common suffix remain only in the last part of the group
        for p, i in suffix_group when i < suffix_group.length - 1
            p.remove("suffix_delimiter")
            p.remove("suffix")

        parts = parts.concat suffix_group

    new_parts = new OrderedDict()
    for part, i in parts
        # prepend "and" to last part (if it's not the only part)
        if i is parts.length - 1 and i > 0
            part.put("prefix", " #{locales[locale]["and"]} #{part.get("prefix") or ""}", 0)
            part.put("prefix_delimiter", " ", 1)
        new_parts.put(i, part)
    data.parts = new_parts
    return "#{data.prefix or ""} #{new_parts.join("")} #{data.suffix or ""}".replace(/\s+/g, " ")

new MessageBuilder BUILD_MODES.SENTENCE, (data, phase, build_mode, locale) ->
    data = message_builder_helper.make(data, phase, build_mode, locale)
    data.parts.each (idx, part) ->
        part.put("prefix", " #{data.prefix or ""} #{part.get("prefix") or ""}".trim(), 0)
        part.put("prefix_delimiter", " ", 1)
        part.put("suffix_delimiter", (if part.get("suffix") then part.get("suffix_delimiter") else ""), 3)
        part.put("suffix", " #{data.suffix or ""} #{part.get("suffix") or ""}.".trim(), 4)
        return true
    parts = []
    for part in data.parts.to_array()
        parts.push part.join()

    return parts.join(" ").replace(/\s+/g, " ").trim()

new MessageBuilder BUILD_MODES.LIST, (data, phase, build_mode, locale) ->
    sentences = message_builders[BUILD_MODES.SENTENCE].build_message(data, phase, build_mode, locale)
    if sentences[sentences.length - 1] is "."
        sentences += " "
    return "<ul><li>#{("#{sentence}." for sentence in sentences.split(". ") when sentence).join("</li><li>")}</li></ul>"
