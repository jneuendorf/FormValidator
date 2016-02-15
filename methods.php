<div class="row">
    <div class="col-xs-12">
        <h4>Instance methods</h4>
        <div>
            A FormValidator object has the following instance methods.
            Most of the functionality can be used equally by passing options to the FormValidator's constructor which is recommended for most use cases.
        </div>
        <dl>
            <dt><code>Function deregister_preprocessor(String validation_type) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>Removes the preprocessor for the given <code>validation_type</code> from the set of preprocessors.</dd>

            <dt><code>Function deregister_postprocessor(String validation_type) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>Removes the postprocessor for the given <code>validation_type</code> from the set of postprocessors.</dd>

            <dt><code>Function deregister_validator(String validation_type) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>Removes the validator for the given <code>validation_type</code> from the set of validators.</dd>

            <dt><code>Function get_progress(as_percentage=false) -> Object | Number</code></dt>
            <dd>
                Calculate how much the form has been filled in.
            </dd>

            <dt><code>Function register_preprocessor(String validation_type, Function preprocessor) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>
                Adds the preprocessor for the given <code>validation_type</code> to the set of preprocessors.<br>
                The <code>preprocessor</code> parameter has this signature: <code>Function(String value, jQuery element, String locale) -> String</code>. In this function <code>this</code> refers to the preprocessor object so other preprocessors can easily be called from within each preprocessor.
            </dd>

            <dt><code>Function register_postprocessor(String validation_type, Function postprocessor) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>
                Adds the postprocessor for the given <code>validation_type</code> to the set of postprocessors.<br>
                The <code>postprocessor</code> parameter has this signature: <code>Function(String value, jQuery element, String locale) -> String</code>. In this function <code>this</code> refers to the postprocessor object so other preprocessors can easily be called from within each postprocessor.
            </dd>

            <dt><code>Function register_validator(String validation_type, Function validator) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>
                Adds the validator for the given <code>validation_type</code> to the set of validators.<br>
                The <code>validator</code> parameter has this signature: <code>Function(String value, jQuery element) -> Boolean | String | Object</code>. In this function <code>this</code> refers to the validator object so other validators can easily be called from within each validator.
            </dd>

            <dt><code>Function set_error_target_getter(Function error_target_getter) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>
                The <code>error_target_getter</code> parameter defines the error target for each validated element. The signature is <code>Function(String validation_type, jQuery element, Number index) -> jQuery</code>.<br>
                By default the form validator instance will check the <code>data-fv-error-targets</code> attribute.
            </dd>

            <dt><code>Function set_field_getter(Function field_getter) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>
                The <code>field_getter</code> parameter defines what elements (in the form) will be validated. The signature is <code>Function(jQuery form) -> jQuery</code>.<br>
                If you want the <code>data-fv-ignore-children</code> attribute to have an effect use it here.<br>
                By default all fields with a <code>data-fv-validate</code> attribute will be validated - excluding the ignored children.
            </dd>

            <dt><code>Function set_optional_field_getter(Function optional_field_getter) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>
                The <code>optional_field_getter</code> parameter defines what fields of all fields (defined by the <code>field_getter</code>) are optional. The signature is <code>Function(jQuery fields) -> jQuery</code>.
            </dd>

            <dt><code>Function set_optional_field_getter(Function required_field_getter) -> FormValidator</code> <span class="label label-default">chainable</span></dt>
            <dd>
                The <code>required_field_getter</code> parameter defines what fields of all fields (defined by the <code>field_getter</code>) are required (...mandatory == non-optional). The signature is <code>Function(jQuery fields) -> jQuery</code>.
            </dd>

            <div style="border-radius: 4px; box-shadow: 0px 0px 20px #c1c1c1; margin-top: 30px; padding: 1px 25px 10px 25px;">
                <dt><code>Function validate(Object validation_options={all: false, apply_error_styles: true, focus_invalid: true}) -> Array (of Object)</code></dt>
                <dd>
                    Validates the form and returns a list of errors. Each error looks like this:
                    <pre class="brush: js">
                        {
                            element: validated_element (jQuery),
                            message: error_message (String),
                            required: is_required (Boolean),
                            type: validation_type (String),
                            validator: validator (Function),
                            value: value (String)
                        }
                    </pre>
                    The <code>validator</code> and <code>value</code> properties are not present in dependency errors.<br><br>
                    The <code>validation_options</code> has the following properties:
                    <ul>
                        <li><code>Boolean all</code>: if <code>true</code> force validation on all fields (even if they are declared optional)</li>
                        <li><code>Boolean apply_error_styles</code>: if <code>true</code> add <code>error_classes</code> to and remove them from invalid elements' error targets (otherwise the targets won't be changed)</li>
                        <li><code>Boolean focus_invalid</code>: if <code>true</code> focus the first invalid element (otherwise the focus won't be changed)</li>
                    </ul>
                </dd>
            </div>
        </dl>
    </div>

    <div class="col-xs-12">
        <h4>Class methods</h4>
        <div>
            A FormValidator class has the following class methods.
        </div>
        <dl>
            <dt><code>Function FormValidator.new(jQuery form, Object options)</code></dt>
            <dd>
                Returns a new instance of the FormValidator class. Right now using this method is equal to creating a new instance with <code>new</code>.<br>
                It may provide additional functionality in future versions so using this method is recommended.
            </dd>
        </dl>
    </div>
</div>
