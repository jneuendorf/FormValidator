ERROR_MODES =
    NORMAL: "NORMAL"
    SIMPLE: "SIMPLE"
ERROR_MODES.DEFAULT = @ERROR_MODES.NORMAL

ERROR_OUTPUT_MODES =
    BELOW: "BELOW"
    BOOTSTRAP_POPOVER_ON_FOCUS: "BOOTSTRAP_POPOVER_ON_FOCUS"
    NONE: "NONE"
ERROR_OUTPUT_MODES.DEFAULT = @ERROR_OUTPUT_MODES.NONE

# list of meta data that can be cached right away because each item is needed for a basic validation (all other data will be cached when it is needed)
# => this is the list of data that is always cached
CACHED_FIELD_DATA = [
    "depends_on"
    "name"
    "preprocess"
    "required"
    "type"
]
