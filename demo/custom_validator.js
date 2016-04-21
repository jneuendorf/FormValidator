$(document).ready(function() {
    FormValidator.locales.de.value_product_key = "Bitte geben Sie einen korrekten Produkt-Schlüssel ein";
    FormValidator.locales.en.value_product_key = "Please enter a correct product key";

    var fv = FormValidator.new($("#my_form"), {
        error_output_mode: FormValidator.ERROR_OUTPUT_MODES.BELOW,
        validators: {
            product_key: function(str, elem) {
                return this.regex(str, /^\d\d\d\d\-\d\d\d\d\-\d\d\d\d\-\d\d\d\d$/);
            }
        }
    });

    $(".btn").click(function() {
        fv.validate();
        return true;
    });
});
