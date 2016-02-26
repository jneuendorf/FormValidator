# CLASS PROPERTIES
ERROR_MODES =
    NORMAL: "NORMAL"
    SIMPLE: "SIMPLE"
ERROR_MODES.DEFAULT = ERROR_MODES.NORMAL

ERROR_OUTPUT_MODES =
    BELOW: "BELOW"
    BOOTSTRAP_POPOVER_ON_FOCUS: "BOOTSTRAP_POPOVER_ON_FOCUS"
    NONE: "NONE"
ERROR_OUTPUT_MODES.DEFAULT = ERROR_OUTPUT_MODES.NONE

VALIDATION_PHASES =
    DEPENDENCIES: "DEPENDENCIES"
    VALUE: "VALUE"
    CONSTRAINTS: "CONSTRAINTS"
VALIDATION_PHASES_SINGULAR =
    DEPENDENCIES: "DEPENDENCY"
    VALUE: "VALUE"
    CONSTRAINTS: "CONSTRAINT"
BUILD_MODES =
    ENUMERATE: "ENUMERATE"
    SENTENCE: "SENTENCE"
    LIST: "LIST"
BUILD_MODES.DEFAULT = BUILD_MODES.ENUMERATE

ERROR_MESSAGE_CONFIG =
    PHASE_ORDER: [VALIDATION_PHASES.DEPENDENCIES, VALIDATION_PHASES.VALUE, VALIDATION_PHASES.CONSTRAINTS]
    BUILD_MODE: BUILD_MODES.DEFAULT


# PRIVATE (CLOSURE) PROPERTIES
# list of meta data that can be cached right away because each item is needed for a basic validation (all other data will be cached when it is needed)
# => this is the list of data that is always cached
CACHED_FIELD_DATA = [
    "depends_on"
    "name"
    "preprocess"
    "required"
    "type"
]
