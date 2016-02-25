# override build_mode_helpers here if needed (same signature as a build_mode_helper)
locale_build_mode_helpers =
    de: {}
    en: {}


build_mode_helpers = {}

build_mode_helpers[BUILD_MODES.ENUMERATE] = (parts, locale) ->
    if parts.length > 1
        return "#{parts.slice(0, -1).join(", ")} #{locales[locale]["and"]} #{parts.slice(-1)}"
    return parts[0]

build_mode_helpers[BUILD_MODES.SENTENCE] = (parts, locale) ->
    return parts.join(". ").trim()

build_mode_helpers[BUILD_MODES.LIST] = (parts, locale) ->
    return "<ul><li>#{parts.join("</li><li>")}</li></ul>"


# errors = all error objects of an element that have a certain phase (dependency, value validation, or constraint validation errors)
default_message_builder = (key, build_mode, locale, parts, prefix, suffix) ->
    prefix = prefix or locales[locale]["#{key}_prefix"] or ""
    suffix = suffix or locales[locale]["#{key}_suffix"] or ""
    message = locale_build_mode_helpers[locale][build_mode]?(parts, locale) or build_mode_helpers[build_mode](parts, locale)
    return prefix + message + suffix


# use this function to parse mustache-like strings or evaluate functions
part_evaluator = (part, values) ->
    # string => mustache-like
    if typeof part is "string"
        for key, val of values when part.indexOf("{{#{key}}}") >= 0
            part = part.replace("{{#{key}}}", val)
        return part

    if part instanceof Function
        return part(values)

    return ""


error_message_builders = {}

error_message_builders[VALIDATION_PHASES.DEPENDENCIES] = (errors, phase, build_mode, locale) ->
    names = (error.name for error in errors when error.name?)

    # if all errors have a name property (<=> all dependencies are named)
    if names.length is errors.length
        # sentence does not make sense in this case => fallback to enumerate
        if build_mode is BUILD_MODES.SENTENCE
            build_mode = BUILD_MODES.ENUMERATE
        parts = ("'#{name}'" for name in names)
        return default_message_builder("dependency", build_mode, locale, parts)
    return locales[locale]["dependency_general"]

error_message_builders[VALIDATION_PHASES.VALUE] = (errors, phase, build_mode, locale) ->
    error = errors[0]
    type = error.type
    # here only 1 error is in the 'errors' list => therefore we just use the simplest build mode
    part = part_evaluator(locales[locale][type], error)
    return default_message_builder(type, BUILD_MODES.ENUMERATE, locale, [part])

error_message_builders[VALIDATION_PHASES.CONSTRAINTS] = (errors, phase, build_mode, locale) ->
    return ""
