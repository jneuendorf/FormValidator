<div class="row">
    <div class="col-xs-12">
        <h4>Include the FormValidator</h4>
        <h5>include it after jQuery (it requires jQuery 1.7+ upon initialization)</h5>
        <pre class="brush: xml">
            &lt;script type=&quot;text/javascript&quot; src=&quot;/path/to/FormValidator(.min).js&quot;&gt;&lt;/script&gt;
        </pre>
    </div>
    <div class="col-xs-12">
        <h4>Create a form and set some attributes</h4>
        <h5>See some <a class="goto" href="#" data-href="#demos">demos</a> or the <a class="goto" href="#" data-href="#attribute_index">attribute index</a></h5>
        <script type="text/javascript">
            $(".goto").click(function() {
                $(".nav.nav-tabs a[href='" + $(this).attr("data-href") + "']").click();
                window.scrollTo(0, 358);
                return false;
            });
        </script>
        <pre class="brush: xml">
            &lt;form id=&quot;my_form&quot; data-fv-error-classes=&quot;invalid&quot; data-fv-error-targets=&quot;self&quot;&gt;
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
                &lt;button data-fv-start=&quot;#my_form&quot;&gt;Validate&lt;/button&gt;
            &lt;/form&gt;
        </pre>
    </div>
</div>
