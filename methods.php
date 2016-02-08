<div class="row">
    <div class="col-xs-12">
        <h4>Instance methods</h4>
        <div>
            A FormValidator object has the following instance methods.
            Most of the functionality can be used equally by passing options to the FormValidator's constructor which is recommended for most use cases.
        </div>
        <dl>
            <dt><code>Function deregister_preprocessor(String validation_type)</code></dt>
            <dd>Removes the preprocessor for the given <code>validation_type</code> from the set of preprocessors.</dd>

            <dt><code>Function deregister_postprocessor(String validation_type)</code></dt>
            <dd>Removes the postprocessor for the given <code>validation_type</code> from the set of postprocessors.</dd>

            <dt><code>Functino deregister_validator(String validation_type)</code></dt>
            <dd>Removes the validator for the given <code>validation_type</code> from the set of validators.</dd>

            <dt><code>Function get_progress(as_percentage=false)</code></dt>
            <dd>
                Calculate how much the form has been filled in.
            </dd>

            <dt><code>Function register_preprocessor(String validation_type, Function preprocessor)</code></dt>
            <dd>
                Add the preprocessor for the given <code>validation_type</code> to the set of preprocessors.<br>
                The <code>preprocessor</code> parameter has this signature: <code>Function(String value, jQuery element, String locale) -> String</code>. In this function <code>this</code> refers to the preprocessor object so other preprocessors can easily be called from within each preprocessor.
            </dd>

            <dt><code>Function register_postprocessor(String validation_type, Function postprocessor)</code></dt>
            <dd>
                Add the postprocessor for the given <code>validation_type</code> to the set of postprocessors.<br>
                The <code>postprocessor</code> parameter has this signature: <code>Function(String value, jQuery element, String locale) -> String</code>. In this function <code>this</code> refers to the postprocessor object so other preprocessors can easily be called from within each postprocessor.
            </dd>

            <dt><code>Function register_validator(String validation_type, Function validator)</code></dt>
            <dd>
                Add the validator for the given <code>validation_type</code> to the set of validators.<br>
                The <code>validator</code> parameter has this signature: <code>Function(String value, jQuery element) -> Boolean | String | Object</code>. In this function <code>this</code> refers to the validator object so other validators can easily be called from within each validator.
            </dd>

            <dt><code>Function set_error_target_getter(Function error_target_getter)</code></dt>
            <dd>
                The <code>error_target_getter</code> parameter defines the error target for each validated element. The signature is <code>Function(String validation_type, jQuery element, Number index) -> jQuery</code>.<br>
                By default the form validator instance will check the <code>data-fv-error-targets</code> attribute.
            </dd>

            <dt><code>set_field_getter</code></dt>
            <dd></dd>

            <dt><code>set_optional_field_getter</code></dt>
            <dd></dd>

            <dt><code>set_optional_field_getter</code></dt>
            <dd></dd>

            <dt><code>validate</code></dt>
            <dd></dd>
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
