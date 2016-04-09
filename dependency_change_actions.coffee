dependency_change_actions = {}


dependency_change_actions[DEPENDENCY_CHANGE_ACTIONS.DISPLAY] = (element, valid, duration) ->
    if not valid
        element.data "_fv_orig_display", element.css("display")
        element.css "display", "none"
    else
        if (orig_display = element.data("_fv_orig_display"))?
            element.css "display", orig_display
    return element


dependency_change_actions[DEPENDENCY_CHANGE_ACTIONS.ENABLE] = (element, valid, duration) ->
    return element.prop("disabled", not valid)


dependency_change_actions[DEPENDENCY_CHANGE_ACTIONS.FADE] = (element, valid, duration) ->
    if valid
        element.fadeIn duration
    else
        element.fadeOut duration
    return element


dependency_change_actions[DEPENDENCY_CHANGE_ACTIONS.OPACITY] = (element, valid, duration) ->
    if not valid
        element.data "_fv_orig_opacity", element.css("opacity")
        element.animate {opacity: 0, duration}
    else
        if (orig_opacity = element.data("_fv_orig_opacity"))?
            element.animate {opacity: orig_opacity, duration}
    return element


dependency_change_actions[DEPENDENCY_CHANGE_ACTIONS.SHOW] = (element, valid, duration) ->
    if valid
        element.show duration
    else
        element.hide duration
    return element


dependency_change_actions[DEPENDENCY_CHANGE_ACTIONS.SLIDE] = (element, valid, duration) ->
    if valid
        element.slideDown duration
    else
        element.slideUp duration
    return element
