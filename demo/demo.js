$(document).ready(function() {
    var my_form = $("#my_form");
    var get_constraints = function(prefix, elem) {
        var res = "", options;
        for (var name in FormValidator.constraint_validators) {
            if (FormValidator.constraint_validators.hasOwnProperty(name)) {
                options = "";
                if (FormValidator.constraint_validator_options.hasOwnProperty(name)) {
                    for (var i = 0; i < FormValidator.constraint_validator_options[name].length; i++) {
                        options += '<div class="row option" data-constraint="' + name + '">' +
                            '<div class="col-xs-1">' +
                            '</div>' +
                            '<div class="col-xs-4">' +
                                '<label class="checkbox-inline">' +
                                    '<input type="checkbox" name="' + prefix + name + '" class="mod_checkbox" value="v1" data-target-id="' + elem.attr("id") + '" disabled />' +
                                    FormValidator.constraint_validator_options[name][i] + ": " +
                                '</label>' +
                            '</div>' +
                            '<div class="col-xs-3">' +
                                '<input type="text" class="form-control mod_input" data-target-id="' + elem.attr("id") + '" data-constraint="' + FormValidator.constraint_validator_options[name][i] + '" disabled>' +
                            '</div>' +
                        '</div>';
                    }
                }

                res += '<div class="row">' +
                    '<div class="col-xs-3">' +
                        '<label class="checkbox-inline">' +
                            '<input type="checkbox" name="' + prefix + name + '" class="mod_checkbox" value="v1" data-target-id="' + elem.attr("id") + '" />' +
                            name + " = " +
                        '</label>' +
                    '</div>' +
                    '<div class="col-xs-5">' +
                        '<input type="text" class="form-control mod_input" data-target-id="' + elem.attr("id") + '" data-constraint="' + name + '" disabled>' +
                    '</div>' +
                '</div>';
                res += options;
            }
        }
        return res;
    };
    my_form.find(" .validation_options").each(function(idx, elem) {
        var $elem = $(elem);
        var $input;
        if (($input = $elem.prev().find("input[type='text']")).length == 1) {
            $elem.append(get_constraints($input.attr("id") + "_", $input));
        }
        return true;
    });

    var form_validator = FormValidator.new(my_form, {
        error_target_getter: function(e, t, i) {
            if (e.filter("[type='checkbox'], [type='radio']").length > 0) {
                return e.parent();
            }
            return e;
        }
    });
    // validation
    $(".btn.validate").click(function(evt) {
        form_validator.locale = $(".locale option:selected").val();
        var errors = form_validator.validate();
        console.log(errors);
        for (var i = 0; i < errors.length; i++) {
            var error = errors[i];
            error.element.next(".error_output").empty().append(error.message);
        }
        return false;
    });

    // checkbox toggle
    my_form.on("change", ".mod_checkbox", function(evt) {
        var $elem = $(this);
        var $mod_input = $elem.closest(".row").find("input[type='text']");
        var $input = $("#" + $elem.attr("data-target-id"));
        var constraint = $mod_input.attr("data-constraint");
        var attribute = "data-fv-" + $mod_input.attr("data-constraint").replace(/\_/g, "-");
        var options_row = $mod_input.closest(".row").siblings(".row.option[data-constraint='" + constraint + "']");

        if ($elem.prop("checked") === true) {
            $mod_input.prop("disabled", false).focus().change();
            options_row.find("input[type='checkbox']").prop("disabled", false);
        }
        else {
            $mod_input.prop("disabled", true);
            options_row.find("input").prop("disabled", true).filter("[type=checkbox]").prop("checked", false);
            $input.attr(attribute, null);
        }
    });
    // constraint input
    my_form.on("change", ".mod_input", function(evt) {
        var $elem = $(this);
        var attribute = "data-fv-" + $elem.attr("data-constraint").replace(/\_/g, "-");
        var val = $elem.val() || null;
        $("#" + $elem.attr("data-target-id")).attr(attribute, val);
    });
});
