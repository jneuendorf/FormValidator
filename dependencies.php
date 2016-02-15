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
            The change action can be anything if you use JavaScript.<br>
            However, usually you want to toggle the state of <var>F</var> on each event. So there is a list of predefined toggling changes. The naming for the actions is based on <i>"do something whenever the dependencies are fulfilled - otherwise reverse whatever has been done before"</i>. Here we go:
            <ul>
                <li>
                    <code>fade</code> *<br>
                    Fade the element in (on <code>onDependenciesValid</code>) or out (on <code>onDependenciesInvalid</code>).<br>
                    See jQuery's <code>fadeIn</code> and <code>fadeOut</code>.
                </li>
                <li>
                    <code>opacity</code> *<br>
                    Same as fade but the <code>display</code> style is not changed.
                </li>
                <li>
                    <code>show</code> *<br>
                    See jQuery's <code>show</code> and <code>hide</code>.
                </li>
                <li>
                    <code>slide</code> *<br>
                    See jQuery's <code>slideDown</code> and <code>slideUp</code>.
                </li>
                <li>
                    <code>enable</code><br>
                    Change the <code>disabled</code> attribute (<code>disabled</code> on <code>onDependenciesInvalid</code>).
                </li>
                <li>
                    <code>display</code><br>
                    The same as <code>show</code> but without animnation (changes the <code>display</code> style).
                </li>
            </ul>
            * The duration used for the animation is jQuery's default value (currently <code>400&nbsp;ms</code>). It is hardcoded though and will therefore not change automatically if jQuery changes it.
        </p>
    </div>
</div>
