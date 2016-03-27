dependency_change_actions = {}

dependency_change_actions[DEPENDENCY_CHANGE_ACTION.DISPLAY] = (element, valid) ->
    if not valid
        element.data "_fv_orig_display", element.css("display")
        element.css "display", "none"
    else
        if (orig_display = element.data("_fv_orig_display"))?
            element.css "display", orig_display
    return element

dependency_change_actions[DEPENDENCY_CHANGE_ACTION.ENABLE] = (element, valid) ->
    return element.prop("disabled", not valid)

dependency_change_actions[DEPENDENCY_CHANGE_ACTION.FADE] = (element, valid) ->
    if valid
        element.fadeIn DEPENDENCY_CHANGE_ACTION_DURATION
    else
        element.fadeOut DEPENDENCY_CHANGE_ACTION_DURATION
    return element

dependency_change_actions[DEPENDENCY_CHANGE_ACTION.OPACITY] = (element, valid) ->
    if not valid
        element.data "_fv_orig_opacity", element.css("opacity")
        element.css "opacity", 0
    else
        if (orig_opacity = element.data("_fv_orig_opacity"))?
            element.css "opacity", orig_opacity
    return element

dependency_change_actions[DEPENDENCY_CHANGE_ACTION.SHOW] = (element, valid) ->
    if valid
        element.show DEPENDENCY_CHANGE_ACTION_DURATION
    else
        element.hide DEPENDENCY_CHANGE_ACTION_DURATION
    return element

dependency_change_actions[DEPENDENCY_CHANGE_ACTION.SLIDE] = (element, valid) ->
    if valid
        element.slideDown DEPENDENCY_CHANGE_ACTION_DURATION
    else
        element.slideUp DEPENDENCY_CHANGE_ACTION_DURATION
    return element
