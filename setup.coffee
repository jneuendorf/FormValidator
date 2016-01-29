if not Array::unique?
    Array::unique = () ->
        res = []
        for elem in @ when elem not in res
            res.push elem
        return res

if not $.fn.attrAll?
    $.fn.attrAll = (propName, delimiter = " ", unique = true) ->
        result = []
        @each (idx, elem) ->
            result.push $(elem).attr(propName)
            return true

        if unique
            result = result.unique()
        return result.join(delimiter)
