<!-- EXAMPLE 1 -->
<div class="row">
    <div class="col-xs-12">
        <h3>Basic validation</h3>
        <h4>The form</h4>
        <div class="row">
            <form id="example1" class="col-xs-6" data-fv-error-classes="invalid" data-fv-error-targets="self">
                <div class="form-group">
                    <label>Email address</label>
                    <input type="text" class="form-control" placeholder="Email" data-fv-validate="email" />
                </div>
                <div class="form-group">
                    <label>Age</label>
                    <input type="text" class="form-control" placeholder="25" data-fv-validate="integer" />
                </div>
                <div class="form-group">
                    <label>Some optional text</label>
                    <input type="text" class="form-control" data-fv-validate="text" data-fv-optional="true" />
                </div>
                <div class="form-group">
                    <label>An optional number</label>
                    <input type="text" class="form-control" data-fv-validate="number" data-fv-optional="true" />
                </div>
                <button type="button" class="btn btn-default" data-fv-start="#example1">Validate</button>
            </form>
        </div>
        <h4>The HTML</h4>
        <pre class="brush: xml">
            &lt;form id=&quot;example1&quot; data-fv-error-classes=&quot;invalid&quot; data-fv-error-targets=&quot;self&quot;&gt;
                &lt;div&gt;
                    &lt;label&gt;Email address&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;email&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Age&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;integer&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Some optional text&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;text&quot; data-fv-optional=&quot;true&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;An optional number&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;number&quot; data-fv-optional=&quot;true&quot; /&gt;
                &lt;/div&gt;
                &lt;button data-fv-start=&quot;#example1&quot;&gt;Validate&lt;/button&gt;
            &lt;/form&gt;
        </pre>
    </div>
</div>
<!-- EXAMPLE 2 -->
<div class="row">
    <hr />
    <div class="col-xs-12">
        <h3>Using all validation types (and some options)</h3>
        <h4>The form</h4>
        <div class="row">
            <form id="example2" class="col-xs-6" data-fv-error-classes="invalid" data-fv-error-targets="self">
                <div class="form-group">
                    <label>Email</label>
                    <input type="text" class="form-control" placeholder="you@me.com" data-fv-validate="email" />
                </div>
                <div class="form-group">
                    <label>Integer (&ge; -10)</label>
                    <input type="text" class="form-control" placeholder="25" data-fv-validate="integer" data-fv-min="-10" />
                </div>
                <div class="form-group">
                    <label>Number (&lt; 9)</label>
                    <input type="text" class="form-control" placeholder="-5.234" data-fv-validate="number" data-fv-max="9" data-fv-include-max="false" />
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" class="form-control" placeholder="+49 (0) 30 / 123-456" data-fv-validate="phone" />
                </div>
                <div class="form-group">
                    <label>Text</label>
                    <textarea class="form-control" placeholder="anything you want" data-fv-validate="text"></textarea>
                </div>
                <div class="form-group">
                    <label>Select</label>
                    <select class="form-control" data-fv-validate="select">
                        <option value="">- select something (invalid options) -</option>
                        <option value="opt1">option 1</option>
                        <option value="opt2">option 2</option>
                        <option value="opt3">option 3</option>
                        <option value="opt4">option 4</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Checkbox</label>
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" value="checkbox1" data-fv-validate="checkbox" /> check me
                        </label>
                    </div>
                </div>
                <div class="form-group">
                    <label>Radio</label>
                    <div class="radio">
                        <label>
                            <input type="radio" name="optionsRadios" value="option1" data-fv-validate="radio" /> check me
                        </label>
                    </div>
                    <div class="radio">
                        <label>
                            <input type="radio" name="optionsRadios" value="option2" data-fv-validate="radio" /> or me
                        </label>
                    </div>
                </div>
                <button type="button" class="btn btn-default" data-fv-start="#example2">Validate</button>
            </form>
        </div>
        <h4>The HTML</h4>
        <pre class="brush: xml">
            &lt;form id=&quot;example2&quot; data-fv-error-classes=&quot;invalid&quot; data-fv-error-targets=&quot;self&quot;&gt;
                &lt;div&gt;
                    &lt;label&gt;Email&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;email&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Integer (&amp;ge; -10)&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;integer&quot; data-fv-min=&quot;-10&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Number (&amp;lt; 9)&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;number&quot; data-fv-max=&quot;9&quot; data-fv-include-max=&quot;false&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Phone&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;phone&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Text&lt;/label&gt;
                    &lt;textarea data-fv-validate=&quot;text&quot;&gt;&lt;/textarea&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Select&lt;/label&gt;
                    &lt;select data-fv-validate=&quot;select&quot;&gt;
                        &lt;option value=&quot;&quot;&gt;- select something (invalid options) -&lt;/option&gt;
                        &lt;option value=&quot;opt1&quot;&gt;option 1&lt;/option&gt;
                        &lt;option value=&quot;opt2&quot;&gt;option 2&lt;/option&gt;
                        &lt;option value=&quot;opt3&quot;&gt;option 3&lt;/option&gt;
                        &lt;option value=&quot;opt4&quot;&gt;option 4&lt;/option&gt;
                    &lt;/select&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Checkbox&lt;/label&gt;
                    &lt;div class=&quot;checkbox&quot;&gt;
                        &lt;label&gt;
                            &lt;input type=&quot;checkbox&quot; value=&quot;checkbox1&quot; data-fv-validate=&quot;checkbox&quot; /&gt; check me
                        &lt;/label&gt;
                    &lt;/div&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Radio&lt;/label&gt;
                    &lt;div class=&quot;radio&quot;&gt;
                        &lt;label&gt;
                            &lt;input type=&quot;radio&quot; name=&quot;optionsRadios&quot; value=&quot;option1&quot; data-fv-validate=&quot;radio&quot; /&gt; check me
                        &lt;/label&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;radio&quot;&gt;
                        &lt;label&gt;
                            &lt;input type=&quot;radio&quot; name=&quot;optionsRadios&quot; value=&quot;option2&quot; data-fv-validate=&quot;radio&quot; /&gt; or me
                        &lt;/label&gt;
                    &lt;/div&gt;
                &lt;/div&gt;
                &lt;button data-fv-start=&quot;#example2&quot;&gt;Validate&lt;/button&gt;
            &lt;/form&gt;
        </pre>
    </div>
</div>
<!-- EXAMPLE 3 -->
<div class="row">
    <hr />
    <div class="col-xs-12">
        <h3>Using JavaScript, printing error messages, dependencies</h3>
        <h4>The form</h4>
        <form data-fv-error-classes="invalid" data-fv-error-targets="self">
            <div class="row">
                <div class="form-group col-xs-6">
                    <label>Email</label>
                    <input type="text" class="form-control" placeholder="you@me.com" data-fv-validate="email" />
                </div>
                <div class="col-xs-1">
                    <div class="error_state"></div>
                </div>
                <div class="col-xs-5 error_message"></div>
            </div>
            <div class="row">
                <div class="form-group col-xs-6">
                    <label>Integer</label>
                    <input type="text" class="form-control" placeholder="25" data-fv-validate="integer" />
                </div>
                <div class="col-xs-1">
                    <div class="error_state"></div>
                </div>
                <div class="col-xs-5 error_message"></div>
            </div>
            <div class="row">
                <div class="form-group col-xs-6">
                    <label>Number n1 (when valid another field will show up)</label>
                    <input type="text" class="form-control" placeholder="-5.234" data-fv-validate="number" data-fv-name="n1" />
                </div>
                <div class="col-xs-1">
                    <div class="error_state"></div>
                </div>
                <div class="col-xs-5 error_message"></div>
            </div>
            <div class="row" style="display: none;">
                <div class="form-group col-xs-6">
                    <label>This number depends on n1 to be valid</label>
                    <input type="text" class="form-control" data-fv-validate="number" data-fv-depends-on="n1" />
                </div>
                <div class="col-xs-1">
                    <div class="error_state"></div>
                </div>
                <div class="col-xs-5 error_message"></div>
            </div>
            <div class="row">
                <div class="form-group col-xs-6">
                    <label>My text area</label>
                    <textarea class="form-control" placeholder="anything you want" data-fv-validate="text" data-fv-name="My text area"></textarea>
                </div>
                <div class="col-xs-1">
                    <div class="error_state"></div>
                </div>
                <div class="col-xs-5 error_message"></div>
            </div>
            <div class="row">
                <div class="col-xs-1">
                    Locale:
                </div>
                <div class="col-xs-1">
                    <select class="form-control example3 locale">
                        <option value="en">en</option>
                        <option value="de">de</option>
                    </select>
                </div>
                <div class="col-xs-2">
                    <button type="button" class="btn btn-default" id="example3">Validate</button>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <strong>Keep in mind</strong> that FormValidator comes with some predefined preprocessors.<br />
                    For example, when choosing 'de' the string <code>123.15,45</code> will be parsed as <code>12315.45</code>.
                </div>
            </div>
        </form>
        <script type="text/javascript">
            $("#example3").click(function() {
                var form = $("#example3").closest("form"),
                    error, div, text, i;
                var validator = new FormValidator(form, {
                    error_target_getter: function(type, element, index) {
                        return element.closest(".row").find(".error_state");
                    },
                    locale: form.find(".example3.locale option:selected").val()
                });
                var errors = validator.validate();
                console.log(errors);

                form.find(".error_message").empty();
                for (i = 0; i < errors.length; i++) {
                    error = errors[i];

                    if (error.type === "dependency" && error.element.attr("data-fv-depends-on") === "n1") {
                        error.element.fadeOut(100);
                    }
                    else {
                        error.element.fadeIn(100);
                    }

                    div = error.element.closest(".row").find(".error_message");
                    text = div.text();
                    div.text(text + (text.length > 0 ? "; " : "") + error.message);
                }
                return true;
            });
        </script>
        <h4>The JavaScript</h4>
        <pre class="brush: js">
            $(&quot;#example3&quot;).click(function() {
                var form = $(&quot;#example3&quot;).closest(&quot;form&quot;),
                    error, div, text;
                var validator = new FormValidator(form, {
                    // apply &apos;invalid&apos; class to circles instead of the text fields themselves
                    error_target_getter: function(type, element, index) {
                        return element.closest(&quot;.row&quot;).find(&quot;.error_state&quot;);
                    },
                    locale: form.find(&quot;.example3.locale option:selected&quot;).val()
                });
                var errors = validator.validate();
                // show errors
                form.find(&quot;.error_message&quot;).empty();
                for (var i = 0; i &lt; errors.length; i++) {
                    error = errors[i];
                    div = error.element.closest(&quot;.row&quot;).find(&quot;.error_message&quot;);
                    text = div.text();
                    div.text(text + (text.length &gt; 0 ? &quot;; &quot; : &quot;&quot;) + error.message);
                }
                return true;
            });
        </pre>
        <h4>The HTML</h4>
        <pre class="brush: xml">
            &lt;form data-fv-error-classes=&quot;invalid&quot; data-fv-error-targets=&quot;self&quot;&gt;
                &lt;div class=&quot;row&quot;&gt;
                    &lt;div class=&quot;col-xs-6&quot;&gt;
                        &lt;label&gt;Email&lt;/label&gt;
                        &lt;input type=&quot;text&quot; data-fv-validate=&quot;email&quot; /&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-1&quot;&gt;
                        &lt;div class=&quot;error_state&quot;&gt;&lt;/div&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-5 error_message&quot;&gt;&lt;/div&gt;
                &lt;/div&gt;
                &lt;div class=&quot;row&quot;&gt;
                    &lt;div class=&quot;col-xs-6&quot;&gt;
                        &lt;label&gt;Integer&lt;/label&gt;
                        &lt;input type=&quot;text&quot; data-fv-validate=&quot;integer&quot; /&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-1&quot;&gt;
                        &lt;div class=&quot;error_state&quot;&gt;&lt;/div&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-5 error_message&quot;&gt;&lt;/div&gt;
                &lt;/div&gt;
                &lt;div class=&quot;row&quot;&gt;
                    &lt;div class=&quot;col-xs-6&quot;&gt;
                        &lt;label&gt;Number n1&lt;/label&gt;
                        &lt;input type=&quot;text&quot; data-fv-validate=&quot;number&quot; data-fv-name=&quot;n1&quot; /&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-1&quot;&gt;
                        &lt;div class=&quot;error_state&quot;&gt;&lt;/div&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-5 error_message&quot;&gt;&lt;/div&gt;
                &lt;/div&gt;
                &lt;div class=&quot;row&quot;&gt;
                    &lt;div class=&quot;col-xs-6&quot;&gt;
                        &lt;label&gt;This number depends on n1&lt;/label&gt;
                        &lt;input type=&quot;text&quot; data-fv-validate=&quot;number&quot; data-fv-depends-on=&quot;n1&quot; /&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-1&quot;&gt;
                        &lt;div class=&quot;error_state&quot;&gt;&lt;/div&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-5 error_message&quot;&gt;&lt;/div&gt;
                &lt;/div&gt;
                &lt;div class=&quot;row&quot;&gt;
                    &lt;div class=&quot;col-xs-6&quot;&gt;
                        &lt;label&gt;My text area&lt;/label&gt;
                        &lt;textarea data-fv-validate=&quot;text&quot; data-fv-name=&quot;My text area&quot;&gt;&lt;/textarea&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-1&quot;&gt;
                        &lt;div class=&quot;error_state&quot;&gt;&lt;/div&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-5 error_message&quot;&gt;&lt;/div&gt;
                &lt;/div&gt;
                &lt;div class=&quot;row&quot;&gt;
                    &lt;div class=&quot;col-xs-1&quot;&gt;
                        Locale:
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-1&quot;&gt;
                        &lt;select class=&quot;example3 locale&quot;&gt;
                            &lt;option value=&quot;en&quot;&gt;en&lt;/option&gt;
                            &lt;option value=&quot;de&quot;&gt;de&lt;/option&gt;
                        &lt;/select&gt;
                    &lt;/div&gt;
                    &lt;div class=&quot;col-xs-2&quot;&gt;
                        &lt;button id=&quot;example3&quot;&gt;Validate&lt;/button&gt;
                    &lt;/div&gt;
                &lt;/div&gt;
            &lt;/form&gt;
        </pre>
    </div>
</div>
<!-- EXAMPLE 4 -->
<div class="row">
    <div class="col-xs-12">
        <h3>Example 1 in real time</h3>
        <h4>The form</h4>
        <div class="row">
            <form id="example4" class="col-xs-6" data-fv-error-classes="invalid" data-fv-error-targets="self" data-fv-real-time>
                <div class="form-group">
                    <label>Email address</label>
                    <input type="text" class="form-control" placeholder="Email" data-fv-validate="email" />
                </div>
                <div class="form-group">
                    <label>Age</label>
                    <input type="text" class="form-control" placeholder="25" data-fv-validate="integer" />
                </div>
                <div class="form-group">
                    <label>Some optional text</label>
                    <input type="text" class="form-control" data-fv-validate="text" data-fv-optional="true" />
                </div>
                <div class="form-group">
                    <label>An optional number</label>
                    <input type="text" class="form-control" data-fv-validate="number" data-fv-optional="true" />
                </div>
            </form>
        </div>
        <h4>The HTML</h4>
        <pre class="brush: xml">
            &lt;form id=&quot;example4&quot; data-fv-error-classes=&quot;invalid&quot; data-fv-error-targets=&quot;self&quot; data-fv-real-time&gt;
                &lt;div&gt;
                    &lt;label&gt;Email address&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;email&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Age&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;integer&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;Some optional text&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;text&quot; data-fv-optional=&quot;true&quot; /&gt;
                &lt;/div&gt;
                &lt;div&gt;
                    &lt;label&gt;An optional number&lt;/label&gt;
                    &lt;input type=&quot;text&quot; data-fv-validate=&quot;number&quot; data-fv-optional=&quot;true&quot; /&gt;
                &lt;/div&gt;
            &lt;/form&gt;
        </pre>
    </div>
</div>
