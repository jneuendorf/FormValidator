# from http://stackoverflow.com/questions/9960908/permutations-in-javascript
get_permutations = (arr) ->
    permute = (arr, memo = []) ->
        for i in [0...arr.length]
            cur = arr.splice(i, 1)
            if arr.length is 0
                results.push memo.concat(cur)
            permute(arr.slice(), memo.concat(cur))
            arr.splice(i, 0, cur[0])

    results = []
    permute(arr)
    return results


# from https://github.com/blazs/subsets
# TODO:40 add credit
get_subsets = (set, k) ->
    subsets = []
    n = set.length
    p = (i for i in [0...k])
    loop
        # push current subset
        subsets.push (set[index] for index in p)

        # if this is the last k-subset, we are done
        if p[0] is n - k
            break

        # find the right element
        i = k - 1
        while i >= 0 and p[i] + k - i is n
            i--

        # exchange them
        r = p[i]
        p[i]++
        j = 2

        # move them
        i++
        while i < k
            p[i] = r + j
            i++
            j++

    return subsets

group_arr_by = (arr, get_prop) ->
    grouped = {}
    for elem in arr
        if not (key = get_prop?(elem))?
            key = elem
        if not grouped[key]?
            grouped[key] = []
        grouped[key].push elem
    return grouped





# taken from http://rosettacode.org/wiki/Topological_sort#CoffeeScript
# toposort = (tuples) ->
#     # tuples is a list of tuples, where the 1st tuple elems are parent nodes and
#     # where the 2nd tuple elems are lists that contain nodes that must precede the parent
#
#     # Start by identifying obviously independent nodes
#     independents = []
#     for tuple, i in tuples
#         if tuple[1].length is 0
#             tuples[i] = null
#             independents.push tuple[0]
#
#     tuples = (tuple for tuple in tuples when tuple?)
#
#     # Note reverse dependencies for theoretical O(M+N) efficiency.
#     reverse_deps = []
#     for tuple in tuples
#         for child in tuple[1]
#             # find correct list
#             idx = (i for list, i in reverse_deps when list[0] is child)[0] or -1
#             if idx < 0
#                 idx = reverse_deps.length
#                 reverse_deps.push []
#             reverse_deps[idx].push tuple[0]
#
#     # Now greedily start with independent nodes, then start
#     # breaking dependencies, and keep going as long as we still
#     # have independent nodes left.
#     result = []
#     while independents.length > 0
#         k = independents.pop()
#         result.push k
#         list = (list for list in reverse_deps when list[0] is k)
#         for parent, i in list when i > 0
#             # remove current independent node from list of dependencies of current parent
#             for tuple, j in tuples when tuple[0] is parent
#                 tuples[j] = (dep for dep in tuple[1] when dep is k)
#                 idx = j
#                 break
#
#             if tuples[idx][1].length is 0
#                 independents.push parent
#                 # remove tuple with no more dependencies
#                 tuples = (tuple for tuple, j in tuples when j isnt idx)
#
#     # Show unresolvable dependencies
#     for tuple in tuples
#         console.log "WARNING: node is part of cyclical dependency:", tuple
#     return result
# TODO:10 make this better (tried above but above is not working)
toposort = (targets) ->
    targets = parse_deps(targets)
    # targets is hash of sets, where keys are parent nodes and
    # where values are sets that contain nodes that must precede the parent

    # Start by identifying obviously independent nodes
    independents = []
    do ->
        for k of targets
            if targets[k].cnt is 0
                delete targets[k]
                independents.push k
    # console.log independents

    # NOTE: reverse dependencies for theoretical O(M+N) efficiency.
    # REVIEW: does this actually improved anything? and if so is it worth reversing everything?
    reverse_deps = []
    do ->
        for k of targets
            for child of targets[k].v
                reverse_deps[child] ?= []
                reverse_deps[child].push k

    # Now be greedy--start with independent nodes, then start
    # breaking dependencies, and keep going as long as we still
    # have independent nodes left.
    result = []
    while independents.length > 0
        k = independents.pop()
        result.push k
        for parent in reverse_deps[k] or []
            set_remove targets[parent], k
            if targets[parent].cnt is 0
                independents.push parent
                delete targets[parent]

    # Show unresolvable dependencies
    for k of targets
        # console.log "WARNING: node #{k} is part of cyclical dependency"
        throw new Error("FormValidator::validate: Detected cyclical dependencies. Adjust your dependency definitions")
    return result

parse_deps = (data) ->
    # parse string data, remove self-deps, and fill in gaps
    # e.g. this would transform {a: "a b c", d: "e"} to this:
    #   a: set(b, c)
    #   b: set()
    #   c: set()
    #   d: set(e)
    #   e: set()
    targets = {}
    deps = set()
    for k, v of data
        targets[k] = set()
        children = v
        for child in children
            if child is ''
                continue
            set_add targets[k], child unless child is k
            set_add deps, child

    # make sure even leaf nodes are in targets
    for dep of deps.v
        if dep not of targets
            targets[dep] = set()
    return targets

set = () ->
    return {
        cnt: 0
        v: {}
    }

set_add = (s, e) ->
    if not s.v[e]
        s.cnt += 1
        s.v[e] = true
    return s

set_remove = (s, e) ->
    if s.v[e]
        s.cnt -= 1
        delete s.v[e]
    return s

# data =
#       des_system_lib:   "std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee"
#       dw01:             "ieee dw01 dware gtech"
#       dw02:             "ieee dw02 dware"
#       dw03:             "std synopsys dware dw03 dw02 dw01 ieee gtech"
#       dw04:             "dw04 ieee dw01 dware gtech"
#       dw05:             "dw05 ieee dware"
#       dw06:             "dw06 ieee dware"
#       dw07:             "ieee dware"
#       dware:            "ieee dware"
#       gtech:            "ieee gtech"
#       ramlib:           "std ieee"
#       std_cell_lib:     "ieee std_cell_lib"
#       synopsys:         ""
#
#
# targets = parse_deps()
# console.log toposort targets

# class GraphNode
#
#     # CONSTRUCTOR
#     constructor: () ->
#         @incoming_edges = []
#
#     has_edge: () ->
#
# class Graph
#
#     # CONSTRUCTOR
#     constructor: () ->
#         @nodes = []
#
#     has_edges: () ->
#         for node in @nodes when node.incoming_edges.length > 0
#             return true
#         return false
#
#     add_edge: (from, to) ->
#
#
#     remove_edge: (from, to) ->
#
# # L ← Empty list that will contain the sorted elements
# # S ← Set of all nodes with no incoming edges
# # while S is non-empty do
# #     remove a node n from S
# #     add n to tail of L
# #     for each node m with an edge e from n to m do
# #         remove edge e from the graph
# #         if m has no other incoming edges then
# #             insert m into S
# # if graph has edges then
# #     return error (graph has at least one cycle)
# # else
# #     return L (a topologically sorted order)
# toposort = (fields) ->
#     # build graph
#     graph = []
#     for elem in fields
#         data = @_get_element_data(elem)
#
#         graph.push {
#             field: elem
#             incoming_edges: []
#         }
#
#     # do topological sort
#     L = []
#     S = []
#     while S.length > 0
#         n = S.pop()
#         L.push n
#         for m in graph when (e = m.has_edge(n, m))
#             graph.remove_edge(e)
#             if m.incoming_edges.length is 1
#                 S.push m
#     if not graph.has_edges()
#         return L
#     throw new Error()

 #####################################################################################################
# USED FOR CONSTRAINT ERROR MESSAGES (in error_message_builders.coffee)

# mapping from group to locale key: Set -> String
# max_min == min_max
# ==> the order does not matter because its a set (and all permutations of the set map to the same value)

# intially use permutation to find the actually existing locale key for the given set
# upon a match cache the key. whenever the match becomes invalid (-> returns null) return to the initial state (so permutation is used)

# REVIEW test caching
_permutation_cache = {}
get_combined_key = (keys, locale, key_prefix = "", key_suffix = "") ->
    # clone keys
    keys = keys.slice(0)
    # sort because cached keys had been sorted and the convention is that locales are alphabetically sorted (joined with '_')
    keys.sort()
    cache_key = keys.join("_")

    # try to get the key from the cache
    if _permutation_cache[cache_key]?
        return _permutation_cache[cache_key]

    # no cache hit => try to find a key
    # get all subsets (by size, from big to small), permute each subset
    for k in [keys.length...0] by -1
        for subset in get_subsets(keys, k)
            for permutation in get_permutations(subset)
                key = key_prefix + permutation.join("_") + key_suffix
                if locales[locale][key]?
                    _permutation_cache[cache_key] = key
                    return key

    return null
