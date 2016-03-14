$(document).ready(function() {
    var my_form = $("#my_form");
    var validators = "";
    for (var name in FormValidator.validators) {
        if (FormValidator.validators.hasOwnProperty(name)) {
            if (name[0] != "_") {
                validators += "<option value='" + name + "'>" + name + "</option>";
            }
        }
    }
    var $field = $("#field");
    var $errors = $("#errors");
    $("select.validator").append(validators).change(function() {
        $field
            .attr("data-fv-validate", $(this).val())
            .attr("placeholder", "enter some " + $(this).val());
        return true;
    }).val("text").change();


    var form_validator = FormValidator.new(my_form, {
        error_target_getter: function(e, t, i) {
            return e;
        },
        // error_output_mode: FormValidator.ERROR_OUTPUT_MODES.POPOVER
        error_output_mode: FormValidator.ERROR_OUTPUT_MODES.TOOLTIP
    });
    // validation
    $(".btn.validate").click(function(evt) {
        form_validator.locale = $(".locale option:selected").val();
        $errors.empty();
        var errors = form_validator.validate({recache: true});
        console.log(errors);
        for (var i = 0; i < errors.length; i++) {
            $errors.append(errors[i].message);
        }
        return false;
    });

    $(".options input").change(function() {
        var t = $(this);
        var val = t.val();
        // checkbox
        if (t.filter("[type='checkbox']").length > 0) {
            if (t.prop("checked") === true) {
                $field.attr(t.attr("data-attr"), "true");
            }
            else {
                $field.attr(t.attr("data-attr"), "false");
            }
        }
        // text field
        else {
            if (val) {
                $field.attr(t.attr("data-attr"), t.val());
            }
            else {
                $field.attr(t.attr("data-attr"), null);
            }
        }
        return true;
    });

    // // checkbox toggle
    // my_form.on("change", ".mod_checkbox", function(evt) {
    //     var $elem = $(this);
    //     var $mod_input = $elem.closest(".row").find("input[type='text']");
    //     var $input = $("#" + $elem.attr("data-target-id"));
    //     var constraint = $mod_input.attr("data-constraint");
    //     var attribute = "data-fv-" + $mod_input.attr("data-constraint").replace(/\_/g, "-");
    //     var options_row = $mod_input.closest(".row").siblings(".row.option[data-constraint='" + constraint + "']");
    //
    //     if ($elem.prop("checked") === true) {
    //         $mod_input.prop("disabled", false).focus().change();
    //         options_row.find("input[type='checkbox']").prop("disabled", false);
    //     }
    //     else {
    //         $mod_input.prop("disabled", true);
    //         options_row.find("input").prop("disabled", true).filter("[type=checkbox]").prop("checked", false);
    //         $input.attr(attribute, null);
    //     }
    // });
    // // constraint input
    // my_form.on("change", ".mod_input", function(evt) {
    //     var $elem = $(this);
    //     var attribute = "data-fv-" + $elem.attr("data-constraint").replace(/\_/g, "-");
    //     var val = $elem.val() || null;
    //     $("#" + $elem.attr("data-target-id")).attr(attribute, val);
    // });
});
