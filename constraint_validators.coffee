

constraint_validators =
    blacklist: (value, blacklist) ->
    max: (value, max) ->
    max_length: (value, max_length) ->
    min: (value, min) ->
    min_length: (value, min_length) ->
    regex: (value, regex) ->
    whitelist: (value, whitelist) ->
    # constraint validator options
    include_max: () ->
    include_min: () ->

# compatible_constraint_validators = [
#     [""]
# ]
