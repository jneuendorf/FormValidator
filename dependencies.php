<div class="row">
    <div class="col-xs-12">
        <p>
            Dependencies can be used on any form field - let's pick one and call it <var>F</var>.
            The dependencies define what other form fields need to be valid before <var>F</var> can be valid (no matter the content).
        </p>
        <p>
            It is possible to change <var>F</var> whenever its dependencies are "valid enough".
            With "valid enough" I mean that either
            <ul>
                <li>
                    <strong>all</strong> of <var>F</var>'s dependencies are fulfilled (<code>onDependenciesValid</code>) or
                </li>
                <li>
                    <strong>any</strong> of <var>F</var>'s dependencies is fulfilled (<code>onDependenciesInvalid</code>).
                </li>
            </ul>
            Whether <strong>all</strong> or <strong>any</strong> is evaluated can be defined with the <code>data-fv-dependency-mode</code> attribute (either of <code>["all", "any"]</code>, default is <code>all</code>).
        </p>
        <p>
            The change action can be anything if you use JavaScript with the <code>dependency_change_action</code> option.<br>
            However, usually you want to toggle the state of <var>F</var> on each event. So there is a list of predefined toggling changes. The naming for the actions is based on <i>"do something whenever the dependencies are fulfilled - otherwise reverse whatever has been done before"</i>. Here we go:
            <ul>
                <li>
                    <code>DEPENDENCY_CHANGE_ACTIONS.FADE</code> *<br>
                    Fade the element in (on <code>onDependenciesValid</code>) or out (on <code>onDependenciesInvalid</code>).<br>
                    See jQuery's <code>fadeIn</code> and <code>fadeOut</code>.
                </li>
                <li>
                    <code>DEPENDENCY_CHANGE_ACTIONS.OPACITY</code> *<br>
                    Same as fade but the <code>display</code> style is not changed.
                </li>
                <li>
                    <code>DEPENDENCY_CHANGE_ACTIONS.SHOW</code> *<br>
                    See jQuery's <code>show</code> and <code>hide</code>.
                </li>
                <li>
                    <code>DEPENDENCY_CHANGE_ACTIONS.SLIDE</code> *<br>
                    See jQuery's <code>slideDown</code> and <code>slideUp</code>.
                </li>
                <li>
                    <code>DEPENDENCY_CHANGE_ACTIONS.ENABLE</code><br>
                    Change the <code>disabled</code> attribute (<code>disabled</code> on <code>onDependenciesInvalid</code>).
                </li>
                <li>
                    <code>DEPENDENCY_CHANGE_ACTIONS.DISPLAY</code><br>
                    The same as <code>show</code> but without animnation (changes the <code>display</code> style).
                </li>
            </ul>
            * The duration used for the animation is jQuery's default value (currently <code>400&nbsp;ms</code>). It is hardcoded though and will therefore not change if jQuery changes it. It can be overriden using the <code>data-fv-dependency-action-duration</code> attribute.<br>
            To override the duration for a single field use the attribute on that element. To override it for all fields use the attribute on the form itself (or whatever <code>form</code> parameter you passed to the new <code>FormValidator</code>).
        </p>

        <h4>Cycle detection</h4>
        <p>
            <strong>There is none!</strong><br>
            When caching the fields are topologically sorted. The sorting method will throw an Error if there are any cyclic dependencies. But of course, you should try to avoid them in the first place.<br>
            <br>
            Since dependencies are defined as a list of targets you could use a selector to find a dependency's element (or multiple). In that case you should be careful to match only the wanted elements.<br>
            Using the <code>data-fv-name</code> attribute should be easier and safer to use and is therefore recommended.
        </p>
    </div>
</div>
