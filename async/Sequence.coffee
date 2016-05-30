###*
 * This is a minimal version of the Sequence class of my js_utils project ('async' module).
*###
class Sequence
    @PARAM_MODES =
        CONTEXT:    "CONTEXT"
        IMPLICIT:   "IMPLICIT"
        EXPLICIT:   "EXPLICIT"

    ################################################################################################
    # CONSTRUCTOR
    constructor: (data = []) ->
        @data = data
        @idx = 0
        @_doneCallbacks = []
        @_isDone = false
        @_parameterMode = @constructor.PARAM_MODES.EXPLICIT
        @_invokeNextFunction()

    _createParamListFromContext: (func, context) ->
        if context not instanceof Array
            paramList = func.toString()
                .split /[()]/g
                .second
                .split /\s*,\s*/g
            temp = []
            for argName in paramList
                temp.push context[argName]
            return temp
        return context.slice(0)

    ###*
    * This method invokes the next function in the list.
    * @protected
    * @method _invokeNextFunction
    * @param previousReult {mixed}
    * The result the previously executed function returned or `null`.
    * @param args... {mixed}
    * These are the arguments passed to the callback itself.
    * @return This istance. {Sequence}
    * @chainable
    *###
    _invokeNextFunction: (args...) ->
        CLASS = @constructor
        data = @data[@idx]

        # there is data (data = next function in the list) => do stuff
        if data?
            if data instanceof Array
                func    = data[0]
                scope   = data[1]
                params  = data[2]
            else
                func    = data.func
                scope   = data.scope
                params  = data.params

            if func?
                self = @

                # valid params are given explicitly => override param mode
                if params instanceof Array and params.length > 0
                    @_parameterMode = CLASS.PARAM_MODES.EXPLICIT

                if @_parameterMode is CLASS.PARAM_MODES.CONTEXT
                    newParams = @_createParamListFromContext(func, args[0].context)
                else if @_parameterMode is CLASS.PARAM_MODES.EXPLICIT
                    newParams = params
                else if @_parameterMode is CLASS.PARAM_MODES.IMPLICIT
                    newParams = args

                # config function given as params
                if params instanceof Function #and params.isParameterFunction is true
                    d = @data[@idx - 1]
                    newParams = params(
                        args
                        {
                            func:   d?.func or d?[0]
                            scope:  d?.scope or d?[1] or null
                            params: d?.params?.slice(0) or d?[2]?.slice(0) or []
                        }
                        @idx
                    )
                try
                    res = func.apply(scope or window, newParams)
                catch error
                    res = null
                    console.error "================================================================="
                    console.error "JSUtils.Sequence::_invokeNextFunction: Given function (at index #{@idx}) threw an Error!"
                    console.warn "Here is the data:", data
                    console.warn "Here is the error:", error
                    console.error "================================================================="

                # ASYNC
                # return value is of type 'CONTEXT': {done: $.post(...), context: {a: 10, b: 20}}
                if res?.done? and res?.context?
                    res.done.done () ->
                        self.idx++
                        self._parameterMode = CLASS.PARAM_MODES.CONTEXT
                        # skip previous result because it should not be of interest (use context if needed)
                        # context property is retrieved in above mode check (if @_parameterMode is CLASS.PARAM_MODES.CONTEXT)
                        self._invokeNextFunction(res)
                # return value is of type ''
                else if res?.done?
                    # the good thing is the done we're adding right here will be called after all previous done methods.
                    res.done () ->
                        self.idx++
                        self._parameterMode = CLASS.PARAM_MODES.IMPLICIT
                        # use callback arguments because it should not be of interest (use context if needed)
                        self._invokeNextFunction(arguments..., res)
                # SYNC
                # only context => synchronous function => nothing to wait for
                else if res?.context
                    @idx++
                    @_parameterMode = CLASS.PARAM_MODES.CONTEXT
                    @_invokeNextFunction(res)
                # no done() and no context => synchronous function => nothing to wait for
                else
                    @idx++
                    @_parameterMode = CLASS.PARAM_MODES.IMPLICIT
                    @_invokeNextFunction(res)
        # no data => we're done doing stuff
        else
            @lastResult = args[0]
            if @_parameterMode is CLASS.PARAM_MODES.CONTEXT
                @lastResult = @lastResult.context

            @_execDoneCallbacks()
        return @

    ###*
    * This method is called when the Sequence has executed all of its functions. It will then start executing all callbacks that previously have been added via `done()` (in the order they were added). No callback receives any parameters.
    * @protected
    * @method _execDoneCallbacks
    * @return This istance. {Sequence}
    * @chainable
    *###
    _execDoneCallbacks: () ->
        @_isDone = true
        cb() for cb in @_doneCallbacks
        return @

    ###*
    * This method adds a callback that will be executed after all functions have returned.
    * @method done
    * @param callback {Function}
    * A function (without parameters).
    * @param context {Object}
    * @param args... {Function}
    * Arguments to be passed to the callback function.
    * @return This istance. {Sequence}
    * @chainable
    *###
    done: (callback, context, args...) ->
        if typeof callback is "function"
            self = @
            # not done => push to queue
            if not @_isDone
                @_doneCallbacks.push () ->
                    return callback.apply(context, args.concat([self.lastResult]))
            # done => execute immediately
            else
                callback.apply(context, args.concat([self.lastResult]))
        return @
