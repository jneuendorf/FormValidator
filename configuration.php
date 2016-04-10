<h4>List of configuration constants</h4>
<p>
    The following configuration constants are attached to the <code>FormValidator</code> class. They can be used as parameters for functions that expect some parameters to have certain values.<br>
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
<h4>Configuring internal parameters (advanced!)</h4>
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
                    <code>constraint_validator_options_in_locale_key (Object (String to Boolean|Function))</code><br>
                    Defines when to include a constraint-validator option in the locale key. Instead of a Boolean value also a function can be set as value. It must then look like
                    <code class="quote">function(String locale) -> Boolean</code>
                    One example: You want a custom error message for the constraint <code>max</code> with the <code>include_max</code> option and for some reason you don't want to have the <code>include_max</code> part in the error message for only <code>lang_A</code> but for all other languages. In that case you would modify the object like so:

                    <pre class="brush: js">
                        constraint_validator_options_in_locale_key.include_max = function(locale) {
                            if (locale === 'lang_A') {
                                return false;
                            }
                            return true;
                    </pre>
                </li>
                <li>
                    <code>constraint_validator_options (Object (String to Array (of String)))</code><br>
                    Defines what constraint-validator options are compatible with a constraint validator.
                    The options are accessible in the according constraint validator in the (3rd) <code>options</code> parameter.<br>
                    By default it loosk like this:
                    <pre class="brush: js">
                    {
                        max: [&quot;include_max&quot;],
                        max_length: [&quot;enforce_max_length&quot;],
                        min: [&quot;include_min&quot;],
                        min_length: [&quot;enforce_min_length&quot;],
                        regex: [&quot;regex_flags&quot;]
                    }</pre>
                </li>
                <li>
                    <code>locale_message_builders</code><br>
                    By default no locale-message builder is defined. If you define one it will be preferred over the message builder of the current build mode. For each locale there can be 1 locale-message builder for each build mode.<br>
                    For more details <code>git checkout</code> the source code or contact me.
                </li>
                <li>
                    <code>message_builders</code><br>
                    A message builder is defined for each of the <code>FormValidator.BUILD_MODES</code>. They take the data from a <code>MessageDataCreator</code> and stringify it in some way.<br>
                    For more details <code>git checkout</code> the source code or contact me.
                </li>
                <li>
                    <code>message_data_creators</code><br>
                    A message-data creator is defined for each of the <code>FormValidator.VALIDATION_PHASES</code>. They take the errors of an element and generate all the necessary data for building an error message from it.<br>
                    For more details <code>git checkout</code> the source code or contact me.
                </li>
            </ul>
        </dd>
    </dl>
</p>
