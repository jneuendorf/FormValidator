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
    $("select.validator").append(validators).change(function() {
        $field
            .attr("data-fv-validate", $(this).val())
            .attr("placeholder", "enter some " + $(this).val());
        return true;
    }).val("text").change();


    var form_validator = FormValidator.new(my_form, {
        error_target_getter: function(e, t, i) {
            var name = e.attr("name");
            if (name) {
                var group = $("[name='" + name + "']");
                if (group.length > 1) {
                    return group;
                }
            }
            return e;
        },
        error_mode: FormValidator.ERROR_MODES.SIMPLE,
        dependency_change_action: FormValidator.DEPENDENCY_CHANGE_ACTIONS.SHOW
    });
    $(".error_output_mode").change(function(evt) {
        form_validator.form_modifier.error_output_mode = $(this).find(":selected").val();
        $field.tooltip("destroy").popover("destroy");
        return true;
    }).val("BELOW").change();
    $(".build_mode").change(function(evt) {
        form_validator.build_mode = $(this).find(":selected").val();
        return true;
    }).val("ENUMERATE").change();
    // validation
    $(".btn.validate").click(function(evt) {
        form_validator.locale = $(".locale option:selected").val();
        console.log(form_validator.validate({recache: true}));
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
});
