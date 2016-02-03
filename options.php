<div class="row">
    <p class="col-xs-12">
        The following options can be passed to a new FormValidator object like so:<br />
        <code>new FormValidator(form, options)</code>
    </p>

    <div class="col-xs-12">
        <h4>Validation handling</h4>
        <dl class="">
            <dt>create_dependency_error_message</dt>
            <dd>

            </dd>

            <dt>dependency_error_classes</dt>
            <dd>

            </dd>

            <dt>error_classes</dt>
            <dd>

            </dd>

            <dt>error_messages</dt>
            <dd>

            </dd>

            <dt>error_mode</dt>
            <dd>

            </dd>

            <dt>error_output_mode</dt>
            <dd>

            </dd>

            <dt>error_target_getter</dt>
            <dd>

            </dd>
        </dl>
    </div>

    <div class="col-xs-12">
        <h4>Error handling</h4>
        <dl class="">
            <dt>field_getter</dt>
            <dd>

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

            </dd>

            <dt>partition</dt>
            <dd>

            </dd>

            <dt>preprocessors</dt>
            <dd>

            </dd>

            <dt>postprocessors</dt>
            <dd>

            </dd>

            <dt>required_field_getter</dt>
            <dd>

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
                Set of validators that correspond to a validation type (<code>data-fv-validate</code>).<br />
                They can be used to override existing validators or define new ones.
            </dd>

        </dl>
    </div>
</div>
