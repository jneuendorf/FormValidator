# valid variables are: value, index, index_of_type, name, previous_name, element
# and whatever else is passed from the validator
# TODO: (maybe) make all messages function (instead of mustache-like style)
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
    value_positive_integer:   "'{{value}}' ist keine positive ganze Zahl"
    value_negative_integer:   "'{{value}}' ist keine negative ganze Zahl"
    value_number:             "'{{value}}' ist keine Zahl"
    value_number_max:         "'{{value}}' ist nicht kleiner als {{max}}"
    value_number_min:         "'{{value}}' ist nicht größer als {{min}}"
    value_number_max_min:     "'{{value}}' liegt nicht zwischen {{min}} und {{max}}"
    value_number_max_included: "'{{value}}' ist nicht kleiner oder gleich {{max}}"
    value_number_min_included: "'{{value}}' ist nicht größer oder gleich {{min}}"
    value_number_max_included_min: "'{{value}}' ist nicht größer als {{min}} und kleiner oder gleich {{max}}"
    value_number_max_min_included: "'{{value}}' ist nicht größer oder gleich {{min}} und kleiner als {{max}}"
    value_number_max_included_min_included: "'{{value}}' ist nicht größer oder gleich {{min}} und kleiner oder gleich {{max}}"
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
    # pre-, suffixes
    constraint_enumerate_prefix: "'{{value}}' ist nicht"
    # constraint_enumerate_suffix: ""
    constraint_list_prefix: "'{{value}}' ist nicht"
    # constraint validators
    constraint_max: "kleiner als {{max}}"
    constraint_min: "größer als {{max}}"
    constraint_max_min: "zwischen {{min}} und {{max}}"

}

# TODO: adjust english messages
$.extend locales.en, {
    email:              "'{{value}}' is no valid e-mail address"
    integer:            "'{{value}}' is no valid integer"
    positive_integer:   "'{{value}}' is no positive integer"
    negative_integer:   "'{{value}}' is no negative integer"
    number:             "'{{value}}' is no valid number"
    positive_number:    "'{{value}}' is no positive number"
    negative_number:    "'{{value}}' is no negative number"
    phone:              "'{{value}}' is no valid phone number"
    radio:              "The {{index_of_type}}. radio button was not selected"
    checkbox:           "The {{index_of_type}}. checkbox was not checked"
    select:             "Nothing was selected in the {{index_of_type}}. drop-down menu"
    dependency:         "This field can only be filled in after filling in other fields"
    text: (params) ->
        if params.name?
            return "Please fill in the field '#{params.name}'"
        if params.previous_name
            return "Please fill in the field after '#{params.previous_name}'"
        return "Please fill in the #{params.index_of_type}. text field"
}
