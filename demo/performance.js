$(document).ready(function() {
    var my_form = $("#my_form");
    var duration = $("#duration");

    // build DOM
    for (var i = 0; i < 400; i++) {
        my_form.append("<div class='col-xs-1'><input class='form-control' type='text' value='" + i + "' data-fv-validate='number'></div>");
    }

    var form_validator = FormValidator.new(my_form);

    // validation
    $(".btn.validate").click(function(evt) {
        var start = Date.now();
        form_validator.validate();
        duration.text((Date.now() - start) + " ms");
    });

});
