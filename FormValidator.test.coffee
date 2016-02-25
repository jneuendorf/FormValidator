FORM_HTML = """
<form action="" method="get" data-fv-error-classes="red-color class2">

    <span class="textlabel">text:</span>
    <input type="text" name="text" value="" data-fv-validate="text" data-fv-error-targets=".textlabel" /><br />

    <span data-fv-name="numberlabel-en">english format number:</span>
    <input type="text" name="en_number" value="" data-fv-validate="number" data-fv-preprocess="false" data-fv-postprocess="false" data-fv-error-targets="numberlabel-en" /><br />

    <span data-fv-name="numberlabel-de">german format number:</span>
    <input type="text" name="de_number" value="" data-fv-validate="number" data-fv-error-targets="numberlabel-de" /><br />

    <span data-fv-name="integerlabel">optional integer:</span>
    <input type="text" name="optional_integer" value="" data-fv-validate="integer" data-fv-optional="true" data-fv-error-targets="self" /><br />

    <span data-fv-name="integerlabel">integer:</span>
    <input type="text" name="integer" value="" data-fv-validate="integer" /><br />

    <span data-fv-name="phonelabel">optional phone:</span>
    <input type="text" name="phone" value="" data-fv-validate="phone" data-fv-optional="true" /><br />

    <span data-fv-name="emaillabel">email:</span>
    <input type="text" name="email" value="" data-fv-validate="email" data-fv-error-targets="self error1 .outsider" /><br />

    <span data-fv-name="checkboxlabel">checkbox:</span>
    <input type="checkbox" name="checkbox" value="v1" data-fv-validate="checkbox" data-fv-error-targets="self checkboxlabel" />
    <input type="checkbox" name="checkbox" value="v2" data-fv-validate="checkbox" />
    <br />

    <span data-fv-name="radiolabel">radio button:</span>
    <input type="radio" name="radio" value="v1" data-fv-validate="radio" />
    <input type="radio" name="radio" value="v2" data-fv-validate="radio" />
    <br />

    <select data-fv-validate="select" data-fv-error-targets="self">
        <option value="">Bitte wählen</option>
        <option value="mr">Herr</option>
        <option value="mrs">Frau</option>
    </select>
    <br />

    <div class="dependencies">
        <h4>Dependencies</h4>

        <input type="text" data-fv-validate="number" data-fv-name="master" data-fv-preprocess="false" data-fv-postprocess="false" /><br />
        <input type="text" data-fv-validate="text" data-fv-name="slave" data-fv-depends-on="master" /><br />
    </div>


    <h4>Constraints</h4>

    <span data-fv-name="constraint_blacklist">blacklist:</span>
    <input type="text" data-fv-validate="text" data-fv-regex="\\s+" data-fv-regex-flags="gi" value="\t" /><br />

    <hr />
    <div data-fv-name="error1" data-fv-error-classes="red-color bold">
        text in some div (INSIDE THE FORM TAG, USING data-fv-name) that should become red and bold for any form field with 'error1' as error target
    </div>
</form>

<div class="outsider">
    text in some div (OUTSIDE THE FORM TAG, USING class) that should become red and bold for any form field with '.outsider' as error target
</div>
"""


log = (name) ->
    str = "***********************************************************************"

    if name?
        padStr = "*****"
        rem = (str.length - name.length - 2) / 2
        s = padStr
        for i in [padStr.length..Math.floor(rem)]
            s += " "
        s += name
        for i in [padStr.length..Math.ceil(rem)]
            s += " "
        s += padStr
        console.log s

    console.log str
    return true

beforeEach () ->
    log()


describe "Reusables", () ->

    describe "FormValidator", () ->

        include_validator_tests()
        include_general_behavior_tests()
        include_dependency_tests()

        describe "progress", () ->
            # TODO

$(document).ready () ->
    window.setTimeout(
        () ->
            $(document.body).append FORM_HTML
        1500
    )
    return true
