$(document).ready(function() {
    var my_form = $("#my_form");
    var overall_progress = $("#overall_progress");

    var form_validator = FormValidator.new(my_form, {
        error_target_getter: function(e, t, i) {
            return e;
        },
        group: function(fields) {
            var groups = [];
            fields.each(function(idx, elem) {
                var elem = $(elem);
                var id = parseInt(elem.closest(".section").attr("id"), 10);
                var idx = id - 1;
                if (!groups[idx]) {
                    groups[idx] = [elem];
                }
                else {
                    groups[idx].push(elem);
                }
                return true;
            });
            return groups;
        }
    });

    // validation
    $(".btn.validate").click(function(evt) {
        var progress = form_validator.get_progress();
        console.log("progress =", progress);
        $(".section").each(function(idx, elem) {
            var progress_bar = $(this).find("progress");
            progress_bar.animate({v: progress[idx]}, {
                step: function(v) {
                    progress_bar.attr("value", v);
                },
                duration: 200
            });
        });
        overall_progress.animate({v: progress.average}, {
            step: function(v) {
                overall_progress.attr("value", v);
            },
            duration: 200
        });
        return false;
    });

});
