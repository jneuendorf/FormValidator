# NOTE: the name gets converted to kebap case => max_length -> data-fv-max-length
constraint_validators =
    blacklist: (value, blacklist) ->
        for char in value when blacklist.indexOf(char) >= 0
            return false
        return true
    max: (value, max, options) ->
        if options?.include_max is "false"
            return value < max
        return value <= max
    max_length: (value, max_length) ->
        return value.length <= max_length
    min: (value, min, options) ->
        if options?.include_min is "false"
            return value > min
        return value >= min
    min_length: (value, min_length) ->
        return value.length >= min_length
    regex: (value, regex, options) ->
        return (new RegExp(regex, options.flags)).test(value)
    whitelist: (value, whitelist) ->
        for char in value when blacklist.indexOf(char) < 0
            return false
        return true


# define which constraint-validator options are compatible with a constraint validator
# they are accessible in the according constraint validator in the options object
# used in _validate_constraints()
# => constraint validator options:
#    - data-fv-include-max
#    - data-fv-include-min
#    - data-fv-regex-flags
constraint_validator_options =
    max: [
        "include_max"
    ]
    mix: [
        "include_mix"
    ]
    regex: [
        "regex_flags"
    ]

# define which constraint validators are logically connected (and thus can potentially be combined to a new error message i.e. max + min => ...is not between... (instead of ...is not greater than or not less than...))
# the groups must be disjoint
constraint_validator_groups = [
    ["max", "min"]
    ["max_length", "min_length"]
]

# mapping from group to locale key: Set -> String
# max_min == min_max
# ==> the order does not matter because its a set (and all permutations of the set map to the same value)

# intially use permutation to find the actually existing locale key for the given set
# upon a match cache the key. whenever the match becomes invalid (-> returns null) return to the initial state (so permutation is used)
# from http://stackoverflow.com/questions/9960908/permutations-in-javascript
get_permutations = (input) ->
    permute = (arr, results, memo = []) ->
        for i in [0...arr.length]
            cur = arr.splice(i, 1)
            if arr.length is 0
                results.push memo.concat(cur)
            permute(arr.slice(), memo.concat(cur))
            arr.splice(i, 0, cur[0])

    results = []
    permute(input, results)
    return results


permutation_cache = {}

get_combined_key = (keys, locale, key_prefix = "", key_suffix = "") ->
    # clone keys
    keys = keys.slice(0)
    # sort because cached keys had been sorted and the convention is that locales are sorted lists of constraints (joined with '_')
    keys.sort()

    while keys.length > 0
        # check the cache for an entry
        key = key_prefix + keys.join("_") + key_suffix
        if permutation_cache[key]?
            return key
        # no cache hit => try all permutations
        for permutation in get_permutations(keys)
            key = key_prefix + permutation.join("_") + key_suffix
            if locales[locale][key]?
                permutation_cache[key] = true
                return key
        keys.pop()

    return null
