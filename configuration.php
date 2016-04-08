<h4>List of constants</h4>
The following configuration constants are attached to the <code>FormValidator</code> class.<br>
If it has a <code>DEFAULT</code> property it points to the according constant marked with <span class="label label-option">default</span>.

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
