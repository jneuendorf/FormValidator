<div class="row">
    <p class="col-xs-12">
        The following options can be passed to a new FormValidator as parameter like so:
        <br />
        <code>FormValidator.new(form, options)</code> or <code>FormValidator.new_without_modifier(form, options)</code>
    </p>

    <div class="col-xs-12">
        <h4>Error handling</h4>
        <dl class="">
            <!-- build_mode -->
            <!-- constraint_validators -->

            <dt>build_mode</dt>
            <dd>
                <code>String</code>
                <br> Defines how error message are created.
                <br> Must be either the options defined in <code>FormValidator.BUILD_MODES</code>.
                <br> Default is <code>FormValidator.BUILD_MODES.DEFAULT</code>.
            </dd>

            <dt>constraint_validators</dt>
            <dd>
                <code>Object</code>
                <br> Can be used to add or override constraint validators to the predefined set.
                <br> See <a class="goto" href="#" data-href="#constraints">constraints</a> for more details.
            </dd>

            <dt>dependency_error_classes</dt>
            <dd>
                <code>String</code> (CSS class names, semicolon separated)
                <br> Defines what CSS classes will be applied to the error target(s) of the fields the current field depends on (if any of the dependencies are invalid).
                <br> Default is <code>&quot;&quot;</code> (which means invalid fields won't be changed).<br>
                Take a look at example 3 on the <a class="goto" href="#" data-href="#demos">demos</a> page to see how dependencies work.
            </dd>

            <!-- dependency_change_action -->

            <dt>error_classes</dt>
            <dd>
                <code>String</code> (CSS class names, semicolon separated)
                <br> Defines what CSS classes will be applied to the error target(s) of an invalid field.
                <br> Default is <code>&quot;&quot;</code> (which means invalid fields won't be changed).
            </dd>

            <dt>error_mode</dt>
            <dd>
                <code>FormValidator.ERROR_MODES (String)</code>
                <br> Defines how error messages are generated in general. Can be either of these values:
                <ul>
                    <li>
                        <code>FormValidator.ERROR_MODES.SIMPLE</code><br>
                        This mode transforms all <code>error_message_types</code> (returned from the validator) to the simplest corresponding error message. That means that the messages are independent of any<code>constraint attributes</code>. For example, if a field is validated as <code>number</code> and is invalid (no matter what combination of <code>constraint attributes</code> it has) the <code>error_message_type</code> will be <code>"number"</code> (even if it techniqually valid but violates constraints).
                    </li>
                    <li>
                        <code>FormValidator.ERROR_MODES.NORMAL</code><br>
                        The <code>error_message_type</code> (returned from the validator) is untouched.
                    </li>
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
                        <br>The DOM will not be modified. The <code>validate</code> function returns an <code>Array of Object</code>s where each of those objects looks like this:<br>
                        <pre class="brush: js">
                            {
                                element: validated_field,
                                message: error_message,
                                required: validated_field.attr("data-fv-optional") !== "true",
                                type: validation_type,
                                validator: validator_function,
                                value: postprocessed_validated_field_value || preprocessed_validated_field_value || validated_field_value
                            }
                        </pre>
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

            <!-- process_errors -->
            <!-- success_classes -->
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

            <dt>group</dt>
            <dd>
                <code>Function(jQuery fields) -> Array (of Array of jQuery)</code>
                <br> Creates groups from all form fields. Can be used for advanced progress counting.
                <!-- TODO: add detailed explanation -->
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
                </pre> where <code>POSTPROCESSOR_N</code> is a <code>Function(String value, jQuery element, String locale) -> String</code>.
                <br> Can be used to override or define postprocessors. They are used modify the form field's value after the validation happened. The <code>value</code> is either the input's original or preprocessed value.<br>
                For example, a value could be auto-corrected i.e. the numeric string <code>" 1.34  "</code> would become <code>"1.34"</code> in the according field (when valid).
            </dd>
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
                </pre> where <code>PREPROCESSOR_N</code> is a <code>Function(String value, jQuery element, String locale) -> String</code>.
                <br> Can be used to override or define preprocessors. They are used modify the form field's value before the validation happens.<br>
                The predefined preprocessors currently exist for <code>number</code> and <code>integer</code>. Currently, for both types the comma will be interpreted as decimal points when the locale <code>de</code> is used.
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
                    <li><code>Boolean all</code>: if <code>true</code> force validation on all fields (even if they are declared optional)</li>
                    <li><code>Boolean apply_error_styles</code>: if <code>true</code> add <code>error_classes</code> to and remove them from invalid elements' error targets (otherwise the targets won't be changed)</li>
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
