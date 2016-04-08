<div class="row">
    <div class="col-xs-12">
        <h4>Instance methods</h4>
        <div>
            A FormValidator object has the following instance methods.
            Most of the functionality can be used equally by passing options to the FormValidator's constructor which is recommended for most use cases.
        </div>
        <dl>
            <dt><code>Function cache() -> FormValidator</code> <span class="label label-option">chainable</span></dt>
            <dd>
                Cache all kinds of stuff that is needed for validation. Some caching will be done lazily (even after calling this method). Using this method makes sense for real time validation because that way the form data can be cached e.g. right after the has loaded so all validations will be equally fast.
            </dd>

            <dt><code>Function get_progress(Object options={mode: PROGRESS_MODES.DEFAULT, recache: false}) -> Array (of Number | Object)</code></dt>
            <dd>
                This method calculates how much the form has been filled in. The returned array contains the progress for each group (defined with the <code>group</code> option or defined using the <code>data-fv-group</code> attribute). The array also has a property called <code>average</code> that equals the overall form progress.<br>
                Depending on the <code>mode</code> the array elements are either <code>Numbers</code> or <code>Objects</code>. The <code>PROGRESS_MODES.PERCENTAGE</code> version uses decimals between 0 and 1, the objects in the <code>PROGRESS_MODES.ABSOLUTE</code> look like <code>{count: x, total: y}</code>.<br>
                <br>
                This is how the calculation works. It depends on the 3 kinds of groups:
                <ol>
                    <li>
                        containing only required fields<br>
                        <var>progress = valid_fields / num_fields</var>
                    </li>
                    <li>
                        containing only optional fields<br>
                        <var>progress = either 1 if at least 1 field is valid, 0 otherwise</var>
                    </li>
                    <li>
                        containing both kinds of fields<br>
                        <var>progress = valid_required_fields / num_required_fields</var><br>
                        (so this is essentially equal to 1.)
                    </li>
                </ol>
            </dd>

            <div style="border-radius: 4px; box-shadow: 0px 0px 10px 2px #159957; margin-top: 30px; padding: 1px 25px 10px 25px;">
                <dt><code>Function validate(Object validation_options={all: false, apply_error_classes: true, focus_invalid: true, messages: true, stop_on_error: true, recache: false}) -> Array (of Object)</code></dt>
                <dd>
                    Validates the form and returns a list of errors. Each error looks like this:
                    <pre class="brush: js">
                        {
                            element: validated_element (jQuery),
                            errors: list_of_errors (Array of Object),
                            message: error_message (String)
                        }
                    </pre>
                    Each of the error objects looks like:
                    <pre class="brush: js">
                        {
                            element: validated_element (jQuery),
                            error_message_type: error_message_type (String),
                            phase: validation_phase (String),
                            required: is_required (Boolean),
                            type: validation_type (String),
                            value: value (String)
                            // if dependency error
                            mode: dependency_mode (String),
                            // if constraint error
                            &lt;constraint_name&gt;: constraint_value (String),
                            options: constraint_options (Object)
                        }
                    </pre>
                    <br>
                    The <code>validation_options</code> has the following properties (for default values see function signature):
                    <ul>
                        <li>
                            <code>Boolean all</code>: if <code>true</code> force validation on all fields (even if they are declared optional)
                        </li>
                        <li>
                            <code>Boolean apply_error_classes</code>: if <code>true</code> adds <code>error_classes</code> to invalid and removes them from valid elements' error targets, if <code>false</code> nothing will be changed
                        </li>
                        <li>
                            <code>Boolean focus_invalid</code>: if <code>true</code> focus the first invalid element (otherwise the focus won't be changed)
                        </li>
                        <li>
                            <code>Boolean message</code>: if <code>true</code> error messages will be created
                        </li>
                        <li>
                            <code>Boolean stop_on_error</code>: if <code>true</code> the validation of an element will be stopped as early as possible - after the first error occured
                        </li>
                        <li>
                            <code>Boolean recache</code>: if <code>true</code> the cache will be emptied and refilled
                        </li>
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
                Returns a new instance of the FormValidator class. This is the recommended way of instantiating a FormValidator object.<br>
                For more details on th eoptions object see <a class="goto" href="#" data-href="#options">options</a>.
            </dd>

            <dt><code>Function FormValidator.new_without_modifier(jQuery form, Object options)</code></dt>
            <dd>
                Returns a new instance of the FormValidator class but wihtout a FormModifier (which is used internally). The modifier takes care of applying styles and effects. So if you know that you want to take care of visual effects yourself you can skip all the unnecessary code for better performance (this might be especially interesting for real time validation).<br>
                For more details on th eoptions object see <a class="goto" href="#" data-href="#options">options</a>.
            </dd>
        </dl>
    </div>
</div>
