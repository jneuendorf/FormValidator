#######################################################
# locale DE
$.extend locales.de, {
    # dependencies (VALIDATION_PHASES_SINGULAR.DEPENDENCIES = 'dependency')
    dependency_general: "Dieses Feld kann erst dann korrekt ausgefüllt werden, wenn seine Abhängigkeiten korrekt ausgefüllt wurden"
    dependency_prefix:  "Die Felder"
    dependency_suffix:  "sind noch ungültig"
    # validators (VALIDATION_PHASES_SINGULAR.VALUE = 'value')
    value_email:              "'{{value}}' ist keine gültige E-Mail-Adresse"
    value_email_at:           "Eine E-Mail-Adresse muss ein @-Zeichen enthalten"
    value_email_many_at:      "Eine E-Mail-Adresse darf höchstens ein @-Zeichen enthalten"
    value_email_dot:          "'{{value}}' hat keine korrekte Endung (z.B. '.de')"
    value_integer:            "'{{value}}' ist keine Zahl"
    value_integer_float:      "'{{value}}' ist keine ganze Zahl"
    value_number:             "'{{value}}' ist keine Zahl"
    value_phone_length:       "'{{value}}' ist weniger als {{length}} Zeichen lang"
    value_phone:              "'{{value}}' ist keine gültige Telefonnummer"
    value_radio:              "Die {{index_of_type}}. Auswahlbox wurde nicht ausgewählt"
    value_checkbox:           "Die {{index_of_type}}. Checkbox wurde nicht ausgewählt"
    value_select:             "Das {{index_of_type}}. Auswahlmenü wurde nicht ausgewählt"
    value_text: (params) ->
        if params.name?
            return "Bitte füllen Sie das Feld '#{params.name}' aus"
        if params.previous_name
            return "Bitte füllen Sie das Feld nach '#{params.previous_name}' aus"
        return "Bitte füllen Sie das #{params.index_of_type}. Textfeld aus"
    # constraint validators (VALIDATION_PHASES_SINGULAR.CONSTRAINTS = 'constraint')
    # pre-, suffixes (those are used for all constraint_... keys that do not define it's own prefix)
    constraint_enumerate_prefix: "'{{value}}' darf"
    # constraint_enumerate_suffix: ""
    constraint_list_prefix: "'{{value}}'"
    # constraint validators (negated formulation because prefix is negated itself)
    constraint_blacklist: "keines der Zeichen '{{blacklist}}' enthalten"
    constraint_whitelist_prefix: "'{{value}}' muss"
    constraint_whitelist: "jedes der Zeichen '{{whitelist}}' enthalten"
    constraint_max: "nicht größer als {{max}} sein"
    constraint_max_include_max: "nicht größer als oder gleich {{max}} sein"
    constraint_max_length: "nicht länger als {{max_length}} Zeichen lang sein"
    constraint_min: "nicht kleiner als {{min}} sein"
    constraint_min_include_min: "nicht kleiner als oder gleich {{min}} sein"
    constraint_min_length: "ist kürzer als {{min_length}} Zeichen sein"
    constraint_regex: "nicht dem regulären Ausdruck '{{regex}}' widersprechen"

}

#######################################################
# locale EN
$.extend locales.en, {
    # dependencies (VALIDATION_PHASES_SINGULAR.DEPENDENCIES = 'dependency')
    dependency_general: "This field can only be filled in after filling in its required fields"
    dependency_prefix:  "The fields"
    dependency_suffix:  "are still invalid"
    # validators (VALIDATION_PHASES_SINGULAR.VALUE = 'value')
    value_email:              "'{{value}}' is no valid e-mail address"
    value_email_at:           "Eine E-Mail-Adresse muss ein @-Zeichen enthalten"
    value_email_many_at:      "Eine E-Mail-Adresse darf höchstens ein @-Zeichen enthalten"
    value_email_dot:          "'{{value}}' hat keine korrekte Endung (z.B. '.de')"
    value_integer:            "'{{value}}' is no valid integer"
    value_integer_float:      "'{{value}}' ist keine ganze Zahl"
    value_number:             "'{{value}}' is no valid number"
    value_phone_length:       "'{{value}}' ist weniger als {{length}} Zeichen lang"
    value_phone:              "'{{value}}' is no valid phone number"
    value_radio:              "Die {{index_of_type}}. Auswahlbox wurde nicht ausgewählt"
    value_checkbox:           "Die {{index_of_type}}. Checkbox wurde nicht ausgewählt"
    value_select:             "Das {{index_of_type}}. Auswahlmenü wurde nicht ausgewählt"
    value_text: (params) ->
        if params.name?
            return "Please fill in the field '#{params.name}'"
        if params.previous_name
            return "Please fill in the field after '#{params.previous_name}'"
        return "Please fill in the #{params.index_of_type}. text field"
    # constraint validators (VALIDATION_PHASES_SINGULAR.CONSTRAINTS = 'constraint')
    # pre-, suffixes
    constraint_enumerate_prefix: "'{{value}}'"
    # constraint_enumerate_suffix: ""
    constraint_list_prefix: "'{{value}}'"
    # constraint validators (negated formulation because prefix is negated itself)
    constraint_blacklist: "enthält ein Zeichen in '{{blacklist}}'"
    constraint_max: "ist nicht kleiner als {{max}}"
    constraint_max_include_max: "ist nicht kleiner als oder gleich {{max}}"
    constraint_max_length: "ist länger als {{max_length}} Zeichen"
    constraint_min: "ist nicht größer als {{min}}"
    constraint_min_include_min: "ist nicht größer als oder gleich {{min}}"
    constraint_min_length: "ist kürzer als {{min_length}} Zeichen"
    constraint_regex: "entspricht nicht dem regulären Ausdruck '{{regex}}'"
}
