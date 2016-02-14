The following validators come with the FormValidator. The list shows what values will be interpreted as <i>valid</i>.
<ul class="spaced">
    <li>
        <code>checkbox</code><br>
        a checked checkbox
    </li>
    <li>
        <code>email</code><br>
        &lt;ANYTHING+&gt;@&lt;ANYTHING_WITH_A_DOT+&gt;
    </li>
    <li>
        <code>integer</code><br>
        any integer <var class="math">x</var> &#8712; &#8484;,<br>
        Range can be defined with <code>data-fv-min</code> &amp; <code>data-fv-max</code> (and <code>data-fv-include-min</code> &amp; <code>data-fv-include-max</code> but that wouldn't make so much sense).
    </li>
    <li>
        <code>number</code><br>
        any number <var class="math">x</var> &#8712; &#8477; (that JavaScript can represent),<br>
        Range can be defined with <code>data-fv-min</code> &amp; <code>data-fv-max</code> and <code>data-fv-include-min</code> &amp; <code>data-fv-include-max</code>.
    </li>
    <li>
        <code>phone</code><br>
        any combination of <code>"0123456789+-/() "</code> (that's longer than 2 characters by default),<br>
        As with <code>text</code> a minimum and maximum length can be defined using <code>data-fv-min</code> and <code>data-fv-max</code>.
    </li>
    <li>
        <code>radio</code><br>
        a radio button of the element's group of radio buttons (= all with the same <code>name</code> attribute) must be checked
    </li>
    <li>
        <code>select</code><br>
        the selected item's value is not <code>null</code> and at least 1 character long,<br>
        As with <code>text</code> a minimum and maximum length can be defined using <code>data-fv-min</code> and <code>data-fv-max</code>.
    </li>
    <li>
        <code>text</code><br>
        anything longer than 0 characters,<br>
        A minimum and maximum length can be defined using <code>data-fv-min</code> and <code>data-fv-max</code>.
    </li>
</ul>
