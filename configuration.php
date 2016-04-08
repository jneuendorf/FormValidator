<h4>List of constants</h4>
The following configuration constants are attached to the <code>FormValidator</code> class.<br>
Each of them has a <code>DEFAULT</code> property.

<dl>
    <dt><code>ERROR_MODES</code></dt>
    <dd>
        Defines the degree of detail for error messages.
        <ul class="spaced">
            <li>
                <code>NORMAL</code> (default)<br>
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
                <code>NONE</code> (default)<br>
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
                <code>NONE</code> (default)<br>
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

    <dt><code>BUILD_MODES</code></dt>
    <dd>
        Defines how error message are created.
        <ul class="spaced">
            <li>
                <code>ENUMERATE</code> (default)<br>
            </li>
            <li>
                <code>LIST</code><br>
            </li>
            <li>
                <code>SENTENCE</code><br>
            </li>
        </ul>
    </dd>

<!--
EXPOSED_CONSTANTS = {
  VALIDATION_PHASES: VALIDATION_PHASES,
  BUILD_MODES: BUILD_MODES,
  ERROR_MESSAGE_CONFIG: ERROR_MESSAGE_CONFIG,
  PROGRESS_MODES: PROGRESS_MODES
};
 -->

</dl>
