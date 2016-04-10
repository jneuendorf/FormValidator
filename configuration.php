<h4>List of configuration constants</h4>
<p>
    The following configuration constants are attached to the <code>FormValidator</code> class.<br>
    If it has a <code>DEFAULT</code> property it points to the according constant marked with <span class="label label-option">default</span>.<br>
    Most of them simulate <code>enum</code> of other languages but some of them can be used as variables. Those are marked with <span class="label label-var">variable</span>.
</p>

<dl>
    <dt><code>BUILD_MODES</code></dt>
    <dd>
        Defines how error message are created.
        <ul class="spaced">
            <li>
                <code>ENUMERATE</code> <span class="label label-option">default</span><br>
                Combines multiple errors of the same validation phase to an enumeration to be as close to the natural language as possible. Another advantage is that the message will be as short as possible which is preferable especially for mobile devices.
            </li>
            <li>
                <code>LIST</code><br>
                The messages are generated like <code>SENTENCE</code> but are formatted as HTML <code>ul</code> list.
            </li>
            <li>
                <code>SENTENCE</code><br>
                Unlike <code>ENUMERATE</code> each error is put into a single sentence. This is more verbose but can be formatted more easily.
            </li>
        </ul>
    </dd>

    <dt><code>DEPENDENCY_CHANGE_ACTIONS</code></dt>
    <dd>
        Defines how a change of the validation state of a dependency is visualized.<br>
        For the details see <a class="goto" href="#" data-href="#dependencies">dependencies</a>.
        <ul class="spaced">
            <li>
                <code>DISPLAY</code>
            </li>
            <li>
                <code>ENABLE</code>
            </li>
            <li>
                <code>FADE</code>
            </li>
            <li>
                <code>NONE</code> <span class="label label-option">default</span><br>
                No animation.
            </li>
            <li>
                <code>OPACITY</code>
            </li>
            <li>
                <code>SHOW</code>
            </li>
            <li>
                <code>SLIDE</code>
            </li>
        </ul>
    </dd>

    <dt><code>DEPENDENCY_CHANGE_ACTION_DURATION</code> <span class="label label-var">variable</span></dt>
    <dd>
        Defines the global duration for all dependency change actions. This value can be overriden for each field using the <code>data-fv-dependency-action-duration</code> attribute.<br>
        The value of this variable is <code>400 ms</code>.
    </dd>

    <dt><code>ERROR_MODES</code></dt>
    <dd>
        Defines the degree of detail for error messages.
        <ul class="spaced">
            <li>
                <code>NORMAL</code> <span class="label label-option">default</span><br>
                The message is created based on the <code>error_message_type</code> returned by the validator.
            </li>
            <li>
                <code>SIMPLE</code><br>
                The message is based on the base type of the <code>error_message_type</code> returned by the validator. E.g. invalid e-mail values will always produce the same message (like 'invalid e-mail address') instaed of an exact message (like 'missing @ symbol').
                <!-- This mode transforms all <code>error_message_types</code> (returned from the validator) to the simplest corresponding error message. That means that the messages are independent of any<code>constraint attributes</code>. For example, if a field is validated as <code>number</code> and is invalid (no matter what combination of <code>constraint attributes</code> it has) the <code>error_message_type</code> will be <code>"number"</code> (even if it techniqually valid but violates constraints). -->
            </li>
        </ul>
    </dd>

    <dt><code>ERROR_OUTPUT_MODES</code></dt>
    <dd>
        Defines how error message are visualized.
        <ul class="spaced">
            <li>
                <code>BELOW</code><br>
                Creates a container <code>&lt;div class=&quot;fv-error-message&quot; /&gt;</code> containing the message right behind the element (in the DOM).
            </li>
            <li>
                <code>NONE</code> <span class="label label-option">default</span><br>
                Well...nothing is put into the DOM. That way you can take of everything yourself.
            </li>
            <li>
                <code>POPOVER</code> (required Bootstrap)<br>
                Shows a <a href="http://getbootstrap.com/javascript/#popovers">Bootstrap popover</a> on focus, hides it on blur and toggles it on click.
            </li>
            <li>
                <code>TOOLTIP</code> (required Bootstrap)<br>
                Show a <a href="http://getbootstrap.com/javascript/#tooltips">Bootstrap tooltip</a> on hover.
            </li>
        </ul>
    </dd>

    <dt><code>PROGRESS_MODES</code></dt>
    <dd>
        Defines how each element of the array looks like.
        <ul class="spaced">
            <li>
                <code>PERCENTAGE</code> <span class="label label-option">default</span><br>
                Each element is a <code>Number</code>.
            </li>
            <li>
                <code>ABSOLUTE</code><br>
                Each element is an <code>Object</code> of the form <code>{count: Number, total: Number}</code>.
            </li>
        </ul>
    </dd>

    <dt><code>VALIDATION_PHASES</code></dt>
    <dd>
        Defines all of the validation phases. Those constants can be used to group error objects without needing to know the constant value.
        <ul class="spaced">
            <li>
                <code>DEPENDENCIES</code>
            </li>
            <li>
                <code>VALUE</code>
            </li>
            <li>
                <code>CONSTRAINTS</code>
            </li>
        </ul>
    </dd>
</dl>
<br>
<h4>Configuring internal parameters (advanced)</h4>
<p>
    If you want to change some of <code>FormValidator's</code> behavior without modifying its source code directly you can use the <code>FormValidator.configure</code> method:
    <dl>
        <dt><code>Function FormValidator.configure(Function callback) -> FormValidatorClass</code> <span class="label label-option">chainable</span></dt>
        <dd>
            The <code>callback</code> function parameter has the signature <code>Function callback(Object configurations)</code>.<br>
            The <code>configurations</code> object is a set of internal variables that influence the behavior of the <code>FormValidator</code> and are made accessible only in that way.<br>
            This is the list of internal variables:
            <ul>
                <li>
                    <code>constraint_validator_groups (Array (of Array of String))</code><br>
                    Defines which constraint validators are logically connected (and thus can potentially be combined to a new error message. For example, if you wanted to have a special error message in case the 2 constraint validators <code>blacklist</code> and <code>whitelist</code> are violated you would add an according group with<br>
                    <code class="quote">constraint_validator_groups.push([&quot;blacklist&quot;, &quot;whitelist&quot;]);</code>
                    Now you would add a new entry <code>constraint_blacklist_whitelist</code> in the <code>locales</code> variables and it will be used.<br>
                    The groups defined in that array must be disjoint.
                </li>
                <li>
                    <code>constraint_validator_options_in_locale_key</code><br>
                    <!-- # define when to include a constraint validator option in the locale key (and when not - if not matching the below value)
                    # value can also be: function(String locale) -> Mixed value
                    # i.e. for include_max a function could be defined if different locales formulate the according error message differently:
                    # - EN could be like 'the value is not less than {{max}}' (max is not included in valid range => locale key = "constraint_max") and
                    # - DE could be like 'is not less than or equal to {{max}}' (max is included in valid range => locale key = "constraint_max_include_max")
                    # => in that case the function would look like:
                    # (locale) ->
                    #   if locale is "en"
                    #       return false
                    #   if locale is "de"
                    #       return true
                    #   # all other locales...
                    #   return something -->
                </li>
                <li>
                    <code>constraint_validator_options</code><br>
                    <!-- # define which constraint-validator options are compatible with a constraint validator
                    # they are accessible in the according constraint validator in the options object (last parameter)
                    # used in _validate_constraints()
                    # => constraint validator options:
                    #    - data-fv-include-max
                    #    - data-fv-include-min
                    #    - data-fv-regex-flags -->
                </li>
                <li>
                    <code>locale_message_builders</code><br>

                </li>
                <li>
                    <code>message_builders</code><br>

                </li>
                <li>
                    <code>message_data_creators</code><br>

                </li>
            </ul>
        </dd>
    </dl>
</p>
