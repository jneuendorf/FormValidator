// Generated by CoffeeScript 1.10.0
(function() {
  var DEBUG, locales,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  DEBUG = true;

  if (Array.prototype.unique == null) {
    Array.prototype.unique = function() {
      var elem, k, len, res;
      res = [];
      for (k = 0, len = this.length; k < len; k++) {
        elem = this[k];
        if (indexOf.call(res, elem) < 0) {
          res.push(elem);
        }
      }
      return res;
    };
  }

  if ($.fn.attrAll == null) {
    $.fn.attrAll = function(propName, delimiter, unique) {
      var result;
      if (delimiter == null) {
        delimiter = " ";
      }
      if (unique == null) {
        unique = true;
      }
      result = [];
      this.each(function(idx, elem) {
        result.push($(elem).attr(propName));
        return true;
      });
      if (unique) {
        result = result.unique();
      }
      return result.join(delimiter);
    };
  }

  locales = {
    error_messages: {
      de: {
        email: "'{{value}}' ist keine gültige E-Mail-Adresse",
        email_at: "Eine E-Mail-Adresse muss ein @-Zeichen enthalten",
        email_many_at: "Eine E-Mail-Adresse darf höchstens ein @-Zeichen enthalten",
        email_dot: "'{{value}}' ist keine gültige E-Mail-Adresse (nach dem @ ist kein Punkt)",
        integer: "'{{value}}' ist keine Zahl",
        integer_float: "'{{value}}' ist keine ganze Zahl",
        positive_integer: "'{{value}}' ist keine positive ganze Zahl",
        negative_integer: "'{{value}}' ist keine negative ganze Zahl",
        number: "'{{value}}' ist keine Zahl",
        number_max: "'{{value}}' ist nicht kleiner als {{max}}",
        number_min: "'{{value}}' ist nicht größer als {{min}}",
        number_max_min: "'{{value}}' liegt nicht zwischen {{min}} und {{max}}",
        number_max_included: "'{{value}}' ist nicht kleiner oder gleich {{max}}",
        number_min_included: "'{{value}}' ist nicht größer oder gleich {{min}}",
        number_max_included_min: "'{{value}}' ist nicht größer als {{min}} und kleiner oder gleich {{max}}",
        number_max_min_included: "'{{value}}' ist nicht größer oder gleich {{min}} und kleiner als {{max}}",
        number_max_included_min_included: "'{{value}}' ist nicht größer oder gleich {{min}} und kleiner oder gleich {{max}}",
        phone_length: "'{{value}}' ist weniger als {{length}} Zeichen lang",
        phone: "'{{value}}' ist keine gültige Telefonnummer",
        radio: "Die {{index_of_type}}. Auswahlbox wurde nicht ausgewählt",
        checkbox: "Die {{index_of_type}}. Checkbox wurde nicht ausgewählt",
        select: "Das {{index_of_type}}. Auswahlmenü wurde nicht ausgewählt",
        dependency: "Dieses Feld kann erst ausgefüllt werden, nachdem andere Felder korrekt ausgefüllt wurden",
        text: function(params) {
          if (params.name != null) {
            return "Bitte füllen Sie das Feld '" + params.name + "' aus";
          }
          if (params.previous_name) {
            return "Bitte füllen Sie das Feld nach '" + params.previous_name + "' aus";
          }
          return "Bitte füllen Sie das " + params.index_of_type + ". Textfeld aus";
        }
      },
      en: {
        email: "'{{value}}' is no valid e-mail address",
        integer: "'{{value}}' is no valid integer",
        positive_integer: "'{{value}}' is no positive integer",
        negative_integer: "'{{value}}' is no negative integer",
        number: "'{{value}}' is no valid number",
        positive_number: "'{{value}}' is no positive number",
        negative_number: "'{{value}}' is no negative number",
        phone: "'{{value}}' is no valid phone number",
        radio: "The {{index_of_type}}. radio button was not selected",
        checkbox: "The {{index_of_type}}. checkbox was not checked",
        select: "Nothing was selected in the {{index_of_type}}. drop-down menu",
        dependency: "This field can only be filled in after filling in other fields",
        text: function(params) {
          if (params.name != null) {
            return "Please fill in the field '" + params.name + "'";
          }
          if (params.previous_name) {
            return "Please fill in the field after '" + params.previous_name + "'";
          }
          return "Please fill in the " + params.index_of_type + ". text field";
        }
      }
    }
  };

  window.FormValidator = (function() {
    FormValidator.validators = {
      email: function(str, elem) {
        var parts;
        if (str.indexOf("@") < 0) {
          return {
            error_message_type: "email_at"
          };
        }
        parts = str.split("@");
        if (parts.length > 2) {
          return {
            error_message_type: "email_many_at"
          };
        }
        if (parts.length === 2 && parts[0] !== "" && parts[1] !== "") {
          if (str.indexOf(".", str.indexOf("@")) < 0) {
            return {
              error_message_type: "email_dot"
            };
          }
          return true;
        }
        return {
          error_message_type: "email"
        };
      },
      integer: function(str, elem, min, max, include_min, include_max) {
        var n, res;
        res = this._number(str, elem, min, max, include_min, include_max);
        if (res.valid === true) {
          if (res._number === Math.floor(res._number)) {
            return true;
          }
          return {
            error_message_type: "integer_float"
          };
        }
        str = res._string;
        n = Math.floor(res._number);
        if (isNaN(n) || !isFinite(n) || str !== ("" + n)) {
          return {
            error_message_type: "integer"
          };
        }
        res.error_message_type = res.error_message_type.replace("number_", "integer_");
        return res;
      },
      number: function(str, elem, min, max, include_min, include_max) {
        var res;
        res = this._number(str, elem, min, max, include_min, include_max);
        if (res.valid === true) {
          return true;
        }
        return res;
      },
      _number: function(str, elem, min, max, include_min, include_max) {
        var data_include_max, data_include_min, data_max, data_min, error_message_type, n, res, valid;
        if (include_min == null) {
          include_min = true;
        }
        if (include_max == null) {
          include_max = true;
        }
        str = str.replace(/\s/g, "");
        if (str[0] === "+") {
          str = str.slice(1);
        }
        if (str[0] === ".") {
          str = "0" + str;
        } else if (str[0] === "-" && str[1] === ".") {
          str = "-0." + (str.slice(2));
        }
        if (str.indexOf(".") >= 0) {
          while (str[str.length - 1] === "0") {
            str = str.slice(0, -1);
          }
          if (str[str.length - 1] === ".") {
            str = str.slice(0, -1);
          }
        }
        n = parseFloat(str);
        if (isNaN(n) || !isFinite(n) || str !== ("" + n)) {
          return {
            error_message_type: "number",
            _number: n,
            _string: str
          };
        }
        data_max = parseFloat(elem.attr("data-fv-max"));
        if (!isNaN(data_max)) {
          max = data_max;
          data_include_max = elem.attr("data-fv-include-max");
          if (data_include_max != null) {
            include_max = (data_include_max.toLowerCase() === "false" ? false : true);
          }
        }
        data_min = parseFloat(elem.attr("data-fv-min"));
        if (!isNaN(data_min)) {
          min = data_min;
          data_include_min = elem.attr("data-fv-include-min");
          if (data_include_min != null) {
            include_min = (data_include_min.toLowerCase() === "false" ? false : true);
          }
        }
        error_message_type = "number";
        valid = true;
        if ((max != null) && include_max && n > max) {
          error_message_type += "_max_included";
          valid = false;
        } else if ((max != null) && !include_max && n >= max) {
          error_message_type += "_max";
          valid = false;
        }
        if ((min != null) && include_min && n < min) {
          error_message_type += "_min_included";
          valid = false;
        } else if ((min != null) && !include_min && n <= min) {
          error_message_type = "_min";
          valid = false;
        }
        if (!valid) {
          res = {
            error_message_type: error_message_type,
            _number: n,
            _string: str
          };
          if (max != null) {
            res.max = max;
          }
          if (min != null) {
            res.min = min;
          }
          return res;
        }
        return {
          valid: true,
          _number: n,
          _string: str
        };
      },
      phone: function(str, elem) {
        if (str.length < 3) {
          return {
            error_message_type: "phone_length",
            length: 3
          };
        }
        str = str.replace(/[\s+\+\-\/\(\)]/g, "");
        while (str[0] === "0") {
          str = str.slice(1);
        }
        if (str !== ("" + (parseInt(str, 10)))) {
          return {
            error_message_type: "phone"
          };
        }
        return true;
      },
      text: function(str, elem) {
        return str.length > 0;
      },
      radio: function(str, elem) {
        return $("[name='" + elem.attr("name") + "']:checked").length > 0;
      },
      checkbox: function(str, elem) {
        return elem.prop("checked") === true;
      },
      select: function(str, elem) {
        return this.text(elem.val());
      }
    };

    FormValidator.get_error_message_type = function(special_type, error_mode) {
      var base_type;
      if (error_mode === this.ERROR_MODES.SIMPLE) {
        base_type = special_type.split("_")[0];
        switch (base_type) {
          case "integer":
            return "integer";
          case "number":
            return "number";
        }
      }
      return special_type;
    };

    FormValidator.default_preprocessors = {
      number: function(str, elem, locale) {
        if (locale === "de") {
          return str.replace(/\./g, "").replace(/\,/g, ".");
        }
        if (locale === "en") {
          return str.replace(/\,/g, "");
        }
        return str;
      },
      integer: function(str, elem, locale) {
        if (locale === "de") {
          return str.replace(/\./g, "").replace(/\,/g, ".");
        }
        if (locale === "en") {
          return str.replace(/\,/g, "");
        }
        return str;
      }
    };

    FormValidator.error_messages = locales.error_messages;

    FormValidator.ERROR_MODES = {
      NORMAL: "NORMAL",
      SIMPLE: "SIMPLE"
    };

    FormValidator.ERROR_MODES.DEFAULT = FormValidator.ERROR_MODES.NORMAL;

    FormValidator.ERROR_OUTPUT_MODES = {
      BELOW: "BELOW",
      BOOTSTRAP_POPOVER: "BOOTSTRAP_POPOVER",
      BOOTSTRAP_POPOVER_ON_FOCUS: "BOOTSTRAP_POPOVER_ON_FOCUS",
      NONE: "NONE"
    };

    FormValidator.ERROR_OUTPUT_MODES.DEFAULT = FormValidator.ERROR_OUTPUT_MODES.NONE;

    $(document).on("click", "[data-fv-start!='']", function() {
      var $elem, container, form_validator;
      $elem = $(this);
      container = $elem.closest($elem.attr("data-fv-start"));
      if (container.length === 1) {
        if ((form_validator = container.data("_form_validator")) == null) {
          form_validator = new FormValidator(container);
          container.data("_form_validator", form_validator);
        }
        form_validator.validate();
      }
      return true;
    });

    $(document).on("change click keyup", "[data-fv-real-time] [data-fv-validate]", function() {
      var $elem, container, form_validator;
      $elem = $(this);
      container = $elem.closest("[data-fv-real-time]");
      if (container.length === 1) {
        if ((form_validator = container.data("_form_validator")) == null) {
          form_validator = new FormValidator(container);
          container.data("_form_validator", form_validator);
        }
        form_validator.validate();
      }
      return true;
    });

    FormValidator["new"] = function(form, options) {
      return new this(form, options);
    };


    /**
    * @param form {Form}
    * @param options {Object}
    *
     */

    function FormValidator(form, options) {
      var CLASS;
      if (options == null) {
        options = {};
      }
      CLASS = this.constructor;
      if (form instanceof jQuery) {
        this.form = form;
      } else if (form != null) {
        this.form = $(form);
      } else if (DEBUG) {
        throw new Error("FormValidator::constructor: Invalid form given!");
      }
      this.fields = null;
      this.error_classes = this.form.attr("data-fv-error-classes") || options.error_classes || "";
      this.dependency_error_classes = this.form.attr("data-fv-dependency-error-classes") || options.dependency_error_classes || "";
      this.validators = $.extend({}, CLASS.validators, options.validators);
      this.validation_options = options.validation_options || null;
      this.error_messages = options.error_messages;
      this.error_mode = CLASS.ERROR_MODES[options.error_mode] != null ? options.error_mode : CLASS.ERROR_MODES.DEFAULT;
      this.error_output_mode = CLASS.ERROR_OUTPUT_MODES[options.error_output_mode] != null ? options.error_output_mode : CLASS.ERROR_OUTPUT_MODES.DEFAULT;
      this.locale = options.locale || "en";
      this.error_target_getter = options.error_target_getter || null;
      this.field_getter = options.field_getter || null;
      this.required_field_getter = options.required_field_getter || null;
      this.optional_field_getter = options.optional_field_getter || null;
      this.create_dependency_error_message = options.create_dependency_error_message || null;
      this.preprocessors = $.extend(CLASS.default_preprocessors, options.preprocessors || {});
      this.postprocessors = options.postprocessors || {};
      this.partition = options.partition || null;
    }

    FormValidator.prototype._update = function() {
      var fields;
      fields = this._get_fields(this.form);
      this.fields = {
        all: fields,
        required: this._get_required(fields),
        optional: this._get_optional(fields)
      };
      return this;
    };

    FormValidator.prototype._create_error_message = function(locale, params) {
      var CLASS, key, message, res, type, val;
      CLASS = this.constructor;
      type = params.error_message_type || params.element.attr("data-fv-validate");
      type = CLASS.get_error_message_type(type, this.error_mode);
      message = (this.error_messages || this.constructor.error_messages)[this.locale][type];
      if (message == null) {
        return null;
      }
      if (typeof message === "string") {
        for (key in params) {
          val = params[key];
          if (message.indexOf("{{" + key + "}}") >= 0) {
            message = message.replace("{{" + key + "}}", val);
          }
        }
        res = message;
      } else if (message instanceof Function) {
        res = message(params);
      }
      return res;
    };

    FormValidator.prototype._get_fields = function(form) {
      return (typeof this.field_getter === "function" ? this.field_getter(form) : void 0) || form.find("[data-fv-validate]").filter(function(idx, elem) {
        return $(elem).closest("[data-fv-ignore-children]").length === 0;
      });
    };

    FormValidator.prototype._get_required = function(fields) {
      var optional_fields, result;
      if (this.required_field_getter != null) {
        return typeof this.required_field_getter === "function" ? this.required_field_getter(fields) : void 0;
      }
      if (this.optional_field_getter != null) {
        result = $();
        optional_fields = this.optional_field_getter(fields);
        fields.each(function(idx, elem) {
          var $elem;
          $elem = $(elem);
          if (optional_fields.index($elem) === -1) {
            return result = result.add($elem);
          }
        });
        return result;
      }
      return fields.not("[data-fv-optional='true']");
    };

    FormValidator.prototype._get_optional = function(fields) {
      return (typeof this.optional_field_getter === "function" ? this.optional_field_getter(fields) : void 0) || fields.filter("[data-fv-optional='true']");
    };

    FormValidator.prototype._get_value = function(element, type) {
      var usedValFunc, value;
      usedValFunc = true;
      value = element.val();
      if (value == null) {
        usedValFunc = false;
        value = element.text();
      }
      if ((this.preprocessors[type] != null) && element.attr("data-fv-preprocess") !== "false") {
        value = this.preprocessors[type].call(this.preprocessors, value, element, this.locale);
      }
      return {
        usedValFunc: usedValFunc,
        value: value
      };
    };

    FormValidator.prototype._find_target = function(target) {
      var result;
      result = this.form.find("[data-fv-name='" + target + "']");
      if (result.length === 0) {
        result = this.form.find(target);
      }
      if (result.length === 0) {
        result = $(target);
      }
      return result;
    };

    FormValidator.prototype._apply_error_styles = function(element, error_targets, is_valid) {
      var error_classes, error_target, k, len, target, targets;
      if (error_targets != null) {
        if (typeof error_targets === "string") {
          error_targets = error_targets.split(/\s+/g);
        }
        targets = [];
        for (k = 0, len = error_targets.length; k < len; k++) {
          error_target = error_targets[k];
          if (error_target !== "self") {
            target = this._find_target(error_target);
          } else {
            target = element;
          }
          targets.push(target);
          if ((error_classes = target.attr("data-fv-error-classes")) != null) {
            if (is_valid === false) {
              target.addClass(error_classes);
            } else {
              target.removeClass(error_classes);
            }
          } else {
            if (is_valid === false) {
              target.addClass(this.error_classes);
            } else {
              target.removeClass(this.error_classes);
            }
          }
        }
      }
      return targets;
    };

    FormValidator.prototype._apply_dependency_error_styles = function(error_targets, is_valid) {
      var error_classes, k, len, target;
      if (error_targets != null) {
        for (k = 0, len = error_targets.length; k < len; k++) {
          target = error_targets[k];
          if ((error_classes = target.attr("data-fv-dependency-error-classes")) != null) {
            if (is_valid === false) {
              target.addClass(error_classes);
            } else {
              target.removeClass(error_classes);
            }
          } else {
            if (is_valid === false) {
              target.addClass(this.dependency_error_classes);
            } else {
              target.removeClass(this.dependency_error_classes);
            }
          }
        }
      }
      return this;
    };

    FormValidator.prototype._partition = function(fields) {
      var dict, elems, name;
      dict = {};
      fields.each(function(idx, elem) {
        var $elem, name;
        $elem = $(elem);
        name = $elem.attr("data-fv-group") || $elem.attr("name");
        if (dict[name] == null) {
          dict[name] = [$elem];
        } else {
          dict[name].push($elem);
        }
        return true;
      });
      return (function() {
        var results;
        results = [];
        for (name in dict) {
          elems = dict[name];
          results.push(elems);
        }
        return results;
      })();
    };

    FormValidator.prototype.set_error_target_getter = function(error_target_getter) {
      this.error_target_getter = error_target_getter;
      return this;
    };

    FormValidator.prototype.set_field_getter = function(field_getter) {
      this.field_getter = field_getter;
      return this;
    };

    FormValidator.prototype.set_required_field_getter = function(required_field_getter) {
      this.required_field_getter = required_field_getter;
      return this;
    };

    FormValidator.prototype.set_optional_field_getter = function(optional_field_getter) {
      this.optional_field_getter = optional_field_getter;
      return this;
    };


    /**
    * This method can be used to define a validator for a new type or to override an existing validator.
    *
    * @method register_validator
    * @param type {String}
    * The type the validator will validate.
     * Elements that are supposed to be validated by the new validator must have the type as data-fv-validate attribute.
    * @param validator {Function}
    * @param error_message_types {Array of String}
    * @return {Object}
    * An object with an error and a result key.
    *
     */

    FormValidator.prototype.register_validator = function(type, validator, error_message_types) {
      if (DEBUG) {
        if (validator.call instanceof Function && typeof (validator.call(this.validators, "", $())) === "boolean" && validator.error_message_types instanceof Array) {
          this.validators[type] = validator;
        } else {
          console.warn("FormValidator::register_validator: Invalid validator given (has no call method or not returning a boolean)!");
        }
      } else {
        this.validators[type] = validator;
      }
      return this;
    };

    FormValidator.prototype.deregister_validator = function(type) {
      delete this.validators[type];
      return this;
    };

    FormValidator.prototype.register_preprocessor = function(type, processor) {
      this.preprocessors[type] = processor;
      return this;
    };

    FormValidator.prototype.deregister_preprocessor = function(type) {
      delete this.preprocessors;
      return this;
    };

    FormValidator.prototype.register_postprocessor = function(type, processor) {
      this.postprocessors[type] = processor;
      return this;
    };

    FormValidator.prototype.deregister_postprocessor = function(type) {
      delete this.postprocessors[type];
      return this;
    };


    /**
    * @method validate
    * @param options {Object}
    * Default is this.validation_option. Otherwise:
    * Valid options are:
    *  - apply_error_styles:    {Boolean} (default is true)
    *  - all:                   {Boolean} (default is false)
    *
     */

    FormValidator.prototype.validate = function(options) {
      var CLASS, current_error, dependencies, dependency, dependency_elem, dependency_elements, dependency_errors, dependency_validation, depends_on, elem, error_message_params, error_targets, errors, fields, first_invalid_element, i, index_of_type, indices_by_type, info, is_required, is_valid, j, k, l, len, name, prev_name, ref, required, result, type, usedValFunc, validate_field, validation, validator, value;
      if (options == null) {
        options = this.validation_options || {
          apply_error_styles: true,
          all: false
        };
      }
      if (this.fields == null) {
        this._update();
      }
      CLASS = this.constructor;
      result = true;
      errors = [];
      prev_name = null;
      indices_by_type = {};
      usedValFunc = false;
      validate_field = (function(_this) {
        return function(field, info) {
          var ref, type, validation, validator, value;
          type = elem.attr("data-fv-validate");
          ref = _this._get_value(field, type), value = ref.value, usedValFunc = ref.usedValFunc;
          validator = _this.validators[type];
          validation = validator.call(_this.validators, value, elem);
          if (validation === false) {
            validation = {
              error_message_type: type
            };
          } else if (typeof validation === "string") {
            validation = {
              error_message_type: validation
            };
          }
          if (info != null) {
            info.type = type;
            info.usedValFunc = usedValFunc;
            info.validator = validator;
            info.value = value;
          }
          return validation;
        };
      })(this);
      required = this.fields.required;
      fields = this.fields.all;
      first_invalid_element = null;
      for (i = k = 1, ref = fields.length; 1 <= ref ? k <= ref : k >= ref; i = 1 <= ref ? ++k : --k) {
        elem = $(fields[i - 1]);
        is_required = required.index(elem) >= 0;
        info = {};
        validation = validate_field(elem, info);
        is_valid = validation === true;
        type = info.type, usedValFunc = info.usedValFunc, validator = info.validator, value = info.value;
        current_error = null;
        if (indices_by_type[type] != null) {
          index_of_type = ++indices_by_type[type];
        } else {
          indices_by_type[type] = 1;
          index_of_type = 1;
        }
        if (options.all === false && !is_required && (value.length === 0 || type === "radio" || type === "checkbox")) {
          this._apply_error_styles(elem, (typeof this.error_target_getter === "function" ? this.error_target_getter(type, elem, i) : void 0) || elem.attr("data-fv-error-targets") || elem.closest("[data-fv-error-targets]").attr("data-fv-error-targets"), true);
          continue;
        }
        name = elem.attr("data-fv-name");
        depends_on = elem.attr("data-fv-depends-on");
        dependency_errors = [];
        dependency_elements = [];
        if (depends_on != null) {
          dependencies = depends_on.split(/\s+/g);
          for (j = l = 0, len = dependencies.length; l < len; j = ++l) {
            dependency = dependencies[j];
            dependency_elem = this._find_target(dependency);
            dependency_elements.push(dependency_elem);
            info = {};
            dependency_validation = validate_field(dependency_elem, info);
            if (dependency_validation !== true) {
              dependency_errors.push($.extend(dependency_validation, {
                element: dependency_elem,
                index: j,
                type: info.type,
                value: info.value
              }));
            }
          }
        }
        if (!is_valid || dependency_errors.length > 0) {
          result = false;
          if (dependency_errors.length > 0) {
            errors.push({
              element: elem,
              message: (typeof this.create_dependency_error_message === "function" ? this.create_dependency_error_message(this.locale, dependency_errors) : void 0) || this._create_error_message(this.locale, {
                element: elem,
                error_message_type: "dependency"
              }),
              required: is_required,
              type: "dependency"
            });
            is_valid = false;
          }
          if (!is_valid) {
            error_message_params = $.extend(validation, {
              element: elem,
              index: i,
              index_of_type: index_of_type,
              name: name,
              previous_name: prev_name,
              value: value
            });
            current_error = {
              element: elem,
              message: this._create_error_message(this.locale, error_message_params),
              required: is_required,
              type: type,
              validator: validator,
              value: value
            };
            errors.push(current_error);
          }
        } else {
          if ((this.postprocessors[type] != null) && elem.attr("data-fv-postprocess") !== "false") {
            value = this.postprocessors[type].call(this.postprocessors, value, elem, this.locale);
            if (usedValFunc) {
              elem.val(value);
            } else {
              elem.text(value);
            }
          } else if (elem.attr("data-fv-output-preprocessed") === "true") {
            value = this.preprocessors[type].call(this.preprocessors, value, elem, this.locale);
            if (usedValFunc) {
              elem.val(value);
            } else {
              elem.text(value);
            }
          }
        }
        prev_name = name;
        if (options.apply_error_styles === true) {
          error_targets = this._apply_error_styles(elem, (typeof this.error_target_getter === "function" ? this.error_target_getter(type, elem, i) : void 0) || elem.attr("data-fv-error-targets") || elem.closest("[data-fv-error-targets]").attr("data-fv-error-targets"), is_valid);
          if (current_error != null) {
            current_error.error_targets = error_targets;
          }
          this._apply_dependency_error_styles(dependency_elements, is_valid);
          if (first_invalid_element == null) {
            first_invalid_element = elem;
            elem.focus();
          }
        }
      }
      return errors;
    };

    FormValidator.prototype.get_progress = function(as_percentage) {
      var all_optional, count, elem, error, errors, fields, found_error, group, groups, i, k, l, len, len1, len2, len3, m, o, required, total;
      if (as_percentage == null) {
        as_percentage = false;
      }
      if (this.fields == null) {
        this._update();
      }
      fields = this.fields.all;
      required = this.fields.required;
      groups = (typeof this.partition === "function" ? this.partition(fields) : void 0) || this._partition(fields);
      total = groups.length;
      count = 0;
      errors = this.validate({
        apply_error_styles: false,
        all: true
      });
      for (i = k = 0, len = groups.length; k < len; i = ++k) {
        group = groups[i];
        all_optional = true;
        for (l = 0, len1 = group.length; l < len1; l++) {
          elem = group[l];
          elem = $(elem);
          if (required.index(elem) >= 0) {
            all_optional = false;
            break;
          }
        }
        found_error = false;
        for (m = 0, len2 = group.length; m < len2; m++) {
          elem = group[m];
          elem = $(elem);
          for (o = 0, len3 = errors.length; o < len3; o++) {
            error = errors[o];
            if (!(error.element.is(elem))) {
              continue;
            }
            found_error = true;
            break;
          }
          if (found_error) {
            break;
          }
        }
        if (!found_error) {
          count++;
        }
      }
      if (!as_percentage) {
        return {
          count: count,
          total: total
        };
      }
      return count / total;
    };

    return FormValidator;

  })();

}).call(this);
