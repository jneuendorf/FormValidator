<dl>
    <dt><code>data-fv-blacklist</code></dt>
    <dd>
        <code>String</code><br>
        Define a set of characters that the element's validation value must not contain.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-dependency-action-targets</code></dt>
    <dd>
        <code>String</code> (targets, space separated)
        <br> Can be used to customize which CSS classes will be applied to the error target(s) of a field with dependencies (if any of the dependencies are invalid).
        <br> Default is whatever is defined for the <code>error_classes</code> property.
    </dd>

    <dt><code>data-fv-dependency-error-classes</code></dt>
    <dd>
        <code>String</code> (selectors and/or target names, semicolon separated)
        <br> Defines a list of targets which will be affected by the <code>dependency_action</code> option. To find out how a target can be defined see <a href="#" data-toggle="modal" data-target="#target_finding_modal">target finding</a>.
    </dd>

    <dt><code>data-fv-dependency-mode</code></dt>
    <dd>
        <code>String -> "all" or "any"</code>
        <br> Defines whether <strong>all</strong> dependencies need to be fulfilled for the current element to be able to be valid or if one (<strong>any</strong>) is sufficient.
        <br> Default is <code>"all"</code>.<br>
        For a more detailed explanation see <a class="goto" href="#" data-href="#dependencies">dependencies</a>.
    </dd>

    <dt><code>data-fv-depends-on</code></dt>
    <dd>
        <code>String</code> (selectors and/or target names, semicolon separated)<br>
        Defines what targets have to be valid for the current element to be valid (additionally to the actual validation). To find out how a target can be defined see <a href="#" data-toggle="modal" data-target="#target_finding_modal">target finding</a>.
    </dd>

    <dt><code>data-fv-enforce-max-length</code></dt>
    <dd>
        <code>Boolean</code><br>
        An option for <code>data-fv-max-length</code>.
        Define the whether to shorten the validation value of an element if it exceeds the defined maximum length.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-enforce-min-length</code></dt>
    <dd>
        <code>Boolean</code><br>
        An option for <code>data-fv-min-length</code>.
        Define the whether to extend the validation value of an element if it's shorter than the defined minimum length.
        A <code>.</code> will be used to fill up the value to the according length.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-error-classes</code></dt>
    <dd>
        <code>String</code> (CSS class names, space separated)
        <br> Defines what CSS classes will be applied to the error target(s) of an invalid field.
        <br> Default is <code>&quot;&quot;</code> (which means invalid fields won't be changed).
    </dd>

    <dt><code>data-fv-error-targets</code></dt>
    <dd>
        <code>String</code> (selectors and/or target names, semicolon separated)<br>
        Defines a list of targets which will get the defined <code>data-fv-error-classes</code> if the current element is invalid. To find out how a target can be defined see <a href="#" data-toggle="modal" data-target="#target_finding_modal">target finding</a>.
    </dd>

    <dt><code>data-fv-group</code></dt>
    <dd>
        <code>String</code><br>
        Assigning the current element to a logical group - the value can be any string.<br>
        By assigning (potentially) all form fields to groups this defines a set of group for the form. This is used for progress counting.<br>
        It will not be used if the <code>group</code> option was given to the FormValidator's constructor.<br>
        To see how counting works see the <code>get_progress</code> method.
    </dd>

    <dt><code>data-fv-ignore-children</code></dt>
    <dd>
        <code>String</code> (any value)<br>
        This attribute can be used <i>without a value</i>. When present the default <code>field_getter</code> will ignore the elements' descendants. Therefore they won't be validated. The default <code>field_getter</code> is used unless you define your own (by passing the <code>field_getter</code> option to the constructor).
    </dd>

    <dt><code>data-fv-include-max</code></dt>
    <dd>
        <code>Boolean</code><br>
        An option for <code>data-fv-max</code>.
        Define whether to include the defined <code>data-fv-max</code> or not.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-include-min</code></dt>
    <dd>
        <code>Boolean</code><br>
        An option for <code>data-fv-min</code>.
        Define whether to include the defined <code>data-fv-min</code> or not.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-max</code></dt>
    <dd>
        <code>Number</code><br>
        Define the maximum value for an element.<br>
        By default this value will be the greatest valid value. To exclude the maximum see <code>data-fv-include-max</code>.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-max-length</code></dt>
    <dd>
        <code>Number</code><br>
        Define the maximum length for the validation value of an element.<br>
        This value will be the greatest valid value.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-min</code></dt>
    <dd>
        <code>Number</code><br>
        Define the minimum value for an element.<br>
        By default this value will be the smallest valid value. To exclude the minimum see <code>data-fv-include-min</code>.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-min-length</code></dt>
    <dd>
        <code>Number</code><br>
        Define the minimum length for the validation value of an element.<br>
        This value will be the smallest valid value.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-name</code></dt>
    <dd>
        <code>String</code> (no space allowed)<br>
        Add a name property to the current element. It can be used for being identified as a target (see <a href="#" data-toggle="modal" data-target="#target_finding_modal">target finding</a>) and for supplying a <code>name</code> variable in the error message.
    </dd>

    <dt><code>data-fv-optional</code></dt>
    <dd>
        <code>Boolean</code><br>
        When <code>true</code> the field will be skipped if it has an empty value, is a checkbox, or is a radio button.
    </dd>

    <dt><code>data-fv-output-preprocessed</code></dt>
    <dd>
        <code>Boolean</code><br>
        If this value is <code>true</code>, there is a preprocessor, and there is no postprocessor for the element's type the element's value will be replaced to represent whatever was created by the preprocessor. This can be used for auto correcting numbers (i.e. remove spaces).
    </dd>

    <dt><code>data-fv-postprocess</code></dt>
    <dd>
        <code>Boolean</code><br>
        Define whether to apply the postprocessor for the element's type to the element's value or not.
    </dd>

    <dt><code>data-fv-preprocess</code></dt>
    <dd>
        <code>Boolean</code><br>
        Define whether to apply the preprocessor for the element's type to the element's value or not.
    </dd>

    <dt><code>data-fv-real-time</code></dt>
    <dd>
        <code>String</code> (any value)<br>
        This attribute can be used <i>without a value</i>. This attribute can be defined on the form element which is supposed to be validated. All descendants of the form with a <code>data-fv-validate</code> attribute will be validated on the fly whenever something changes (on change, click, and keyup).
    </dd>

    <dt><code>data-fv-regex</code></dt>
    <dd>
        <code>String</code><br>
        Define a regular expression that the element's validation value must not match.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-regex-flags</code></dt>
    <dd>
        <code>String</code><br>
        An option for <code>data-fv-regex</code>. Define a what flags to use for the defined regular expression.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>

    <dt><code>data-fv-start</code></dt>
    <dd>
        <code>String</code> (target)<br>
        Elements with this attribute will automatically trigger the validation of the form that corresponds to this value (which must be a valid target). To find out how a target can be defined see <a href="#" data-toggle="modal" data-target="#target_finding_modal">target finding</a>.
    </dd>

    <dt><code>data-fv-validate</code></dt>
    <dd>
        <code>String</code> (validation type)<br>
        Define what validator to use for the current element. Possible values are:
        <ul>
            <li><code>checkbox</code></li>
            <li><code>email</code></li>
            <li><code>integer</code></li>
            <li><code>number</code></li>
            <li><code>phone</code></li>
            <li><code>radio</code></li>
            <li><code>select</code></li>
            <li><code>text</code> (also see <code>data-fv-min-length</code> and <code>data-fv-max-length</code>)</li>
        </ul>
        For more details see <a class="goto" href="#" data-href="#validators">validators</a>.
    </dd>

    <dt><code>data-fv-whitelist</code></dt>
    <dd>
        <code>String</code><br>
        Define a set of characters that the element's validation value must contain.<br>
        For more details see <a class="goto" href="#" data-href="#constraints">constraints</a>.
    </dd>
</dl>
