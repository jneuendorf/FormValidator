<h4>The following constraints come with the FormValidator</h4>
<dl>
    <dt><code>data-fv-blacklist</code></dt>
    <dd>
        <code>String</code><br>
        Define a set of characters of which none may occur in the validation value of the field.<br>
        There are no default options for this constraint.
    </dd>

    <dt><code>data-fv-max</code></dt>
    <dd>
        <code>Number</code> <span class="label label-option">data-fv-include-max</span><br>
        Define the maximum value for an element.<br>
        By default this value is the greatest valid value. To exclude the maximum see the option <code>data-fv-include-max</code>.
    </dd>

    <dt><code>data-fv-max-length</code></dt>
    <dd>
        <code>Number</code><br>
        Define the maximum length for the validation value of an element.<br>
        This value is the greatest valid value.<br>
        There are no default options for this constraint.
    </dd>

    <dt><code>data-fv-min</code></dt>
    <dd>
        <code>Number</code> <span class="label label-option">data-fv-include-min</span><br>
        Define the minimum value for an element.<br>
        By default this is be the smallest valid value. To exclude the minimum see the option <code>data-fv-include-min</code>.
    </dd>

    <dt><code>data-fv-min-length</code></dt>
    <dd>
        <code>Number</code><br>
        Define the minimum length for the validation value of an element.<br>
        This value is the smallest valid value.<br>
        There are no default options for this constraint.
    </dd>

    <dt><code>data-fv-regex</code></dt>
    <dd>
        <code>String</code> <span class="label label-option">data-fv-regex-flags</span><br>
        Define a regular expression that the element's validation value must not match.<br>
    </dd>

    <dt><code>data-fv-whitelist</code></dt>
    <dd>
        <code>String</code><br>
        Define a set of characters that the element's validation value must contain.<br>
        There are no default options for this constraint.
    </dd>
</dl>


<h4>The following options for constraints come with the FormValidator</h4>
<dl>
    <dt><code>data-fv-include-max</code></dt>
    <dd>
        <code>Boolean</code> <span class="label label-option">data-fv-max</span><br>
        An option for <code>data-fv-max</code>.
        Define whether to include the defined <code>data-fv-max</code> or not.
    </dd>

    <dt><code>data-fv-include-min</code></dt>
    <dd>
        <code>Boolean</code> <span class="label label-option">data-fv-min</span><br>
        An option for <code>data-fv-min</code>.
        Define whether to include the defined <code>data-fv-min</code> or not.
    </dd>

    <dt><code>data-fv-regex-flags</code></dt>
    <dd>
        <code>String</code> <span class="label label-option">data-fv-regex</span><br>
        An option for <code>data-fv-regex</code>. Define a what flags to use for the defined regular expression.
    </dd>
</dl>


<h4>Note</h4>
If you define a constraint to a validator so that the combination does not make sense <code>FormValidator</code> won't throw or report anything nor try anything fancy. I decided to keep the code simple (and as lightweight as possible) and make the user take care of correctness of validation definitions.<br>
<code>FormValidator</code> alwasy assumes syntactically and logically correct input from the programmer.
