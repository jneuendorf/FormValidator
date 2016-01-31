<div class="row">
    <div class="col-xs-12">
        <h3>Basic validation</h3>
        <form id="basic_validation">
            <div class="form-group">
                <label>Email address</label>
                <input type="text" class="form-control" placeholder="Email" data-fv-validate="email" />
            </div>
            <div class="checkbox">
                <label>
                    <input type="checkbox"> Check me out
                </label>
            </div>
            <button type="button" class="btn btn-default" data-fv-start="#basic_validation">Submit</button>
        </form>
    </div>
</div>
<pre class="brush: js">
    +function ($) {
      'use strict';
      var version = $.fn.jquery.split(' ')[0].split('.')
      if ((version[0] < 2 && version[1] < 9) || (version[0] == 1 && version[1] == 9 && version[2] < 1) || (version[0] > 2)) {
        throw new Error('Bootstrap\'s JavaScript requires jQuery version 1.9.1 or higher, but lower than version 3')
      }
    }(jQuery);
</pre>
<pre class="brush: xml">
    &lt;div class=&quot;row&quot;&gt;
        &lt;div class=&quot;col-xs-12&quot;&gt;
            &lt;h3&gt;Basic validation&lt;/h3&gt;
        &lt;/div&gt;
    &lt;/div&gt;
</pre>
