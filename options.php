<div class="row">
    <p class="col-xs-12">
        The following options can be passed to a new FormValidator object like so:
        <br />
        <code>new FormValidator(form, options)</code>
    </p>

    <div class="col-xs-12">
        <h4>Error handling</h4>
        <dl class="">
            <dt>create_dependency_error_message</dt>
            <dd>
                <code>Function(String locale, Array (of Object) dependency_errors) -> String</code>
                <br> Can be used to customize what dependency error messages look like.
                <br> The default message is whatever error message is defined for the current locale at the key <code>dependency</code>.
            </dd>

            <dt>dependency_error_classes</dt>
            <dd>
                <code>String</code> (CSS class names, space separated)
                <br> Can be used to customize which CSS classes will be applied to the error target(s) of a field with dependencies (if any of the dependencies are invalid).
                <br> Default is whatever is defined for the <code>error_classes</code> property.
            </dd>

            <dt>error_classes</dt>
            <dd>
                <code>String</code> (CSS class names, space separated)
                <br> Defines what CSS classes will be applied to the error target(s) of an invalid field.
                <br> Default is <code>&quot;&quot;</code> (which means invalid fields won't be changed).
            </dd>

            <dt>error_messages</dt>
            <dd>
                <code>Object</code>. It looks like this:
                <br>
                <pre class="brush: js">
                    {
                        locale1: {
                            error_type1: MESSAGE_1_1,
                            ...,
                            error_typeN: MESSAGE_1_N
                        },
                        locale2: {...}
                    }
                </pre> where <code>MESSAGE_X_Y</code> is either a <code>String</code> or a <code>Function(String locale, Object parameters) -> String</code>. The <code>parameters</code> argument depends on the error returned by the validator.
                <br> Can be used to override the default messages object (at <code>FormValidator.error_messages</code>).
                <br> The object is merged into the predefined so customizing single message types (even for different locales) is possible.
            </dd>

            <dt>error_mode</dt>
            <dd>
                <code>FormValidator.ERROR_MODES (String)</code>
                <br> Defines how error messages are generated in general. Can be either of these values:
                <ul>
                    <li><code>FormValidator.ERROR_MODES.SIMPLE</code></li>
                    <li><code>FormValidator.ERROR_MODES.NORMAL</code></li>
                    <li><code>FormValidator.ERROR_MODES.DEFAULT (== FormValidator.ERROR_MODES.NORMAL)</code> (this value is the default obviously)</li>
                </ul>
            </dd>

            <dt>error_output_mode</dt>
            <dd>
                <code>FormValidator.ERROR_OUTPUT_MODES (String)</code>
                <br> Defines how error messages are shown. Can be either of these values:
                <ul>
                    <li>
                        <code>FormValidator.ERROR_OUTPUT_MODES.BELOW</code>
                        <br> Prints an error message below the according validated form field.
                    </li>
                    <li>
                        <code>FormValidator.ERROR_OUTPUT_MODES.BOOTSTRAP_POPOVER</code>
                        <br> Puts an error message into a bootstrap popover that shows when hovering over the according form field.
                        <br> Of course, this only works when Boostrap is included.
                    </li>
                    <li>
                        <code>FormValidator.ERROR_OUTPUT_MODES.NONE</code>
                        <br> Don't show any errors! Handle them yourself.
                    </li>
                    <li><code>FormValidator.ERROR_OUTPUT_MODES.DEFAULT (== FormValidator.ERROR_OUTPUT_MODES.NONE)</code> (this value is the default obviously)</li>
                </ul>
            </dd>

            <dt>error_target_getter</dt>
            <dd>
                <code>Function(String validation_type, jQuery element, Number index) -> jQuery | String</code>
                <br> Can be used to define the error target(s) for a validated field.
                <br> If a <code>jQuery</code> set is returned all the contained elements will be the targets.
                <br> If a <code>String</code> is returned it is parsed the same as if it was set using the <code>data-fv-error-targets</code> attribute. See <a href="#" data-toggle="modal" data-target="#target_finding_modal">target finding</a>.
            </dd>
        </dl>
    </div>

    <div class="col-xs-12">
        <h4>Validation handling</h4>
        <dl class="">
            <dt>field_getter</dt>
            <dd>
                <code>Function(jQuery form) -> jQuery</code>
                <br> Can be used to define the set of form fields that are relevant to the FormValidator.
            </dd>
            <dt>locale</dt>
            <dd>
                Define what locale is used. This property is relevant for:
                <ul>
                    <li>creating error message</li>
                    <li>pre- and postprocessing values</li>
                </ul>
            </dd>

            <dt>optional_field_getter</dt>
            <dd>
                <code>Function(jQuery fields) -> jQuery</code>
                <br> Can be used to define the subset of all fields (see <code>field_getter</code>) that contains all the fields that are optional. Those fields will only be validated if they are non-empty.
            </dd>

            <dt>group</dt>
            <dd>
                <code>Function(jQuery fields) -> Array (of Array of jQuery)</code>
                <br> Creates groups from all form fields. Can be used for advanced progress counting.
                <!-- TODO: add detailed explanation -->
            </dd>

            <dt>preprocessors</dt>
            <dd>
                <code>Object</code>. It looks like this:
                <br>
                <pre class="brush: js">
                    {
                        validation_type1: PREPROCESSOR_1,
                        ...,
                        validation_typeN: PREPROCESSOR_N
                    }
                </pre> where <code>PREPROCESSOR_N</code> is a <code>Function(String locale, jQuery element, String locale) -> String</code>.
                <br> Can be used to override or define preprocessors. They are used modify the form field's value before the validation happens. The predefined preprocessors currently exist for <code>number</code> and <code>integer</code> so the different
                dot notation will be validated correctly (i.e. <code>de + "1,2" == en + "1.2"</code>).
            </dd>

            <dt>postprocessors</dt>
            <dd>
                <code>Object</code>. It looks like this:
                <br>
                <pre class="brush: js">
                    {
                        validation_type1: POSTPROCESSOR_1,
                        ...,
                        validation_typeN: POSTPROCESSOR_N
                    }
                </pre> where <code>POSTPROCESSOR_N</code> is a <code>Function(String locale, jQuery element, String locale) -> String</code>.
                <br> Can be used to override or define postprocessors. They are used modify the form field's value after the validation happened. For example, a value could be auto-corrected so the numeric string <code>" 1.34  "</code> would become <code>"1.34"</code>                in the according field (when valid).
            </dd>
            </dd>

            <dt>required_field_getter</dt>
            <dd>
                <code>Function(jQuery fields) -> jQuery</code>
                <br> Can be used to define the subset of all fields (see <code>field_getter</code>) that contains all the fields that are required. Those fields will always be validated.
            </dd>

            <dt>validation_options</dt>
            <dd>
                Specify options for the validation:
                <ul>
                    <li><code>all</code>: force validation on all fields (even if they are declared optional)</li>
                    <li><code>apply_error_styles</code>: whether or not to add the <code>error_classes</code> to invalid elements or remove them from valid elements, respectively</li>
                </ul>
            </dd>

            <dt>validators</dt>
            <dd>
                Set of validators that correspond to a validation type (<code>data-fv-validate</code>).
                <br> They can be used to override existing validators or define new ones.
                <br> The predefined validators are:
                <ul>
                    <li><code>checkbox</code></li>
                    <li><code>email</code></li>
                    <li><code>integer</code></li>
                    <li><code>number</code></li>
                    <li><code>phone</code></li>
                    <li><code>radio</code></li>
                    <li><code>select</code></li>
                    <li><code>text</code></li>
                </ul>
            </dd>

        </dl>
    </div>
</div>
