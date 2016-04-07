The following validators come with the FormValidator. The list shows what values will be interpreted as <i>valid</i>.
<ul class="spaced">
    <li>
        <code>checkbox</code><br>
        a checked checkbox
    </li>
    <li>
        <code>email</code><br>
        <code>&lt;ANYTHING+&gt;@&lt;ANYTHING+&gt;.&lt;ANYTHING_WITHOUT_DOT+&gt;</code> where <code>&lt;ANYTHING&gt;</code> must not contain an <code>@</code>
    </li>
    <li>
        <code>integer</code><br>
        any integer <var class="math">x</var> &#8712; &#8484; (that JavaScript can represent),<br>
        see <a class="goto" href="#" data-href="#constraints">constraints</a> for defining a range
    </li>
    <li>
        <code>number</code><br>
        any number <var class="math">x</var> &#8712; &#8477; (that JavaScript can represent),<br>
        see <a class="goto" href="#" data-href="#constraints">constraints</a> for defining a range
    </li>
    <li>
        <code>phone</code><br>
        any combination of <code>0123456789 +-/()</code>
    </li>
    <li>
        <code>radio</code><br>
        a radio button of the element's group of radio buttons (= all with the same <code>name</code> attribute) must be checked
    </li>
    <li>
        <code>select</code><br>
        the selected item's value is not <code>""</code>
    </li>
    <li>
        <code>text</code><br>
        anything longer than 0 characters,<br>
        see <a class="goto" href="#" data-href="#constraints">constraints</a> for defining a minimum or maximum length
    </li>
</ul>
