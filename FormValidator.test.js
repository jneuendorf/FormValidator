// Generated by CoffeeScript 1.10.0
(function() {
  var FORM_HTML, include_constraint_tests, include_dependency_tests, include_general_behavior_tests, include_validator_tests, log;

  include_validator_tests = function() {
    return describe("validators", function() {
      var validators;
      log("validators");
      validators = FormValidator.validators;
      it("email", function() {
        var validator;
        log("email");
        validator = validators.email;
        expect(validator("some@valid-email.com")).toBe(true);
        expect(validator("so@me@invalid-email_no_dot_com")).toEqual({
          error_message_type: "email_many_at"
        });
        expect(validator("so@me@valid-email.com")).toEqual({
          error_message_type: "email_many_at"
        });
        expect(validator("some_invalid-email.com")).toEqual({
          error_message_type: "email_at"
        });
        return expect(validator("totally wrong!")).toEqual({
          error_message_type: "email_at"
        });
      });
      it("integer", function() {
        var $elem, validator;
        log("integer");
        validator = function(str, elem) {
          return validators.integer.call(validators, str, elem);
        };
        $elem = $("<input type='text' data-fv-validate='integer' />");
        expect(validator("0", $elem)).toBe(true);
        expect(validator("1", $elem)).toBe(true);
        expect(validator("100", $elem)).toBe(true);
        expect(validator("+5", $elem)).toBe(true);
        expect(validator("+ 5", $elem)).toBe(true);
        expect(validator("+ 5 ", $elem)).toBe(true);
        expect(validator(" + 5 ", $elem)).toBe(true);
        expect(validator("-5", $elem)).toBe(true);
        expect(validator("- 5", $elem)).toBe(true);
        expect(validator(" - 5", $elem)).toBe(true);
        expect(validator("- 5 ", $elem)).toBe(true);
        expect(validator("1e7", $elem)).toEqual({
          error_message_type: "integer"
        });
        expect(validator("Infinity", $elem)).toEqual({
          error_message_type: "integer"
        });
        expect(validator("1.25", $elem)).toEqual({
          error_message_type: "integer_float"
        });
        expect(validator("0.1", $elem)).toEqual({
          error_message_type: "integer_float"
        });
        expect(validator(" - 0.1", $elem)).toEqual({
          error_message_type: "integer_float"
        });
        expect(validator(" - 0.1 ", $elem)).toEqual({
          error_message_type: "integer_float"
        });
        expect(validator("0.1a2", $elem)).toEqual({
          error_message_type: "integer"
        });
        return expect(validator("asdf", $elem)).toEqual({
          error_message_type: "integer"
        });
      });
      it("positive integer", function() {
        var $elem, validator;
        log("positive integer");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.integer.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='0' />");
        expect(validator("0", $elem)).toBe(true);
        expect(validator("1", $elem)).toBe(true);
        expect(validator("100", $elem)).toBe(true);
        expect(validator("+5", $elem)).toBe(true);
        expect(validator("+ 5", $elem)).toBe(true);
        expect(validator("+ 5 ", $elem)).toBe(true);
        expect(validator(" + 5 ", $elem)).toBe(true);
        expect(validator("-5", $elem)).toEqual({
          error_message_type: 'integer_min_included',
          min: 0
        });
        expect(validator("- 5", $elem)).toEqual({
          error_message_type: 'integer_min_included',
          min: 0
        });
        expect(validator(" - 5", $elem)).toEqual({
          error_message_type: 'integer_min_included',
          min: 0
        });
        expect(validator("- 5 ", $elem)).toEqual({
          error_message_type: 'integer_min_included',
          min: 0
        });
        expect(validator("1e7", $elem)).toEqual({
          error_message_type: 'integer'
        });
        expect(validator("Infinity", $elem)).toEqual({
          error_message_type: 'integer'
        });
        expect(validator("1.25", $elem)).toEqual({
          error_message_type: 'integer_float'
        });
        expect(validator("0.1", $elem)).toEqual({
          error_message_type: 'integer_float'
        });
        expect(validator(" - 0.1", $elem)).toEqual({
          error_message_type: 'integer'
        });
        return expect(validator(" - 0.1 ", $elem)).toEqual({
          error_message_type: 'integer'
        });
      });
      it("negative integer", function() {
        var $elem, validator;
        log("negative integer");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.integer.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='integer' data-fv-max='0' data-fv-include-max='false' />");
        expect(validator("-5", $elem)).toBe(true);
        expect(validator("- 5", $elem)).toBe(true);
        expect(validator(" - 5", $elem)).toBe(true);
        expect(validator("- 5 ", $elem)).toBe(true);
        expect(validator("0", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0
        });
        expect(validator("1", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0
        });
        expect(validator("100", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0
        });
        expect(validator("+5", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0
        });
        expect(validator("+ 5", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0
        });
        expect(validator("+ 5 ", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0
        });
        expect(validator(" + 5 ", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0
        });
        expect(validator("1e7", $elem)).toEqual({
          error_message_type: 'integer'
        });
        expect(validator("-Infinity", $elem)).toEqual({
          error_message_type: 'integer'
        });
        expect(validator("1.25", $elem)).toEqual({
          error_message_type: 'integer'
        });
        expect(validator("0.1", $elem)).toEqual({
          error_message_type: 'integer'
        });
        expect(validator(" - 0.1", $elem)).toEqual({
          error_message_type: 'integer_float'
        });
        return expect(validator(" - 0.1 ", $elem)).toEqual({
          error_message_type: 'integer_float'
        });
      });
      it("positive integer with max", function() {
        var $elem, validator;
        log("positive integer with max");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.integer.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='0' data-fv-max='10' />");
        expect(validator("0", $elem)).toBe(true);
        expect(validator("1", $elem)).toBe(true);
        expect(validator("2", $elem)).toBe(true);
        expect(validator("3", $elem)).toBe(true);
        expect(validator("4", $elem)).toBe(true);
        expect(validator("5", $elem)).toBe(true);
        expect(validator("6", $elem)).toBe(true);
        expect(validator("7", $elem)).toBe(true);
        expect(validator("8", $elem)).toBe(true);
        expect(validator("9", $elem)).toBe(true);
        expect(validator("10", $elem)).toBe(true);
        expect(validator("-1", $elem)).toEqual({
          error_message_type: 'integer_min_included',
          max: 10,
          min: 0
        });
        return expect(validator("11", $elem)).toEqual({
          error_message_type: 'integer_max_included',
          max: 10,
          min: 0
        });
      });
      it("negative integer with min", function() {
        var $elem, validator;
        log("negative integer with min");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.integer.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='-10' data-fv-max='0' data-fv-include-max='false' />");
        expect(validator("-1", $elem)).toBe(true);
        expect(validator("-2", $elem)).toBe(true);
        expect(validator("-3", $elem)).toBe(true);
        expect(validator("-4", $elem)).toBe(true);
        expect(validator("-5", $elem)).toBe(true);
        expect(validator("-6", $elem)).toBe(true);
        expect(validator("-7", $elem)).toBe(true);
        expect(validator("-8", $elem)).toBe(true);
        expect(validator("-9", $elem)).toBe(true);
        expect(validator("-10", $elem)).toBe(true);
        expect(validator("-11", $elem)).toEqual({
          error_message_type: 'integer_min_included',
          max: 0,
          min: -10
        });
        return expect(validator("0", $elem)).toEqual({
          error_message_type: 'integer_max',
          max: 0,
          min: -10
        });
      });
      it("number", function() {
        var $elem, validator;
        log("number");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.number.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='number' />");
        expect(validator("0", $elem)).toBe(true);
        expect(validator("0.00", $elem)).toBe(true);
        expect(validator("1", $elem)).toBe(true);
        expect(validator("100", $elem)).toBe(true);
        expect(validator("+5", $elem)).toBe(true);
        expect(validator("+ 5", $elem)).toBe(true);
        expect(validator("+ 5 ", $elem)).toBe(true);
        expect(validator(" + 5 ", $elem)).toBe(true);
        expect(validator("-5", $elem)).toBe(true);
        expect(validator("- 5", $elem)).toBe(true);
        expect(validator(" - 5", $elem)).toBe(true);
        expect(validator("- 5 ", $elem)).toBe(true);
        expect(validator("-.4", $elem)).toBe(true);
        expect(validator("1.25", $elem)).toBe(true);
        expect(validator("0.1", $elem)).toBe(true);
        expect(validator(" - 0.1", $elem)).toBe(true);
        expect(validator(" - 0.1 ", $elem)).toBe(true);
        expect(validator("1e7", $elem)).toEqual({
          error_message_type: "number"
        });
        expect(validator("Infinity", $elem)).toEqual({
          error_message_type: "number"
        });
        expect(validator("-Infinity", $elem)).toEqual({
          error_message_type: "number"
        });
        expect(validator("0.1a2", $elem)).toEqual({
          error_message_type: "number"
        });
        return expect(validator("asdf", $elem)).toEqual({
          error_message_type: "number"
        });
      });
      it("positive number", function() {
        var $elem, validator;
        log("positive number");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.number.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='number' data-fv-min='0' />");
        expect(validator("0", $elem)).toBe(true);
        expect(validator("1", $elem)).toBe(true);
        expect(validator("100", $elem)).toBe(true);
        expect(validator("+5", $elem)).toBe(true);
        expect(validator("+ 5", $elem)).toBe(true);
        expect(validator("+ 5 ", $elem)).toBe(true);
        expect(validator(" + 5 ", $elem)).toBe(true);
        expect(validator("1.25", $elem)).toBe(true);
        expect(validator("0.1", $elem)).toBe(true);
        expect(validator("-5", $elem)).toEqual({
          error_message_type: 'number_min_included',
          min: 0
        });
        expect(validator("- 5.2", $elem)).toEqual({
          error_message_type: 'number_min_included',
          min: 0
        });
        expect(validator(" - 5", $elem)).toEqual({
          error_message_type: 'number_min_included',
          min: 0
        });
        expect(validator("- 5 ", $elem)).toEqual({
          error_message_type: 'number_min_included',
          min: 0
        });
        expect(validator("1e7", $elem)).toEqual({
          error_message_type: 'number'
        });
        expect(validator(" - 0.1", $elem)).toEqual({
          error_message_type: 'number_min_included',
          min: 0
        });
        return expect(validator(" - 0.1 ", $elem)).toEqual({
          error_message_type: 'number_min_included',
          min: 0
        });
      });
      it("negative number", function() {
        var $elem, validator;
        log("negative number");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.number.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='number' data-fv-max='0' data-fv-include-max='false' />");
        expect(validator("-5", $elem)).toBe(true);
        expect(validator("- 5.1", $elem)).toBe(true);
        expect(validator(" - 5", $elem)).toBe(true);
        expect(validator("- 5.3 ", $elem)).toBe(true);
        expect(validator("0", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        expect(validator("1", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        expect(validator("100", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        expect(validator("+5", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        expect(validator("+ 5", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        expect(validator("+ 5 ", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        expect(validator(" + 5 ", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        expect(validator("1e7", $elem)).toEqual({
          error_message_type: 'number'
        });
        expect(validator("-Infinity", $elem)).toEqual({
          error_message_type: 'number'
        });
        expect(validator("1.25", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
        return expect(validator("0.1", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0
        });
      });
      it("positive number with max", function() {
        var $elem, validator;
        log("positive number with max");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.number.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='number' data-fv-min='0' data-fv-max='10.5' />");
        expect(validator("0", $elem)).toBe(true);
        expect(validator("1.1", $elem)).toBe(true);
        expect(validator("2.2", $elem)).toBe(true);
        expect(validator("3.3", $elem)).toBe(true);
        expect(validator("4.4", $elem)).toBe(true);
        expect(validator("5.5", $elem)).toBe(true);
        expect(validator("6.6", $elem)).toBe(true);
        expect(validator("7.7", $elem)).toBe(true);
        expect(validator("8.8", $elem)).toBe(true);
        expect(validator("9.9", $elem)).toBe(true);
        expect(validator("10.10", $elem)).toBe(true);
        expect(validator("-.1", $elem)).toEqual({
          error_message_type: 'number_min_included',
          max: 10.5,
          min: 0
        });
        return expect(validator("10.6", $elem)).toEqual({
          error_message_type: 'number_max_included',
          max: 10.5,
          min: 0
        });
      });
      it("negative number with min", function() {
        var $elem, validator;
        log("negative number with min");
        validator = function(str, elem) {
          var key, res, val;
          res = validators.number.call(validators, str, elem);
          if (res === true) {
            return true;
          }
          for (key in res) {
            val = res[key];
            if (key[0] === "_") {
              delete res[key];
            }
          }
          return res;
        };
        $elem = $("<input type='text' data-fv-validate='integer' data-fv-min='-10.1' data-fv-max='0' data-fv-include-max='false' />");
        expect(validator("-1.1", $elem)).toBe(true);
        expect(validator("-2.2", $elem)).toBe(true);
        expect(validator("-3.3", $elem)).toBe(true);
        expect(validator("-4.4", $elem)).toBe(true);
        expect(validator("-5.5", $elem)).toBe(true);
        expect(validator("-6.6", $elem)).toBe(true);
        expect(validator("-7.7", $elem)).toBe(true);
        expect(validator("-8.8", $elem)).toBe(true);
        expect(validator("-9.9", $elem)).toBe(true);
        expect(validator("-10.10", $elem)).toBe(true);
        expect(validator("-10.2", $elem)).toEqual({
          error_message_type: 'number_min_included',
          max: 0,
          min: -10.1
        });
        return expect(validator("0.01", $elem)).toEqual({
          error_message_type: 'number_max',
          max: 0,
          min: -10.1
        });
      });
      it("phone", function() {
        var validator;
        log("phone");
        validator = function(str) {
          return validators.phone.call(validators, str);
        };
        expect(validator("030/1234-67")).toBe(true);
        expect(validator("(+49) 30/1234-678")).toBe(true);
        expect(validator("03")).toEqual({
          error_message_type: "phone_length",
          length: 3
        });
        expect(validator("030 / asfd")).toEqual({
          error_message_type: "phone"
        });
        return expect(validator("(+1) 603-USA")).toEqual({
          error_message_type: "phone"
        });
      });
      it("text", function() {
        var validator;
        log("text");
        validator = function(str) {
          return validators.text.call(validators, str);
        };
        expect(validator("f***ing anything is valid!")).toBe(true);
        expect(validator("even")).toBe(true);
        expect(validator("null")).toBe(true);
        expect(validator("or")).toBe(true);
        expect(validator("undefined")).toBe(true);
        return expect(validator("")).toBe(false);
      });
      it("radio", function() {
        var invalid_buttons, valid_buttons, validator;
        log("radio");
        validator = function(str, elem) {
          return validators.radio.call(validators, str, elem);
        };
        valid_buttons = $("<input type=\"radio\" name=\"my_name\" value=\"value1\" />\n<input type=\"radio\" name=\"my_name\" value=\"value2\"  />\n<input type=\"radio\" name=\"my_name\" value=\"value3\" checked />\n<input type=\"radio\" name=\"my_name\" value=\"value4\" />\n<input type=\"radio\" name=\"my_name\" value=\"value5\" />");
        invalid_buttons = $("<input type=\"radio\" name=\"my_name2\" value=\"value1\" />\n<input type=\"radio\" name=\"my_name2\" value=\"value2\" />\n<input type=\"radio\" name=\"my_name2\" value=\"value3\" />\n<input type=\"radio\" name=\"my_name2\" value=\"value4\" />\n<input type=\"radio\" name=\"my_name2\" value=\"value5\" />");
        $(document.body).append(valid_buttons).append(invalid_buttons);
        expect(validator(null, valid_buttons.first())).toBe(true);
        expect(validator("any string...totally not interesting", valid_buttons.first())).toBe(true);
        expect(validator("", invalid_buttons.first())).toBe(false);
        valid_buttons.remove();
        return invalid_buttons.remove();
      });
      it("checkbox", function() {
        var invalid_buttons, valid_buttons, validator;
        log("checkbox");
        validator = function(str, elem) {
          return validators.checkbox.call(validators, str, elem);
        };
        valid_buttons = $("<input type=\"checkbox\" name=\"my_name\" value=\"value1\" checked />");
        invalid_buttons = $("<input type=\"checkbox\" name=\"my_name2\" value=\"value1\" />");
        $(document.body).append(valid_buttons).append(invalid_buttons);
        expect(validator(null, valid_buttons)).toBe(true);
        expect(validator("any string...totally not interesting", valid_buttons)).toBe(true);
        expect(validator("", invalid_buttons)).toBe(false);
        valid_buttons.remove();
        return invalid_buttons.remove();
      });
      return it("select", function() {
        var invalid_buttons, valid_buttons, valid_buttons2, validator;
        log("select");
        validator = function(str, elem) {
          return validators.select.call(validators, str, elem);
        };
        valid_buttons = $("<select name=\"my_name\">\n    <option value=\"value1\">val1<option>\n    <option value=\"value2\" selected>val2<option>\n    <option value=\"value3\">val3<option>\n</select>");
        valid_buttons2 = $("<select name=\"my_name\">\n    <option value=\"value1\">val1<option>\n    <option value=\"value2\" selected>val2<option>\n    <option value=\"value3\">val3<option>\n</select>");
        invalid_buttons = $("<select name=\"my_name2\">\n    <option value=\"\">- please select an option -<option>\n    <option value=\"value2\">val2<option>\n    <option value=\"value3\">val3<option>\n</select>");
        $(document.body).append(valid_buttons).append(valid_buttons2).append(invalid_buttons);
        expect(validator(null, valid_buttons)).toBe(true);
        expect(validator("any string...totally not interesting", valid_buttons)).toBe(true);
        expect(validator(null, valid_buttons2)).toBe(true);
        expect(validator("", invalid_buttons)).toBe(false);
        valid_buttons.remove();
        valid_buttons2.remove();
        return invalid_buttons.remove();
      });
    });
  };

  include_general_behavior_tests = function() {
    return describe("general behavior", function() {
      log("general behavior");
      return describe("return value + side fx", function() {
        log("return value + side fx");
        beforeEach(function() {
          var errors, form_validator, html, name, val, values_by_name;
          html = $(FORM_HTML);
          $(document.body).append(html);
          this.values_by_name = values_by_name = {
            text: "",
            en_number: "asdf",
            de_number: "0bsdf9345",
            optional_integer: "",
            integer: "34,-",
            phone: "asdf",
            email: "asdfas@domain",
            checkbox: "",
            radio: ""
          };
          for (name in values_by_name) {
            val = values_by_name[name];
            html.find("[name='" + name + "']").val(val);
          }
          form_validator = FormValidator["new"](html.first(), {
            preprocessors: {
              integer: function(val, elem) {
                return val.replace(/\,\-/g, "");
              }
            },
            postprocessors: {
              integer: function(val, elem) {
                return val + ",-";
              }
            },
            locale: "de"
          });
          errors = form_validator.validate();
          console.log(errors);
          this.html = html;
          return this.errors = errors;
        });
        afterEach(function() {
          return this.html.remove();
        });
        it("return value", function() {
          var error, j, len, ref;
          expect(this.errors.length).toBe(10);
          ref = this.errors;
          for (j = 0, len = ref.length; j < len; j++) {
            error = ref[j];
            delete error.element;
            delete error.validator;
          }
          return expect(this.errors).toEqual([
            {
              "message": FormValidator.error_messages.de.text({
                index_of_type: 1
              }),
              "required": true,
              "type": "text",
              "value": ""
            }, {
              "message": FormValidator.error_messages.de.number.replace("{{value}}", this.values_by_name.en_number),
              "required": true,
              "type": "number",
              "value": this.values_by_name.en_number
            }, {
              "message": FormValidator.error_messages.de.number.replace("{{value}}", this.values_by_name.de_number),
              "required": true,
              "type": "number",
              "value": this.values_by_name.de_number
            }, {
              "message": FormValidator.error_messages.de.phone.replace("{{value}}", this.values_by_name.phone),
              "required": false,
              "type": "phone",
              "value": this.values_by_name.phone
            }, {
              "message": FormValidator.error_messages.de.email_dot.replace("{{value}}", this.values_by_name.email),
              "required": true,
              "type": "email",
              "value": this.values_by_name.email
            }, {
              "message": FormValidator.error_messages.de.checkbox.replace("{{index_of_type}}", 1),
              "required": true,
              "type": "checkbox",
              "value": ""
            }, {
              "message": FormValidator.error_messages.de.checkbox.replace("{{index_of_type}}", 2),
              "required": true,
              "type": "checkbox",
              "value": ""
            }, {
              "message": FormValidator.error_messages.de.radio.replace("{{index_of_type}}", 1),
              "required": true,
              "type": "radio",
              "value": ""
            }, {
              "message": FormValidator.error_messages.de.radio.replace("{{index_of_type}}", 2),
              "required": true,
              "type": "radio",
              "value": ""
            }, {
              "message": FormValidator.error_messages.de.select.replace("{{index_of_type}}", 1),
              "required": true,
              "type": "select",
              "value": ""
            }
          ]);
        });
        return it("side fx", function() {
          console.log(this.html);
          expect(this.html.find(".textlabel").hasClass("red-color class2")).toBe(true);
          expect(this.html.find("[data-fv-name='numberlabel-en']").hasClass("red-color class2")).toBe(true);
          expect(this.html.find("[data-fv-name='numberlabel-de']").hasClass("red-color class2")).toBe(true);
          expect(this.html.find("[name='email']").hasClass("red-color class2")).toBe(true);
          expect(this.html.find("[data-fv-name='error1']").hasClass("red-color bold")).toBe(true);
          expect($(".outsider").hasClass("red-color class2")).toBe(true);
          expect(this.html.find("[name='checkbox']").hasClass("red-color class2")).toBe(true);
          return expect(this.html.find("select").hasClass("red-color class2")).toBe(true);
        });
      });
    });
  };

  include_dependency_tests = function() {
    return describe("dependencies", function() {
      log("dependencies");
      beforeEach(function() {
        var errors, form_validator, html;
        html = $(FORM_HTML);
        $(document.body).append(html);
        form_validator = FormValidator["new"](html.first(), {
          locale: "de",
          field_getter: function(form) {
            return form.find(".dependencies input");
          }
        });
        errors = form_validator.validate();
        console.log(errors);
        this.html = html;
        return this.errors = errors;
      });
      afterEach(function() {
        return this.html.remove();
      });
      return it("return value", function() {
        return expect(this.errors.length).toBe(10);
      });
    });
  };

  include_constraint_tests = function() {
    return describe("constraints", function() {
      log("constraints");
      beforeEach(function() {
        var errors, form_validator, html;
        html = $(FORM_HTML);
        $(document.body).append(html);
        form_validator = FormValidator["new"](html.first(), {
          locale: "de",
          field_getter: function(form) {
            return form.find(".constraints input");
          }
        });
        errors = form_validator.validate();
        console.log(errors);
        this.html = html;
        return this.errors = errors;
      });
      afterEach(function() {
        return this.html.remove();
      });
      return it("return value", function() {
        return expect(this.errors.length).toBe(10);
      });
    });
  };

  FORM_HTML = "<form action=\"\" method=\"get\" data-fv-error-classes=\"red-color class2\">\n\n    <span class=\"textlabel\">text:</span>\n    <input type=\"text\" name=\"text\" value=\"\" data-fv-validate=\"text\" data-fv-error-targets=\".textlabel\" /><br />\n\n    <span data-fv-name=\"numberlabel-en\">english format number:</span>\n    <input type=\"text\" name=\"en_number\" value=\"\" data-fv-validate=\"number\" data-fv-preprocess=\"false\" data-fv-postprocess=\"false\" data-fv-error-targets=\"numberlabel-en\" /><br />\n\n    <span data-fv-name=\"numberlabel-de\">german format number:</span>\n    <input type=\"text\" name=\"de_number\" value=\"\" data-fv-validate=\"number\" data-fv-error-targets=\"numberlabel-de\" /><br />\n\n    <span data-fv-name=\"integerlabel\">optional integer:</span>\n    <input type=\"text\" name=\"optional_integer\" value=\"\" data-fv-validate=\"integer\" data-fv-optional=\"true\" data-fv-error-targets=\"self\" /><br />\n\n    <span data-fv-name=\"integerlabel\">integer:</span>\n    <input type=\"text\" name=\"integer\" value=\"\" data-fv-validate=\"integer\" /><br />\n\n    <span data-fv-name=\"phonelabel\">optional phone:</span>\n    <input type=\"text\" name=\"phone\" value=\"\" data-fv-validate=\"phone\" data-fv-optional=\"true\" /><br />\n\n    <span data-fv-name=\"emaillabel\">email:</span>\n    <input type=\"text\" name=\"email\" value=\"\" data-fv-validate=\"email\" data-fv-error-targets=\"self error1 .outsider\" /><br />\n\n    <span data-fv-name=\"checkboxlabel\">checkbox:</span>\n    <input type=\"checkbox\" name=\"checkbox\" value=\"v1\" data-fv-validate=\"checkbox\" data-fv-error-targets=\"self checkboxlabel\" />\n    <input type=\"checkbox\" name=\"checkbox\" value=\"v2\" data-fv-validate=\"checkbox\" />\n    <br />\n\n    <span data-fv-name=\"radiolabel\">radio button:</span>\n    <input type=\"radio\" name=\"radio\" value=\"v1\" data-fv-validate=\"radio\" />\n    <input type=\"radio\" name=\"radio\" value=\"v2\" data-fv-validate=\"radio\" />\n    <br />\n\n    <select data-fv-validate=\"select\" data-fv-error-targets=\"self\">\n        <option value=\"\">Bitte wählen</option>\n        <option value=\"mr\">Herr</option>\n        <option value=\"mrs\">Frau</option>\n    </select>\n    <br />\n\n    <div class=\"dependencies\">\n        <h4>Dependencies</h4>\n\n        <input type=\"text\" data-fv-validate=\"number\" data-fv-name=\"master\" data-fv-preprocess=\"false\" data-fv-postprocess=\"false\" /><br />\n        <input type=\"text\" data-fv-validate=\"text\" data-fv-name=\"slave\" data-fv-depends-on=\"master\" /><br />\n    </div>\n\n    <div class=\"constraints\">\n        <h4>Constraints</h4>\n\n        <span data-fv-name=\"max_min\">min and max:</span>\n        <input type=\"text\" data-fv-validate=\"number\" data-fv-min=\"1\" data-fv-max=\"4\" data-fv-include-max=\"false\" value=\"4\" /><br />\n    </div>\n\n    <hr />\n    <div data-fv-name=\"error1\" data-fv-error-classes=\"red-color bold\">\n        text in some div (INSIDE THE FORM TAG, USING data-fv-name) that should become red and bold for any form field with 'error1' as error target\n    </div>\n</form>\n\n<div class=\"outsider\">\n    text in some div (OUTSIDE THE FORM TAG, USING class) that should become red and bold for any form field with '.outsider' as error target\n</div>";

  log = function(name) {
    var i, j, k, padStr, ref, ref1, ref2, ref3, rem, s, str;
    str = "***********************************************************************";
    if (name != null) {
      padStr = "*****";
      rem = (str.length - name.length - 2) / 2;
      s = padStr;
      for (i = j = ref = padStr.length, ref1 = Math.floor(rem); ref <= ref1 ? j <= ref1 : j >= ref1; i = ref <= ref1 ? ++j : --j) {
        s += " ";
      }
      s += name;
      for (i = k = ref2 = padStr.length, ref3 = Math.ceil(rem); ref2 <= ref3 ? k <= ref3 : k >= ref3; i = ref2 <= ref3 ? ++k : --k) {
        s += " ";
      }
      s += padStr;
      console.log(s);
    }
    console.log(str);
    return true;
  };

  beforeEach(function() {
    return log();
  });

  describe("Reusables", function() {
    return describe("FormValidator", function() {
      include_validator_tests();
      include_general_behavior_tests();
      include_dependency_tests();
      include_constraint_tests();
      return describe("progress", function() {});
    });
  });

  $(document).ready(function() {
    window.setTimeout(function() {
      return $(document.body).append(FORM_HTML);
    }, 1500);
    return true;
  });

}).call(this);
