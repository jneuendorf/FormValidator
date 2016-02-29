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
REQUIRED_CACHE = [
    "depends_on"
    "name"
    "preprocess"
    "required"
    "type"
]
OPTIONAL_CACHE = [
    # field data
    "dependency_mode"
    "error_targets"
    "group"
    "output_preprocessed"
    "postprocess"
    # validation (meta) data
    "constraints"
    "valid"
    "value"
]
# NOTE: those are not the values with which the cache is initialized! the following values are set when the field data is cached and an attribute is missing
DEFAULT_ATTR_VALUES =
    PREPROCESS: true
    POSTPROCESS: false
    REQUIRED: true
    OUTPUT_PREPROCESSED: true
    DEPENDENCY_MODE: "all"
    ERROR_TARGETS: ""
