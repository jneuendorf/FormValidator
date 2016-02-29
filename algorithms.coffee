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
# TODO: add credit
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