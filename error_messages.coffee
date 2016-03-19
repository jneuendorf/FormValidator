#######################################################
# locale DE
$.extend locales.de, {
    # dependencies (VALIDATION_PHASES_SINGULAR.DEPENDENCIES = 'dependency')
    dependency_general: "Die Abhängigkeiten dieses Felds müssen zuerst korrekt ausgefüllt wurden"
    dependency_prefix:  "Die Felder"
    dependency_suffix:  "müssen noch korrekt ausgefüllt werden"
    dependency_singular_prefix:  "Das Feld"
    dependency_singular_suffix:  "muss noch korrekt ausgefüllt werden"
    # validators (VALIDATION_PHASES_SINGULAR.VALUE = 'value')
    value_email: "'{{value}}' muss die Form 'meine.adresse@anbieter.endung' haben"
    value_email_at: "'{{value}}' muss ein @-Zeichen enthalten"
    value_email_many_at: "'{{value}}' darf höchstens ein @-Zeichen enthalten"
    value_email_dot: "'{{value}}' muss eine korrekte Endung haben (z.B. '.de')"
    value_integer: "'{{value}}' muss eine Zahl sein"
    value_integer_float: "'{{value}}' darf keine Kommazahl sein"
    value_number: "'{{value}}' muss eine Zahl sein"
    value_phone: "'{{value}}' darf nur aus Zahlen, Leerzeichen und den Zeichen '+-/()' bestehen"
    value_radio: "Eins der Optionsfelder muss ausgewählt werden"
    value_checkbox: "Das Kontrollkästchen muss ausgewählt werden"
    value_select: "Es muss eine andere Option ausgewählt werden"
    value_text: "Das Textfeld muss ausgefüllt werden"
    # constraint validators (VALIDATION_PHASES_SINGULAR.CONSTRAINTS = 'constraint')
    # pre-, suffixes (those defaults are used for all constraint_... keys that do not define it's own prefix/suffix)
    # (undefined affixes default to "")
    constraint_enumerate_prefix: "'{{value}}'"
    # constraint_enumerate_suffix: ""
    constraint_list_prefix: "'{{value}}'"
    constraint_sentence_prefix: "'{{value}}'"
    # constraint_sentence_suffix: "."
    # main constraint messages
    constraint_blacklist_prefix: "darf"
    constraint_blacklist: "keines der Zeichen '{{blacklist}}'"
    constraint_blacklist_suffix: "enthalten"
    constraint_whitelist_prefix: "muss"
    constraint_whitelist: "jedes der Zeichen '{{whitelist}}'"
    constraint_whitelist_suffix: "enthalten"
    constraint_max_prefix: "darf"
    constraint_max: "nicht größer als oder gleich {{max}}"
    constraint_max_suffix: "sein"
    constraint_max_include_max_prefix: "darf"
    constraint_max_include_max: "nicht größer als {{max}}"
    constraint_max_include_max_suffix: "sein"
    constraint_max_length_prefix: "darf"
    constraint_max_length: "nicht länger als {{max_length}} Zeichen"
    constraint_max_length_suffix: "sein"
    constraint_min_prefix: "darf"
    constraint_min: "nicht kleiner als oder gleich {{min}}"
    constraint_min_suffix: "sein"
    constraint_min_include_min_prefix: "darf"
    constraint_min_include_min: "nicht kleiner als {{min}}"
    constraint_min_include_min_suffix: "sein"
    constraint_min_length_prefix: "darf"
    constraint_min_length: "nicht kürzer als {{min_length}} Zeichen"
    constraint_min_length_suffix: "sein"
    constraint_regex_prefix: "muss"
    constraint_regex: "dem regulären Ausdruck '{{regex}}'"
    constraint_regex_suffix: "entsprechen"
}

#######################################################
# locale EN
$.extend locales.en, {
    # dependencies (VALIDATION_PHASES_SINGULAR.DEPENDENCIES = 'dependency')
    dependency_general: "This field's dependencies must be correctly filled in first"
    dependency_prefix:  "The fields"
    dependency_suffix:  "must be filled in correctly"
    dependency_singular_prefix:  "The field"
    dependency_singular_suffix:  "must be filled in correctly"
    # validators (VALIDATION_PHASES_SINGULAR.VALUE = 'value')
    value_email: "'{{value}}' address must be of the form 'my.address@provider.ending'"
    value_email_at: "'{{value}}' address must contain an @ symbol"
    value_email_many_at: "'{{value}}' address can only have one @ symbol"
    value_email_dot: "'{{value}}' must have a correct ending (i.e. '.com')"
    value_integer: "'{{value}}' must be an integer"
    value_integer_float: "'{{value}}' must not be decimal"
    value_number: "'{{value}}' must be a number"
    value_phone: "'{{value}}' can only contain numbers, spaces, and the characters '+-/()'"
    value_radio: "One of the radio buttons must be selected"
    value_checkbox: "The checkbox must be selected"
    value_select: "Another option must be selected"
    value_text: "Please fill in this text field"
    # constraint validators (VALIDATION_PHASES_SINGULAR.CONSTRAINTS = 'constraint')
    # pre-, suffixes (undefined affixes default to "")
    constraint_enumerate_prefix: "'{{value}}'"
    # constraint_enumerate_suffix: ""
    constraint_list_prefix: "'{{value}}'"
    constraint_sentence_prefix: "'{{value}}'"
    # constraint_sentence_suffix: "."
    # main constraint messages
    constraint_blacklist_prefix: "must not"
    constraint_blacklist: "contain any of the characters '{{blacklist}}'"
    constraint_blacklist_suffix: ""
    constraint_whitelist_prefix: "must"
    constraint_whitelist: "contain all of the characters '{{whitelist}}'"
    constraint_whitelist_suffix: ""
    constraint_max_prefix: "must not"
    constraint_max: "be greater than or equal to {{max}}"
    constraint_max_suffix: ""
    constraint_max_include_max_prefix: "must not"
    constraint_max_include_max: "be greater than {{max}}"
    constraint_max_include_max_suffix: ""
    constraint_max_length_prefix: "must not"
    constraint_max_length: "be longer than {{max_length}} characters"
    constraint_max_length_suffix: ""
    constraint_min_prefix: "must not"
    constraint_min: "be less than or equal to {{min}}"
    constraint_min_suffix: ""
    constraint_min_include_min_prefix: "must not"
    constraint_min_include_min: "be less than {{min}}"
    constraint_min_include_min_suffix: ""
    constraint_min_length_prefix: "must not"
    constraint_min_length: "be shorter than {{min_length}} characters"
    constraint_min_length_suffix: ""
    constraint_regex_prefix: "must"
    constraint_regex: "match the regular expression '{{regex}}'"
    constraint_regex_suffix: ""
}
