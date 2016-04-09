# CLASS PROPERTIES
ERROR_MODES =
    NORMAL: "NORMAL"
    SIMPLE: "SIMPLE"
ERROR_MODES.DEFAULT = ERROR_MODES.NORMAL

ERROR_OUTPUT_MODES =
    BELOW: "BELOW"
    NONE: "NONE"
    POPOVER: "POPOVER"
    TOOLTIP: "TOOLTIP"
ERROR_OUTPUT_MODES.DEFAULT = ERROR_OUTPUT_MODES.NONE

DEPENDENCY_CHANGE_ACTIONS =
    DISPLAY: "DISPLAY"
    ENABLE: "ENABLE"
    FADE: "FADE"
    NONE: "NONE"
    OPACITY: "OPACITY"
    SHOW: "SHOW"
    SLIDE: "SLIDE"
DEPENDENCY_CHANGE_ACTIONS.DEFAULT = DEPENDENCY_CHANGE_ACTIONS.NONE
DEPENDENCY_CHANGE_ACTION_DURATION = 400 # milliseconds

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
    LIST: "LIST"
    SENTENCE: "SENTENCE"
BUILD_MODES.DEFAULT = BUILD_MODES.ENUMERATE

ERROR_MESSAGE_CONFIG =
    PHASE_ORDER: [VALIDATION_PHASES.DEPENDENCIES, VALIDATION_PHASES.VALUE, VALIDATION_PHASES.CONSTRAINTS]

PROGRESS_MODES =
    PERCENTAGE: "PERCENTAGE"
    ABSOLUTE: "ABSOLUTE"
PROGRESS_MODES.DEFAULT = PROGRESS_MODES.PERCENTAGE


# PRIVATE (CLOSURE) PROPERTIES
# list of meta data that can be cached right away because each item is needed for a basic validation (all other data will be cached when it is needed)
# => this is the list of data that is always cached
REQUIRED_CACHE = [
    "dependency_change_action"
    "depends_on"
    "id"
    "name"
    "preprocess"
    "required"
    "type"
]
OPTIONAL_CACHE = [
    # field data
    "dependency_mode"
    "error_classes"
    "success_classes"
    "dependency_error_classes"
    "error_targets"
    "group"
    "output_preprocessed"
    "postprocess"
    # validation (meta) data
    "constraints"
    "errors"
    "valid_constraints"
    "valid_dependencies"
    "valid_value"
    "value"
]
# NOTE: those are not the values with which the cache is initialized! the following values are set lazily (whenever an attribute is cached and it's missing)
DEFAULT_ATTR_VALUES =
    PREPROCESS: true
    POSTPROCESS: false
    REQUIRED: true
    OUTPUT_PREPROCESSED: true
    DEPENDENCY_MODE: "all"
    ERROR_TARGETS: ""
    DEPENDENCY_ACTION_TARGETS: ""
    DEPENDENCY_ACTION_DURATION: DEPENDENCY_CHANGE_ACTION_DURATION
    # CONSTRAINTS
    INCLUDE_MAX: "true"
    INCLUDE_MIN: "true"

# define which constraint-validator options are compatible with a constraint validator
# they are accessible in the according constraint validator in the options object
# used in _validate_constraints()
# => constraint validator options:
#    - data-fv-include-max
#    - data-fv-include-min
#    - data-fv-regex-flags
CONSTRAINT_VALIDATOR_OPTIONS =
    max: [
        "include_max"
    ]
    max_length: [
        "enforce_max_length"
    ]
    min: [
        "include_min"
    ]
    min_length: [
        "enforce_min_length"
    ]
    regex: [
        "regex_flags"
    ]


# choose what constants to attach to the FormValidator class
EXPOSED_CONSTANTS =
    BUILD_MODES: BUILD_MODES
    DEPENDENCY_CHANGE_ACTIONS: DEPENDENCY_CHANGE_ACTIONS
    ERROR_MODES: ERROR_MODES
    ERROR_OUTPUT_MODES: ERROR_OUTPUT_MODES
    PROGRESS_MODES: PROGRESS_MODES
    VALIDATION_PHASES: VALIDATION_PHASES
