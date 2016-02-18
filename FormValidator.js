// Generated by CoffeeScript 1.10.0
(function() {
  var DEBUG, constraint_validators, error_messages, validators,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  DEBUG = true;

  if (Array.prototype.unique == null) {
    Array.prototype.unique = function() {
      var elem, j, len, res;
      res = [];
      for (j = 0, len = this.length; j < len; j++) {
        elem = this[j];
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

  validators = {
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
    _text: function(str, elem, min, max) {
      return str.length > 0;
    },
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
        if (str.indexOf(".", str.indexOf("@")) < 0 || str[str.length - 1] === ".") {
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
    text: function(str, elem, min, max) {
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

  constraint_validators = {
    blacklist: function(value, blacklist) {},
    max: function(value, max) {},
    max_length: function(value, max_length) {},
    min: function(value, min) {},
    min_length: function(value, min_length) {},
    regex: function(value, regex) {},
    whitelist: function(value, whitelist) {},
    include_max: function() {},
    include_min: function() {}
  };

  error_messages = {
    de: {
      email: "'{{value}}' ist keine gültige E-Mail-Adresse",
      email_at: "Eine E-Mail-Adresse muss ein @-Zeichen enthalten",
      email_many_at: "Eine E-Mail-Adresse darf höchstens ein @-Zeichen enthalten",
      email_dot: "'{{value}}' hat keine korrekte Endung (z.B. '.de')",
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
  };

  window.FormValidator = (function() {
    var CACHED_FIELD_DATA;

    FormValidator.constraint_validators = constraint_validators;

    FormValidator.validators = validators;

    FormValidator.error_messages = error_messages;

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

    CACHED_FIELD_DATA = ["depends_on", "name", "preprocess", "required", "type"];

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

    $(document).on("change click keyup", "[data-fv-real-time] [data-fv-validate]", function(evt) {
      var $elem, container, errors, form_validator;
      $elem = $(this);
      if ((evt.type === "click" || evt.type === "change") && $elem.filter("textarea, input[type='text'], input[type='number'], input[type='date'], input[type='month'], input[type='week'], input[type='time'], input[type='datetime'], input[type='datetime-local'], input[type='email'], input[type='search'], input[type='url']").length === $elem.length) {
        return true;
      }
      container = $elem.closest("[data-fv-real-time]");
      if (container.length === 1) {
        if ((form_validator = container.data("_form_validator")) == null) {
          form_validator = new FormValidator(container);
          container.data("_form_validator", form_validator);
        }
        errors = form_validator.validate();
        if (errors.length > 0) {
          $elem.focus();
        }
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
      this.error_classes = options.error_classes || this.form.attr("data-fv-error-classes") || "";
      this.dependency_error_classes = options.dependency_error_classes || this.form.attr("data-fv-dependency-error-classes") || "";
      this.validators = $.extend({}, CLASS.validators, options.validators);
      this.validation_options = options.validation_options || null;
      this.error_messages = options.error_messages;
      this.error_mode = CLASS.ERROR_MODES[options.error_mode] != null ? options.error_mode : CLASS.ERROR_MODES.DEFAULT;
      this.error_output_mode = CLASS.ERROR_OUTPUT_MODES[options.error_output_mode] != null ? options.error_output_mode : CLASS.ERROR_OUTPUT_MODES.DEFAULT;
      this.locale = options.locale || "en";
      this.error_target_getter = options.error_target_getter || null;
      this.field_getter = options.field_getter || null;
      this.required_field_getter = options.required_field_getter || null;
      this.create_dependency_error_message = options.create_dependency_error_message || null;
      this.preprocessors = $.extend(CLASS.default_preprocessors, options.preprocessors || {});
      this.postprocessors = options.postprocessors || {};
      this.group = options.group || null;
    }

    FormValidator.prototype._get_attribute_value_for_key = function(element, key) {
      var attribute, boolean, prefix, special, value;
      prefix = "data-fv-";
      special = {
        type: "validate",
        required: "optional"
      };
      boolean = ["preprocess", "required"];
      if (special[key] == null) {
        attribute = prefix + key.replace(/\_/g, "-");
      } else {
        attribute = prefix + special[key];
      }
      value = element.attr(attribute);
      if (value != null) {
        value = value.trim();
      }
      if (indexOf.call(boolean, key) >= 0) {
        value = value === "true" ? true : false;
      }
      if (key === "required") {
        value = !value;
      }
      return value;
    };

    FormValidator.prototype._set_element_data = function(element, data) {
      $.data(element[0], "_fv", data);
      return this;
    };

    FormValidator.prototype._get_element_data = function(element) {
      return $.data(element[0], "_fv");
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
      return (typeof this.required_field_getter === "function" ? this.required_field_getter(fields) : void 0) || fields.not("[data-fv-optional='true']");
    };

    FormValidator.prototype._get_value_info = function(element, data) {
      var original_value, preprocess, type, usedValFunc, value, value_has_changed;
      type = data.type, preprocess = data.preprocess;
      usedValFunc = true;
      value = element.val();
      if (value == null) {
        usedValFunc = false;
        value = element.text();
      }
      original_value = value;
      value_has_changed = original_value !== data.value;
      data.value = original_value;
      if ((this.preprocessors[type] != null) && preprocess !== false) {
        value = this.preprocessors[type].call(this.preprocessors, value, element, this.locale);
      }
      return {
        usedValFunc: usedValFunc,
        value: value,
        original_value: original_value,
        value_has_changed: value_has_changed
      };
    };

    FormValidator.prototype._find_targets = function(targets, element) {
      var target;
      if (typeof targets === "string") {
        return (function() {
          var j, len, ref, results1;
          ref = targets.split(/\s+/g);
          results1 = [];
          for (j = 0, len = ref.length; j < len; j++) {
            target = ref[j];
            results1.push(this._find_target(target, element));
          }
          return results1;
        }).call(this);
      }
      return targets || [];
    };

    FormValidator.prototype._find_target = function(target, element) {
      var result;
      if (target === "self") {
        return element;
      }
      result = this.form.find("[data-fv-name='" + target + "']");
      if (result.length === 0) {
        result = element.closest(target);
      }
      if (result.length === 0) {
        result = this.form.find(target);
      }
      if (result.length === 0) {
        result = $(target);
      }
      return result;
    };

    FormValidator.prototype._apply_error_styles = function(element, error_targets, is_valid) {
      var error_classes, j, len, target, targets;
      if (error_targets != null) {
        targets = this._find_targets(error_targets, element);
        for (j = 0, len = targets.length; j < len; j++) {
          target = targets[j];
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
        return targets;
      }
      return [];
    };

    FormValidator.prototype._apply_dependency_error_styles = function(element, error_targets, is_valid) {
      var error_classes, j, len, target, targets;
      if (error_targets != null) {
        targets = this._find_targets(error_targets, element);
        for (j = 0, len = targets.length; j < len; j++) {
          target = targets[j];
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
        return targets;
      }
      return [];
    };

    FormValidator.prototype._group = function(fields) {
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
        var results1;
        results1 = [];
        for (name in dict) {
          elems = dict[name];
          results1.push(elems);
        }
        return results1;
      })();
    };

    FormValidator.prototype._validate_element = function(element, data, value_info) {
      var type, validation, validator, value;
      type = data.type;
      value = value_info.value;
      validator = this.validators[type];
      if (validator == null) {
        throw new Error("FormValidator::_validate_element: No validator found for type '" + type + "'. Make sure the type is correct or define a validator!");
      }
      validation = validator.call(this.validators, value, element);
      if (validation === false) {
        validation = {
          error_message_type: type
        };
      } else if (typeof validation === "string") {
        validation = {
          error_message_type: validation
        };
      }
      return validation;
    };

    FormValidator.prototype._validate_dependencies = function(element, data) {
      var dependency_data, dependency_elem, dependency_validation, elements, errors, i, j, len, mode, valid;
      errors = [];
      elements = [];
      if (data.depends_on != null) {
        elements = data.depends_on;
        for (i = j = 0, len = elements.length; j < len; i = ++j) {
          dependency_elem = elements[i];
          elements.push(dependency_elem);
          dependency_data = this._get_element_data(dependency_elem);
          dependency_validation = this._validate_element(dependency_elem, dependency_data, this._get_value_info(dependency_elem, dependency_data));
          if (dependency_validation !== true) {
            errors.push($.extend(dependency_validation, {
              element: dependency_elem,
              index: i,
              type: type
            }));
          }
        }
      }
      if (data.dependency_mode == null) {
        data.dependency_mode = element.attr("data-fv-dependency-mode");
      }
      if (data.dependency_mode === "any") {
        valid = errors.length < elements.length;
        mode = "any";
      } else {
        valid = errors.length === 0;
        mode = "all";
      }
      return {
        dependency_errors: errors,
        dependency_elements: elements,
        valid_dependencies: valid,
        dependency_mode: data.dependency_mode
      };
    };

    FormValidator.prototype._validate_constraints = function(element, data) {
      var CLASS, constraint_name, constraint_validator, ref, results;
      CLASS = this.constructor;
      results = [];
      ref = CLASS.constraint_validators;
      for (constraint_name in ref) {
        constraint_validator = ref[constraint_name];
        true;
      }
      return results;
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

    FormValidator.prototype.cache = function() {
      var data, elem, fields, i, j, k, key, keys, len, ref;
      fields = this._get_fields(this.form);
      this.fields = {
        all: fields,
        required: this._get_required(fields)
      };
      for (i = j = 0, ref = fields.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        elem = fields.eq(i);
        data = this._get_element_data(elem);
        if (data == null) {
          keys = CACHED_FIELD_DATA;
          data = {
            dependency_mode: null,
            error_targets: null,
            group: null,
            output_preprocessed: null,
            postprocess: null,
            constraints: null,
            valid: null,
            value: null
          };
          for (k = 0, len = keys.length; k < len; k++) {
            key = keys[k];
            data[key] = this._get_attribute_value_for_key(elem, key);
          }
          data.depends_on = this._find_targets(data.depends_on, elem);
          this._set_element_data(elem, data);
        }
      }
      return this;
    };


    /**
    * @method validate
    * @param options {Object}
    * Default is this.validation_option. Otherwise:
    * Valid options are:
    *  - apply_error_styles:    {Boolean} (default is true)
    *  - all:                   {Boolean} (default is false)
    *  - focus_invalid:         {Boolean} (default is true)
    *  - recache:               {Boolean} (default is false)
    *
     */

    FormValidator.prototype.validate = function(options) {
      var CLASS, current_error, data, default_options, dependency_elements, dependency_errors, dependency_mode, elem, error_message_params, error_targets, errors, fields, first_invalid_element, i, index_of_type, indices_by_type, is_required, is_valid, j, k, len, name, original_value, prev_name, prev_phase_valid, ref, ref1, ref2, ref3, ref4, required, result, type, usedValFunc, valid_dependencies, validation, value, value_has_changed, value_info;
      if (options == null) {
        options = this.validation_options || {
          apply_error_styles: true,
          all: false,
          focus_invalid: true,
          recache: false
        };
      }
      default_options = {
        apply_error_styles: true,
        all: false,
        focus_invalid: true,
        recache: false
      };
      options = $.extend(default_options, this.validation_options, options);
      if ((this.fields == null) || options.recache === true) {
        this.cache();
      }
      CLASS = this.constructor;
      errors = [];
      prev_name = null;
      indices_by_type = {};
      usedValFunc = false;
      required = this.fields.required;
      fields = this.fields.all;
      first_invalid_element = null;
      for (i = j = 0, ref = fields.length; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        elem = fields.eq(i);
        data = this._get_element_data(elem);
        is_required = data.required;
        type = data.type, name = data.name;
        value_info = this._get_value_info(elem, data);
        value = value_info.value, original_value = value_info.original_value, value_has_changed = value_info.value_has_changed, usedValFunc = value_info.usedValFunc;
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
        prev_phase_valid = true;
        ref1 = this._validate_dependencies(elem, data), dependency_errors = ref1.dependency_errors, dependency_elements = ref1.dependency_elements, dependency_mode = ref1.dependency_mode, valid_dependencies = ref1.valid_dependencies;
        if (!valid_dependencies) {
          is_valid = false;
          prev_phase_valid = false;
          errors.push({
            element: elem,
            message: (typeof this.create_dependency_error_message === "function" ? this.create_dependency_error_message(this.locale, dependency_errors) : void 0) || this._create_error_message(this.locale, {
              element: elem,
              error_message_type: "dependency",
              dependency_mode: dependency_mode,
              dependency_errors: dependency_errors
            }),
            required: is_required,
            type: "dependency",
            mode: dependency_mode
          });
          if (first_invalid_element == null) {
            first_invalid_element = elem;
          }
        }
        if (value_has_changed) {
          if (prev_phase_valid) {
            validation = this._validate_element(elem, data, value_info);
            current_error = null;
            if (validation !== true) {
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
                value: value
              };
              errors.push(current_error);
              if (first_invalid_element == null) {
                first_invalid_element = elem;
              }
            }
          }
          if (prev_phase_valid) {
            ref2 = this._validate_constraints(elem, data);
            for (k = 0, len = ref2.length; k < len; k++) {
              result = ref2[k];
              if (result !== true) {
                errors.push({});
              }
            }
            true;
          }
        }
        if (prev_phase_valid) {
          data.valid = true;
          if (elem.attr("data-fv-postprocess") === "true") {
            value = (ref3 = this.postprocessors[type]) != null ? ref3.call(this.postprocessors, value, elem, this.locale) : void 0;
            if (usedValFunc) {
              elem.val(value);
            } else {
              elem.text(value);
            }
            if (current_error != null) {
              current_error.value = value;
            }
          } else if (elem.attr("data-fv-output-preprocessed") === "true") {
            value = (ref4 = this.preprocessors[type]) != null ? ref4.call(this.preprocessors, value, elem, this.locale) : void 0;
            if (usedValFunc) {
              elem.val(value);
            } else {
              elem.text(value);
            }
            if (current_error != null) {
              current_error.value = value;
            }
          }
        } else {
          data.valid = false;
        }
        if (options.apply_error_styles === true) {
          error_targets = this._apply_error_styles(elem, (typeof this.error_target_getter === "function" ? this.error_target_getter(type, elem, i) : void 0) || elem.attr("data-fv-error-targets") || elem.closest("[data-fv-error-targets]").attr("data-fv-error-targets"), prev_phase_valid);
          if (current_error != null) {
            current_error.error_targets = error_targets;
          }
          this._apply_dependency_error_styles(elem, dependency_elements, prev_phase_valid);
        }
        prev_name = name;
      }
      if (options.focus_invalid === true) {
        if (first_invalid_element != null) {
          first_invalid_element.focus();
        }
      }
      return errors;
    };

    FormValidator.prototype.get_progress = function(options) {
      var all_optional, count, elem, error, errors, fields, found_error, group, groups, i, j, k, l, len, len1, len2, len3, m, required, total;
      if (options == null) {
        options = {
          as_percentage: false,
          recache: false
        };
      }
      if ((this.fields == null) || options.recache === true) {
        this.cache();
      }
      fields = this.fields.all;
      required = this.fields.required;
      groups = (typeof this.group === "function" ? this.group(fields) : void 0) || this._group(fields);
      total = groups.length;
      count = 0;
      errors = this.validate({
        apply_error_styles: false,
        all: true
      });
      for (i = j = 0, len = groups.length; j < len; i = ++j) {
        group = groups[i];
        all_optional = true;
        for (k = 0, len1 = group.length; k < len1; k++) {
          elem = group[k];
          elem = $(elem);
          if (required.index(elem) >= 0) {
            all_optional = false;
            break;
          }
        }
        found_error = false;
        for (l = 0, len2 = group.length; l < len2; l++) {
          elem = group[l];
          elem = $(elem);
          for (m = 0, len3 = errors.length; m < len3; m++) {
            error = errors[m];
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
      if (!options.as_percentage) {
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
