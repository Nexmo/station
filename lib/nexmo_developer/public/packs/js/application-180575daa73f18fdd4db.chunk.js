(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["application"],{

/***/ "./app/javascript/api_status/index.js":
/*!********************************************!*\
  !*** ./app/javascript/api_status/index.js ***!
  \********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var whatwg_fetch__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! whatwg-fetch */ "./node_modules/whatwg-fetch/fetch.js");
/* harmony import */ var whatwg_fetch__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(whatwg_fetch__WEBPACK_IMPORTED_MODULE_0__);

/* harmony default export */ __webpack_exports__["default"] = (function () {
  fetch('https://xb8glk41jfrv.statuspage.io/api/v2/status.json').then(function (response) {
    return response.json();
  }).then(function (payload) {
    var color;

    switch (payload.status.indicator) {
      case 'major':
        color = 'red';

      case 'critical':
        color = 'red';

      case 'minor':
        color = 'yellow';

      default:
        color = 'green';
    }

    $('.Nxd-api-status').text(payload.status.description).addClass("Vlt-badge--" + color);
  });
});

/***/ }),

/***/ "./app/javascript/careers/index.js":
/*!*****************************************!*\
  !*** ./app/javascript/careers/index.js ***!
  \*****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Careers; });
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Careers =
/*#__PURE__*/
function () {
  function Careers() {
    _classCallCheck(this, Careers);

    this.departments = [];
    this.locations = [];
    this.setupListeners();
  }

  _createClass(Careers, [{
    key: "showCareer",
    value: function showCareer(career) {
      var department = career.getElementsByClassName('department')[0].dataset.department;
      var location = career.getElementsByClassName('location')[0].dataset.location;
      return (this.departments.includes(department) || this.departments.length === 0) && (this.locations.some(function (l) {
        return location.includes(l) || l.includes(location);
      }) || this.locations.length === 0);
    }
  }, {
    key: "toggleCareers",
    value: function toggleCareers() {
      Array.from(document.getElementsByClassName('Nxd-career')).forEach(function (career) {
        career.classList.toggle('hide', !this.showCareer(career));
      }, this);
      document.getElementById('no-results').classList.toggle('hide', document.querySelectorAll('.Nxd-career:not(.hide)').length !== 0);
      document.querySelectorAll('.Nxd-career:not(.hide)').forEach(function (career, index) {
        career.classList.toggle('striped', index % 2 == 0);
      });
    }
  }, {
    key: "updateURL",
    value: function updateURL() {
      var currentUrl = new URL(window.location.href);
      var query = {};

      if (this.departments.length > 0) {
        Object.assign(query, {
          departments: this.departments
        });
      }

      if (this.locations.length > 0) {
        Object.assign(query, {
          locations: this.locations.map(function (l) {
            return l.split(',')[0];
          })
        });
      }

      var params = new URLSearchParams(query);
      currentUrl.search = params;
      window.history.pushState({}, 'Careers', currentUrl);
    }
  }, {
    key: "dropdownValue",
    value: function dropdownValue(length, item) {
      var value;

      switch (length) {
        case 0:
          value = "".concat(item, "s");
          break;

        case 1:
          value = "1 ".concat(item, " selected");
          break;

        default:
          value = "".concat(length, " ").concat(item, "s selected");
      }

      return value;
    }
  }, {
    key: "updateDepartmentsDropdown",
    value: function updateDepartmentsDropdown() {
      var value = this.dropdownValue(this.departments.length, 'Department');
      document.querySelector('#department-filter button').innerText = value;
    }
  }, {
    key: "updateLocationsDropdown",
    value: function updateLocationsDropdown() {
      var value = this.dropdownValue(this.locations.length, 'Location');
      document.querySelector('#location-filter button').innerText = value;
    }
  }, {
    key: "departmentChangeHandler",
    value: function departmentChangeHandler(event) {
      if (event.target.checked) {
        this.departments.push(event.target.value);
      } else {
        this.departments.splice(this.departments.indexOf(event.target.value), 1);
      }

      this.updateURL();
      this.updateDepartmentsDropdown();
      this.toggleCareers();
    }
  }, {
    key: "locationChangeHandler",
    value: function locationChangeHandler(event) {
      if (event.target.checked) {
        this.locations.push(event.target.value);
      } else {
        this.locations.splice(this.locations.indexOf(event.target.value), 1);
      }

      this.updateURL();
      this.updateLocationsDropdown();
      this.toggleCareers();
    }
  }, {
    key: "setFiltersFromURL",
    value: function setFiltersFromURL() {
      var params = new URLSearchParams(window.location.search);
      this.departments = [];
      this.locations = [];
      params.get('departments') && params.get('departments').split(',').forEach(function (department) {
        this.departments.push(department);
        document.getElementById(department).checked = true;
      }, this);
      params.get('locations') && params.get('locations').split(',').forEach(function (location) {
        var checkbox = document.querySelector("[id^='".concat(location, "']"));

        if (checkbox) {
          this.locations.push(location);
          checkbox.checked = true;
        }
      }, this);
      this.updateDepartmentsDropdown();
      this.updateLocationsDropdown();
      this.toggleCareers();
    }
  }, {
    key: "setupListeners",
    value: function setupListeners() {
      var self = this;
      window.addEventListener('load', function () {
        if (!document.getElementById('careers')) {
          return;
        }

        self.toggleCareers();
        document.getElementById('department-filter').addEventListener('change', self.departmentChangeHandler.bind(self));
        document.getElementById('location-filter').addEventListener('change', self.locationChangeHandler.bind(self));
        self.setFiltersFromURL();
      });
      window.addEventListener('popstate', function (event) {
        if (!document.getElementById('careers')) {
          return;
        }

        self.setFiltersFromURL();
      });
    }
  }]);

  return Careers;
}();



/***/ }),

/***/ "./app/javascript/code_snippet_events/index.js":
/*!*****************************************************!*\
  !*** ./app/javascript/code_snippet_events/index.js ***!
  \*****************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony default export */ __webpack_exports__["default"] = (function () {
  var hasTriggeredCopyStat = {};
  var hasTriggeredLinkStat = {}; // Track copy to clipboard usage

  var clipboard = new Clipboard('.copy-button', {
    text: function text(trigger) {
      return $(trigger).next().text();
    }
  });
  clipboard.on('success', function (e) {
    var trigger = $(e.trigger);
    var params = {
      "language": trigger.attr("data-lang"),
      "snippet": trigger.attr("data-block"),
      "section": trigger.attr("data-section"),
      "event": "copy"
    };
    var key = params['language'] + params['section'] + params['snippet']; // We only want to track each copy once per page load

    if (hasTriggeredCopyStat[key]) {
      return true;
    }

    trigger.find('span').text('Copied');
    fetch(createRequest(params)).then(function (response) {
      if (response.ok) {
        return response.json();
      }

      return Promise.reject({
        message: 'Bad response from server',
        response: response
      });
    }).then(function (payload) {
      hasTriggeredCopyStat[key] = true;
    }); // Can we point them to the dependencies too?

    if (trigger.parent().hasClass("main-code")) {
      trigger.parent().parent().find(".configure-dependencies").prepend("<span class='label label--small'>Don't forget me!</span>");
    }
  });
  clipboard.on('error', function (e) {
    console.error('Action:', e.action);
    console.error('Trigger:', e.trigger);
  }); // Track source link usage

  $(document).on('mousedown', '.source-link', function (e) {
    if (e.which === 3) {
      return;
    }

    var trigger = $(this);
    var section = trigger.attr("data-section");
    var params = {
      "language": trigger.attr("data-lang"),
      "snippet": trigger.attr("data-block"),
      "section": section,
      "event": "source"
    };
    var key = params['language'] + params['section'];

    if (hasTriggeredLinkStat[key]) {
      return true;
    }

    fetch(createRequest(params)).then(function (response) {
      if (response.ok) {
        return response.json();
      }

      return Promise.reject({
        message: 'Bad response from server',
        response: response
      });
    }).then(function (payload) {
      hasTriggeredLinkStat[key] = true;
    });
  });
});

function createRequest(params) {
  return new Request('/usage/code_snippet', {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify(params),
    headers: {
      'Content-Type': 'application/json'
    }
  });
}

/***/ }),

/***/ "./app/javascript/components/concatenation/Concatenation.vue":
/*!*******************************************************************!*\
  !*** ./app/javascript/components/concatenation/Concatenation.vue ***!
  \*******************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _Concatenation_vue_vue_type_template_id_301089c4_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Concatenation.vue?vue&type=template&id=301089c4&scoped=true& */ "./app/javascript/components/concatenation/Concatenation.vue?vue&type=template&id=301089c4&scoped=true&");
/* harmony import */ var _Concatenation_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Concatenation.vue?vue&type=script&lang=js& */ "./app/javascript/components/concatenation/Concatenation.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _Concatenation_vue_vue_type_style_index_0_id_301089c4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css& */ "./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css&");
/* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");






/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_3__["default"])(
  _Concatenation_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _Concatenation_vue_vue_type_template_id_301089c4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"],
  _Concatenation_vue_vue_type_template_id_301089c4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  "301089c4",
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "app/javascript/components/concatenation/Concatenation.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./app/javascript/components/concatenation/Concatenation.vue?vue&type=script&lang=js&":
/*!********************************************************************************************!*\
  !*** ./app/javascript/components/concatenation/Concatenation.vue?vue&type=script&lang=js& ***!
  \********************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--8-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./Concatenation.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css&":
/*!****************************************************************************************************************************!*\
  !*** ./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css& ***!
  \****************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_style_loader_index_js_ref_3_0_node_modules_css_loader_dist_cjs_js_ref_3_1_node_modules_vue_loader_lib_loaders_stylePostLoader_js_node_modules_postcss_loader_lib_index_js_ref_3_2_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_style_index_0_id_301089c4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/style-loader??ref--3-0!../../../../node_modules/css-loader/dist/cjs.js??ref--3-1!../../../../node_modules/vue-loader/lib/loaders/stylePostLoader.js!../../../../node_modules/postcss-loader/lib??ref--3-2!../../../../node_modules/vue-loader/lib??vue-loader-options!./Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css& */ "./node_modules/style-loader/index.js?!./node_modules/css-loader/dist/cjs.js?!./node_modules/vue-loader/lib/loaders/stylePostLoader.js!./node_modules/postcss-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css&");
/* harmony import */ var _node_modules_style_loader_index_js_ref_3_0_node_modules_css_loader_dist_cjs_js_ref_3_1_node_modules_vue_loader_lib_loaders_stylePostLoader_js_node_modules_postcss_loader_lib_index_js_ref_3_2_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_style_index_0_id_301089c4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_node_modules_style_loader_index_js_ref_3_0_node_modules_css_loader_dist_cjs_js_ref_3_1_node_modules_vue_loader_lib_loaders_stylePostLoader_js_node_modules_postcss_loader_lib_index_js_ref_3_2_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_style_index_0_id_301089c4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__);
/* harmony reexport (unknown) */ for(var __WEBPACK_IMPORT_KEY__ in _node_modules_style_loader_index_js_ref_3_0_node_modules_css_loader_dist_cjs_js_ref_3_1_node_modules_vue_loader_lib_loaders_stylePostLoader_js_node_modules_postcss_loader_lib_index_js_ref_3_2_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_style_index_0_id_301089c4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__) if(__WEBPACK_IMPORT_KEY__ !== 'default') (function(key) { __webpack_require__.d(__webpack_exports__, key, function() { return _node_modules_style_loader_index_js_ref_3_0_node_modules_css_loader_dist_cjs_js_ref_3_1_node_modules_vue_loader_lib_loaders_stylePostLoader_js_node_modules_postcss_loader_lib_index_js_ref_3_2_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_style_index_0_id_301089c4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__[key]; }) }(__WEBPACK_IMPORT_KEY__));
 /* harmony default export */ __webpack_exports__["default"] = (_node_modules_style_loader_index_js_ref_3_0_node_modules_css_loader_dist_cjs_js_ref_3_1_node_modules_vue_loader_lib_loaders_stylePostLoader_js_node_modules_postcss_loader_lib_index_js_ref_3_2_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_style_index_0_id_301089c4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0___default.a); 

/***/ }),

/***/ "./app/javascript/components/concatenation/Concatenation.vue?vue&type=template&id=301089c4&scoped=true&":
/*!**************************************************************************************************************!*\
  !*** ./app/javascript/components/concatenation/Concatenation.vue?vue&type=template&id=301089c4&scoped=true& ***!
  \**************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_template_id_301089c4_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./Concatenation.vue?vue&type=template&id=301089c4&scoped=true& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=template&id=301089c4&scoped=true&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_template_id_301089c4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Concatenation_vue_vue_type_template_id_301089c4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ }),

/***/ "./app/javascript/components/concatenation/character_counter.js":
/*!**********************************************************************!*\
  !*** ./app/javascript/components/concatenation/character_counter.js ***!
  \**********************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var lodash_difference__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! lodash/difference */ "./node_modules/lodash/difference.js");
/* harmony import */ var lodash_difference__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(lodash_difference__WEBPACK_IMPORTED_MODULE_0__);
function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance"); }

function _iterableToArray(iter) { if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }


var GSM_STANDARD_CHARS = ['@', '0', '¡', 'P', '¿', 'p', '£', '_', '!', '1', 'A', 'Q', 'a', 'q', '$', '"', '2', 'B', 'R', 'b', 'r', '¥', '?', '#', '3', 'C', 'S', 'c', 's', 'è', '?', '4', 'D', 'T', 'd', 't', 'é', '?', '%', '5', 'E', 'U', 'e', 'u', 'ù', '6', 'F', 'V', 'f', 'v', 'ì', '?', "'", '7', 'G', 'W', 'g', 'w', 'ò', '(', '8', 'H', 'X', 'h', 'x', 'Ç', ')', '9', 'I', 'Y', 'i', 'y', '*', ':', 'J', 'Z', 'j', 'z', 'Ø', '+', ';', 'K', 'Ä', 'k', 'ä', 'Æ', ',', '<', 'L', 'l', 'ö', 'æ', '-', '=', 'M', 'Ñ', 'm', 'ñ', 'Å', 'ß', '.', '>', 'N', 'Ü', 'n', 'ü', 'å', 'É', '/', 'O', '§', 'o', 'à', ' ', '\r', '\n'];
var GSM_EXTENDED_CHARS = ['|', '^', '€', '{', '}', '[', ']', '~', '\\'];
var BYTE_SIZE = 8;
var CHARACTER_SIZE = 7;
var GSM_METADATA_LENGTH = 7;
var GSM_METADATA_SIZE = GSM_METADATA_LENGTH * CHARACTER_SIZE;
var GSM_MAX_SIZE = 140 * BYTE_SIZE;

var CharacterCounter =
/*#__PURE__*/
function () {
  function CharacterCounter(text) {
    _classCallCheck(this, CharacterCounter);

    this.text = text;
  }

  _createClass(CharacterCounter, [{
    key: "getInfo",
    value: function getInfo() {
      var messages = this.getMessages();
      return {
        messages: messages,
        unicodeRequired: this.isUnicodeRequired(),
        charactersCount: messages.reduce(function (sum, sms) {
          return sum + sms.length;
        }, 0)
      };
    }
  }, {
    key: "isUnicodeRequired",
    value: function isUnicodeRequired() {
      var remainder = lodash_difference__WEBPACK_IMPORTED_MODULE_0___default()(_toConsumableArray(this.text), [].concat(GSM_STANDARD_CHARS, GSM_EXTENDED_CHARS));
      return remainder.length !== 0;
    }
  }, {
    key: "getMessages",
    value: function getMessages() {
      return this.splitIntoSMS(GSM_MAX_SIZE);
    }
  }, {
    key: "splitIntoSMS",
    value: function splitIntoSMS(maxSize) {
      var index = 0;
      var messages = [];
      var text = this.text;

      while (index <= this.text.length) {
        var sms = this.getSMS(text, maxSize);
        messages.push(sms);
        text = text.slice(sms.length);
        index += sms.length + 1;
      }

      return messages;
    }
  }, {
    key: "getSMS",
    value: function getSMS(text, maxSize) {
      var index = 0,
          currentSize = 0;
      var maxSizeWithMeta = maxSize - GSM_METADATA_SIZE;

      while (currentSize + this.getCharSize(text[index]) <= maxSizeWithMeta && index < text.length) {
        currentSize += this.getCharSize(text[index]);
        index += 1;
      }

      if (this.getTextSize(text.slice(index)) + currentSize <= maxSize && text.length - index <= GSM_METADATA_LENGTH) {
        index = text.length;
      }

      return text.slice(0, index);
    }
  }, {
    key: "getTextSize",
    value: function getTextSize(text) {
      return _toConsumableArray(text).map(this.getCharSize, this).reduce(function (sum, c) {
        return sum + c;
      }, 0);
    }
  }, {
    key: "getSizeInBytes",
    value: function getSizeInBytes() {
      return Math.ceil(this.getTextSize(this.text) / BYTE_SIZE);
    }
  }, {
    key: "getCharSize",
    value: function getCharSize(character) {
      if (!character) {
        return 0;
      }

      if (this.isUnicodeRequired()) {
        return character.length * BYTE_SIZE * 2;
      } else if (GSM_EXTENDED_CHARS.includes(character)) {
        return CHARACTER_SIZE * 2;
      } else {
        return CHARACTER_SIZE;
      }
    }
  }]);

  return CharacterCounter;
}();

/* harmony default export */ __webpack_exports__["default"] = (CharacterCounter);

/***/ }),

/***/ "./app/javascript/components/feedback/Feedback.vue":
/*!*********************************************************!*\
  !*** ./app/javascript/components/feedback/Feedback.vue ***!
  \*********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _Feedback_vue_vue_type_template_id_5e5b128c_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Feedback.vue?vue&type=template&id=5e5b128c&scoped=true& */ "./app/javascript/components/feedback/Feedback.vue?vue&type=template&id=5e5b128c&scoped=true&");
/* harmony import */ var _Feedback_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Feedback.vue?vue&type=script&lang=js& */ "./app/javascript/components/feedback/Feedback.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _Feedback_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _Feedback_vue_vue_type_template_id_5e5b128c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"],
  _Feedback_vue_vue_type_template_id_5e5b128c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  "5e5b128c",
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "app/javascript/components/feedback/Feedback.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./app/javascript/components/feedback/Feedback.vue?vue&type=script&lang=js&":
/*!**********************************************************************************!*\
  !*** ./app/javascript/components/feedback/Feedback.vue?vue&type=script&lang=js& ***!
  \**********************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Feedback_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--8-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./Feedback.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/feedback/Feedback.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Feedback_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./app/javascript/components/feedback/Feedback.vue?vue&type=template&id=5e5b128c&scoped=true&":
/*!****************************************************************************************************!*\
  !*** ./app/javascript/components/feedback/Feedback.vue?vue&type=template&id=5e5b128c&scoped=true& ***!
  \****************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Feedback_vue_vue_type_template_id_5e5b128c_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./Feedback.vue?vue&type=template&id=5e5b128c&scoped=true& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/feedback/Feedback.vue?vue&type=template&id=5e5b128c&scoped=true&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Feedback_vue_vue_type_template_id_5e5b128c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Feedback_vue_vue_type_template_id_5e5b128c_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ }),

/***/ "./app/javascript/components/jwt_generator/JwtGenerator.vue":
/*!******************************************************************!*\
  !*** ./app/javascript/components/jwt_generator/JwtGenerator.vue ***!
  \******************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _JwtGenerator_vue_vue_type_template_id_6831c45a___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./JwtGenerator.vue?vue&type=template&id=6831c45a& */ "./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=template&id=6831c45a&");
/* harmony import */ var _JwtGenerator_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./JwtGenerator.vue?vue&type=script&lang=js& */ "./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _JwtGenerator_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _JwtGenerator_vue_vue_type_template_id_6831c45a___WEBPACK_IMPORTED_MODULE_0__["render"],
  _JwtGenerator_vue_vue_type_template_id_6831c45a___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "app/javascript/components/jwt_generator/JwtGenerator.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=script&lang=js&":
/*!*******************************************************************************************!*\
  !*** ./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=script&lang=js& ***!
  \*******************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_JwtGenerator_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--8-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./JwtGenerator.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_JwtGenerator_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=template&id=6831c45a&":
/*!*************************************************************************************************!*\
  !*** ./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=template&id=6831c45a& ***!
  \*************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_JwtGenerator_vue_vue_type_template_id_6831c45a___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./JwtGenerator.vue?vue&type=template&id=6831c45a& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=template&id=6831c45a&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_JwtGenerator_vue_vue_type_template_id_6831c45a___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_JwtGenerator_vue_vue_type_template_id_6831c45a___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ }),

/***/ "./app/javascript/components/search/NDPArticle.vue":
/*!*********************************************************!*\
  !*** ./app/javascript/components/search/NDPArticle.vue ***!
  \*********************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _NDPArticle_vue_vue_type_template_id_19ea2ea0___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./NDPArticle.vue?vue&type=template&id=19ea2ea0& */ "./app/javascript/components/search/NDPArticle.vue?vue&type=template&id=19ea2ea0&");
/* harmony import */ var _NDPArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./NDPArticle.vue?vue&type=script&lang=js& */ "./app/javascript/components/search/NDPArticle.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _NDPArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _NDPArticle_vue_vue_type_template_id_19ea2ea0___WEBPACK_IMPORTED_MODULE_0__["render"],
  _NDPArticle_vue_vue_type_template_id_19ea2ea0___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "app/javascript/components/search/NDPArticle.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./app/javascript/components/search/NDPArticle.vue?vue&type=script&lang=js&":
/*!**********************************************************************************!*\
  !*** ./app/javascript/components/search/NDPArticle.vue?vue&type=script&lang=js& ***!
  \**********************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_NDPArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--8-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./NDPArticle.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/NDPArticle.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_NDPArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./app/javascript/components/search/NDPArticle.vue?vue&type=template&id=19ea2ea0&":
/*!****************************************************************************************!*\
  !*** ./app/javascript/components/search/NDPArticle.vue?vue&type=template&id=19ea2ea0& ***!
  \****************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_NDPArticle_vue_vue_type_template_id_19ea2ea0___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./NDPArticle.vue?vue&type=template&id=19ea2ea0& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/NDPArticle.vue?vue&type=template&id=19ea2ea0&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_NDPArticle_vue_vue_type_template_id_19ea2ea0___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_NDPArticle_vue_vue_type_template_id_19ea2ea0___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ }),

/***/ "./app/javascript/components/search/Search.vue":
/*!*****************************************************!*\
  !*** ./app/javascript/components/search/Search.vue ***!
  \*****************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _Search_vue_vue_type_template_id_f2a57ba8_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./Search.vue?vue&type=template&id=f2a57ba8&scoped=true& */ "./app/javascript/components/search/Search.vue?vue&type=template&id=f2a57ba8&scoped=true&");
/* harmony import */ var _Search_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./Search.vue?vue&type=script&lang=js& */ "./app/javascript/components/search/Search.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _Search_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _Search_vue_vue_type_template_id_f2a57ba8_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"],
  _Search_vue_vue_type_template_id_f2a57ba8_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  "f2a57ba8",
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "app/javascript/components/search/Search.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./app/javascript/components/search/Search.vue?vue&type=script&lang=js&":
/*!******************************************************************************!*\
  !*** ./app/javascript/components/search/Search.vue?vue&type=script&lang=js& ***!
  \******************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Search_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--8-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./Search.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/Search.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_Search_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./app/javascript/components/search/Search.vue?vue&type=template&id=f2a57ba8&scoped=true&":
/*!************************************************************************************************!*\
  !*** ./app/javascript/components/search/Search.vue?vue&type=template&id=f2a57ba8&scoped=true& ***!
  \************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Search_vue_vue_type_template_id_f2a57ba8_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./Search.vue?vue&type=template&id=f2a57ba8&scoped=true& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/Search.vue?vue&type=template&id=f2a57ba8&scoped=true&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Search_vue_vue_type_template_id_f2a57ba8_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_Search_vue_vue_type_template_id_f2a57ba8_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ }),

/***/ "./app/javascript/components/search/ZendeskArticle.vue":
/*!*************************************************************!*\
  !*** ./app/javascript/components/search/ZendeskArticle.vue ***!
  \*************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _ZendeskArticle_vue_vue_type_template_id_3b48151e___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./ZendeskArticle.vue?vue&type=template&id=3b48151e& */ "./app/javascript/components/search/ZendeskArticle.vue?vue&type=template&id=3b48151e&");
/* harmony import */ var _ZendeskArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./ZendeskArticle.vue?vue&type=script&lang=js& */ "./app/javascript/components/search/ZendeskArticle.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport *//* harmony import */ var _node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../../../../node_modules/vue-loader/lib/runtime/componentNormalizer.js */ "./node_modules/vue-loader/lib/runtime/componentNormalizer.js");





/* normalize component */

var component = Object(_node_modules_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_2__["default"])(
  _ZendeskArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _ZendeskArticle_vue_vue_type_template_id_3b48151e___WEBPACK_IMPORTED_MODULE_0__["render"],
  _ZendeskArticle_vue_vue_type_template_id_3b48151e___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  null,
  null
  
)

/* hot reload */
if (false) { var api; }
component.options.__file = "app/javascript/components/search/ZendeskArticle.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ "./app/javascript/components/search/ZendeskArticle.vue?vue&type=script&lang=js&":
/*!**************************************************************************************!*\
  !*** ./app/javascript/components/search/ZendeskArticle.vue?vue&type=script&lang=js& ***!
  \**************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_ZendeskArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/babel-loader/lib??ref--8-0!../../../../node_modules/vue-loader/lib??vue-loader-options!./ZendeskArticle.vue?vue&type=script&lang=js& */ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/ZendeskArticle.vue?vue&type=script&lang=js&");
/* empty/unused harmony star reexport */ /* harmony default export */ __webpack_exports__["default"] = (_node_modules_babel_loader_lib_index_js_ref_8_0_node_modules_vue_loader_lib_index_js_vue_loader_options_ZendeskArticle_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__["default"]); 

/***/ }),

/***/ "./app/javascript/components/search/ZendeskArticle.vue?vue&type=template&id=3b48151e&":
/*!********************************************************************************************!*\
  !*** ./app/javascript/components/search/ZendeskArticle.vue?vue&type=template&id=3b48151e& ***!
  \********************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_ZendeskArticle_vue_vue_type_template_id_3b48151e___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../node_modules/vue-loader/lib??vue-loader-options!./ZendeskArticle.vue?vue&type=template&id=3b48151e& */ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/ZendeskArticle.vue?vue&type=template&id=3b48151e&");
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_ZendeskArticle_vue_vue_type_template_id_3b48151e___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _node_modules_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_node_modules_vue_loader_lib_index_js_vue_loader_options_ZendeskArticle_vue_vue_type_template_id_3b48151e___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });



/***/ }),

/***/ "./app/javascript/format/index.js":
/*!****************************************!*\
  !*** ./app/javascript/format/index.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return Format; });
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var Format =
/*#__PURE__*/
function () {
  function Format() {
    var _this = this;

    _classCallCheck(this, Format);

    this.formatSelector = $('.js-format-selector')[0];

    if (this.formatSelector) {
      this.formatChanged(this.formatSelector.value, false);
      $(this.formatSelector).change(function (event) {
        return _this.formatChanged(event.target.value);
      });
      this.restoreFormat();
    }
  }

  _createClass(Format, [{
    key: "formatChanged",
    value: function formatChanged(format) {
      var persist = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
      $('.js-format').hide();
      $(".js-format[data-format='".concat(format, "']")).show();

      if (persist) {
        this.persistFormat(format);
      }
    }
  }, {
    key: "persistFormat",
    value: function persistFormat(format) {
      if (window.localStorage) {
        window.localStorage.setItem('format', format);
      }
    }
  }, {
    key: "restoreFormat",
    value: function restoreFormat() {
      if (window.localStorage) {
        var format = window.localStorage.getItem('format');

        if (format) {
          $(this.formatSelector).val(format);
          this.formatChanged(format, false);
        }
      }
    }
  }]);

  return Format;
}();



/***/ }),

/***/ "./app/javascript/github_cards/index.js":
/*!**********************************************!*\
  !*** ./app/javascript/github_cards/index.js ***!
  \**********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var whatwg_fetch__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! whatwg-fetch */ "./node_modules/whatwg-fetch/fetch.js");
/* harmony import */ var whatwg_fetch__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(whatwg_fetch__WEBPACK_IMPORTED_MODULE_0__);

/* harmony default export */ __webpack_exports__["default"] = (function () {
  $('[data-github]').each(function (index, element) {
    var repo = $(element).data('github');
    fetch('https://api.github.com/repos/' + repo).then(function (response) {
      return response.json();
    }).then(function (response) {
      $(element).find('[data-forks]').text(response.forks);
      $(element).find('[data-stars]').text(response.stargazers_count);
    });
  });
});

/***/ }),

/***/ "./app/javascript/navigation/index.js":
/*!********************************************!*\
  !*** ./app/javascript/navigation/index.js ***!
  \********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
window.navigationAnimationInProgress = false;
var animationSpeed = 0.2;
var Volta;

Volta = function () {
  return {
    _closest: closest,
    _hasClass: hasClass,
    _isMobile: isMobileDevice,
    _getElementSiblings: getElementSiblings,
    _getFunction: getFunctionFromString
    /**
     *  @private
     *
     *  @description Finds the first ancestor of the given element, matching a specific selector.
     *  @param {HTMLElement} element Starting element
     *  @param {string} selector Selector to find (can be .class, #id, div...)
     *  @param {string} stopSelector Selector to stop searching on (can be .class, #id, div...)
     *  @returns {HTMLElement|null} The matched element or null if no element is found
     */

  };

  function closest(element, selector, stopSelector) {
    var match = null;

    while (element) {
      if (element.matches(selector)) {
        match = element;
        break;
      } else if (stopSelector && element.matches(stopSelector)) {
        break;
      }

      element = element.parentElement;
    }

    return match;
  }
  /**
   *  @private
   *  @description Given the name of a function returns the function itself
   *  @param {string} callbackFnName The function name e.g. "testFunction" OR "test.function"
   *  @returns {Function}
   */


  function getFunctionFromString(fnName) {
    var fn;

    if (fnName) {
      var fnNames = fnName.split(".");
      var fn = window;

      for (var i = 0; i < fnNames.length; i++) {
        fn = fn[fnNames[i]];
      }
    }

    return fn;
  }
  /**
   *  @private
   *  @description Get all siblings of an element
   *  @param {HTMLElement} el
   */


  function getElementSiblings(element) {
    var siblings = [];
    element = element.parentNode.firstChild;

    do {
      if (element.nodeType === 1) {
        siblings.push(element);
      }
    } while (element = element.nextSibling);

    return siblings;
  }
  /**
   *  @privates
   *
   *  @description Check if the given element has a particular class
   *  @param {HTMLElement} el Element to evaluate
   *  @param {string} className Class name to check for
   *  @returns {boolean} True if the element has the class or false if not
   */


  function hasClass(element, className) {
    if (!element) {
      return false;
    }

    return (" " + element.className + " ").replace(/[\n\t]/g, " ").indexOf(" " + className + " ") > -1;
  }
  /**
   *  @private
   *
   *  @description Is the current device a mobile
   *  @returns {boolean} True if mobile false if not
   */


  function isMobileDevice() {
    var isMobile = /Android|webOS|iPhone|iPad|BlackBerry|Windows Phone|Opera Mini|IEMobile|Mobile/i;
    return isMobile.test(navigator.userAgent);
  }
  /**
   *  @private
   *
   */


  function polyfilsForIE11() {
    if (window.NodeList && !NodeList.prototype.forEach) {
      NodeList.prototype.forEach = function (callback, thisArg) {
        thisArg = thisArg || window;

        for (var i = 0; i < this.length; i++) {
          callback.call(thisArg, this[i], i, this);
        }
      };
    }

    if (!Element.prototype.matches) {
      Element.prototype.matches = Element.prototype.matchesSelector || Element.prototype.mozMatchesSelector || Element.prototype.msMatchesSelector || Element.prototype.oMatchesSelector || Element.prototype.webkitMatchesSelector || function (s) {
        var matches = (this.document || this.ownerDocument).querySelectorAll(s),
            i = matches.length;

        while (--i >= 0 && matches.item(i) !== this) {}

        return i > -1;
      };
    }
  }
}();

Volta.menu = function () {
  var _class = {
    footer: 'Vlt-sidetabs',
    footerLink: 'Vlt-sidetabs__link',
    footerTrigger: 'Vlt-sidetabs__trigger',
    mobile: 'Vlt-sidenav__mobile',
    mobileOpen: 'Vlt-body--mobile-menu-open',
    mobileTrigger: 'Vlt-sidenav__mobile-trigger',
    link: 'Vlt-sidemenu__link',
    linkActive: 'Vlt-sidemenu__link_active',
    sideMenu: 'Vlt-sidemenu',
    trigger: 'Vlt-sidemenu__trigger',
    triggerActive: 'Vlt-sidemenu__trigger_active',
    triggerCurrent: 'Vlt-sidemenu__trigger_current',
    triggerEnabled: '.Vlt-tabs__link:not(.Vlt-tabs__link_disabled)',
    visible: 'Vlt-sidenav_visible'
  };
  var _id = {
    menu: '#Vlt-sidenav',
    mobileTrigger: '#Vlt-sidenav-mobile-trigger'
  };
  var menu;
  var expandedMenus = [],
      mobileMenuTriggeredTwice;
  return {
    _class: _class,
    _element: undefined,
    closeAll: removeAllMenuItemsFromSelectedArr,
    init: initialise,
    expand: expandActiveMenu,
    _triggerHandler: attachTriggerHandlers
    /**
     *  @private
     *
     *  @description Adds the parents of the active menu to the exoanded menus array
     *  @param {HTMLElement} element The active menu
     */

  };

  function addExpandedParentMenuToArr(element) {
    var nestedMenuUl = Volta._closest(element, 'ul', '.' + _class.sideMenu);

    var nestedMenuTrigger = nestedMenuUl.previousElementSibling;

    if (nestedMenuTrigger) {
      if (!Volta._hasClass(nestedMenuTrigger, _class.triggerActive)) {
        nestedMenuTrigger.classList.add(_class.triggerActive);
      }

      expandedMenus.push(nestedMenuTrigger);
      addExpandedParentMenuToArr(nestedMenuTrigger);
    }
  }
  /**
   *  @private
   *
   *  @description Attach the listener for the mobile menu trigger
   */


  function attachMobileTriggerHandler() {
    var mobileMenuTrigger = document.querySelector(_id.mobileTrigger);

    if (mobileMenuTrigger) {
      mobileMenuTrigger.addEventListener('click', function (e) {
        if (mobileMenuTriggeredTwice) {
          mobileMenuTriggeredTwice = false;
          e.stopPropagation();
          return;
        }

        if (!Volta._hasClass(menu, _class.visible)) {
          menu.classList.add(_class.visible);
          document.body.classList.add(_class.mobileOpen); //stop propagation otherwise will immediately call handler

          e.stopPropagation();
          addMobileMenuCollapseListeners();
        }
      });
    }
  }
  /**
   *  @private
   *
   *  @description Attach the listeners for closing the expanded mobile menu
   */


  function addMobileMenuCollapseListeners() {
    document.querySelector('body').addEventListener('click', closeMenu, {
      once: true
    });
    document.querySelector('body').addEventListener('touchstart', closeMenu, {
      once: true
    });
  }
  /**
   *  @public
   *
   *  @description Attach the listeners to the trigger elements of the menu
   */


  function attachTriggerHandlers() {
    attachMobileTriggerHandler();
    menu.querySelectorAll('.' + _class.trigger).forEach(attachHandler);

    function attachHandler(triggerElem) {
      triggerElem.addEventListener('click', expandMenu);
    }
  }
  /**
   *  @private
   *
   *  @description Checks if the passed in menu is nested
   *  @param {HTMLElement} menuItem
   *  @return {boolean} If the menu item is nested returns true, otherwise false
   */


  function checkMenuItemIsNested(menuItem) {
    return isNestedDescendant(menuItem);
  }
  /**
   *  @private
   *
   *  @description Recursive function to check if the passed in menu is nested
   *  @param {HTMLElement} menuItem
   *  @param {Boolean} isAncestor
   *  @return {boolean} If the menu item is nested returns true, otherwise false
   */


  function isNestedDescendant(menuItem, isAncestor) {
    var isNested = false;
    var ancestor = isAncestor ? menuItem.parentElement : menuItem.parentElement.parentElement;
    var ancestorSibling = ancestor.previousElementSibling;

    if (ancestorSibling) {
      isNested = Volta._hasClass(ancestorSibling, _class.trigger);
    }

    if (ancestorSibling && !isNested) {
      return isNestedDescendant(ancestor, true);
    }

    return isNested;
  }
  /**
   *  @private
   *
   *  @description Attach the listeners to the trigger elements of the menu
   *  @param {HTMLElement} menuItem
   *  @return {boolean} If the menu item is nested returns true, otherwise false
   */


  function closeMenu(e) {
    var isSideMenuChild = Volta._closest(e.target, '.' + _class.sideMenu);

    if (!Volta._hasClass(e.target, _class.sideMenu) && !isSideMenuChild) {
      menu.classList.remove(_class.visible);
      document.body.classList.remove(_class.mobileOpen);

      var isMobileMenu = Volta._closest(e.target, '.' + _class.mobile);

      if (Volta._hasClass(e.target, _class.mobileTrigger) || isMobileMenu) {
        mobileMenuTriggeredTwice = true;
      }
    } else {
      addMobileMenuCollapseListeners();
    }
  }
  /**
   *  @private
   *
   *  @description Expand the nested menu
   *  @param {event} e
   */


  function expandMenu(e) {
    e.preventDefault();
    e.stopPropagation();

    var _this = this;

    var isNestedMenu = checkMenuItemIsNested(_this);

    if (expandedMenus.indexOf(_this) >= 0 && isNestedMenu) {
      removeMenuFromSelectedArr(_this);
    } else if (expandedMenus.indexOf(_this) >= 0) {
      removeAllMenuItemsFromSelectedArr();
    } else {
      if (!isNestedMenu) {
        removeAllMenuItemsFromSelectedArr();
      } else {
        removeSiblingFromSelectedArr(_this);
      }

      expandedMenus.push(_this);

      _this.classList.add(_class.triggerActive);
    }

    if (Volta.menuCollapse) {
      Volta.menuCollapse.attachCloseHandler(expandedMenus);
    }
  }
  /**
   *  @public
   *
   *  @description Expand the active menu - typically used on page load
   *  @param {boolean} isUserForced Whether the action has been trigger by the user
   */


  function expandActiveMenu(isUserForced) {
    var activeMenuItem = menu.querySelector('.' + _class.linkActive);

    if (activeMenuItem) {
      var activeTriggerUl = Volta._closest(activeMenuItem, 'ul', '.' + _class.sideMenu);

      var activeTrigger = activeTriggerUl.previousElementSibling;

      if (activeTrigger) {
        if (!Volta._hasClass(activeTrigger, _class.triggerActive)) {
          activeTrigger.classList.add(_class.triggerActive, _class.triggerCurrent);
        }

        var isNestedMenu = checkMenuItemIsNested(activeTrigger);

        if (isNestedMenu) {
          addExpandedParentMenuToArr(activeTrigger);
        }

        expandedMenus.push(activeTrigger);
      }
    }
  }
  /**
   *  @public
   *
   *  @description Initialise the menu
   *  @param {boolean} menuCollapse Whether the collapse module has been included
   */


  function initialise(menuCollapse) {
    expandedMenus = [];
    menu = document.querySelector(_id.menu);
    Volta.menu._element = menu;

    if (menu) {
      if (!Volta.menuCollapse) {
        expandActiveMenu();
      } else if (menuCollapse) {
        Volta.menuCollapse.init();
      }

      attachTriggerHandlers();
    }
  }
  /**
   *  @public
   *
   *  @description Clear the selected menus array, and close all of the nested menus
   */


  function removeAllMenuItemsFromSelectedArr() {
    expandedMenus.forEach(function (menuItem) {
      menuItem.classList.remove(_class.triggerActive);
    });
    expandedMenus = [];
  }
  /**
   *  @private
   *
   *  @description Remove a specific menu item from the selected array and close
   */


  function removeMenuFromSelectedArr(menuItem) {
    var menuIndex = expandedMenus.indexOf(menuItem);
    menuItem.classList.remove(_class.triggerActive);
    expandedMenus.splice(menuIndex, 1);
  }
  /**
   *  @private
   *
   *  @description Remove sibling menu item from the selected array and close
   */


  function removeSiblingFromSelectedArr(menuItem) {
    var ancestors = menuItem.parentElement.parentElement.children;
    var openSibling;
    var count = ancestors.length - 1;

    while (openSibling === undefined && count >= 0) {
      var siblingIndex = expandedMenus.indexOf(ancestors[count].children[0]);

      if (siblingIndex >= 0) {
        openSibling = expandedMenus[siblingIndex];
      }

      count--;
    }

    if (openSibling) {
      removeMenuFromSelectedArr(openSibling);
    }
  }
}();

function toggleMobileNavBtn() {
  if ($('#Vlt-sidenav').length === 0) {
    $('#Vlt-sidenav-mobile-trigger').hide();
  }
}

function setActiveNavItem() {
  var activeItem = $('nav.sidenav').data('active');
  $(".Vlt-sidemenu__link[href=\"".concat(activeItem, "\"]")).addClass('Vlt-sidemenu__link_active');
}

/* harmony default export */ __webpack_exports__["default"] = (function () {
  setActiveNavItem();
  Volta.menu.init();
  toggleMobileNavBtn();
});

/***/ }),

/***/ "./app/javascript/notices/index.js":
/*!*****************************************!*\
  !*** ./app/javascript/notices/index.js ***!
  \*****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony default export */ __webpack_exports__["default"] = (function () {
  var noticeCloseComplete = function noticeCloseComplete(notice) {
    notice.remove();
    removeNoticesIfEmpty();
  };

  var noticeKey = function noticeKey(notice) {
    var id = notice.data('notice-id');
    return "notice-dismissed(id:".concat(id, ")");
  };

  var isDismissible = function isDismissible(notice) {
    return notice.data('notice-dismissible');
  };

  var bootstrap = function bootstrap() {
    $(document).on('click', '.notice a[data-close]', function (event) {
      var notice = $(this).parents('.notice');
      localStorage.setItem(noticeKey(notice), true);
      TweenLite.to(notice, 0.6, {
        scale: 0,
        height: 0,
        transformOrigin: "center top",
        ease: Power2.easeIn,
        onComplete: function onComplete() {
          return noticeCloseComplete(notice);
        }
      });
    });
  };

  var removeNoticesIfEmpty = function removeNoticesIfEmpty() {
    if ($('.notices .notice').length === 0) {
      $('.notices').remove();
    }
  };

  var clearRead = function clearRead() {
    $('.notices .notice').each(function () {
      var notice = $(this);

      if (isDismissible(notice)) {
        return;
      }

      if (localStorage.getItem(noticeKey(notice))) {
        $(this).remove();
      }
    });
    removeNoticesIfEmpty();
  };

  $(document).ready(function () {
    bootstrap();
    clearRead();
  });
});

/***/ }),

/***/ "./app/javascript/packs/application.js":
/*!*********************************************!*\
  !*** ./app/javascript/packs/application.js ***!
  \*********************************************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _babel_polyfill__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @babel/polyfill */ "./node_modules/@babel/polyfill/lib/index.js");
/* harmony import */ var _babel_polyfill__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_babel_polyfill__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var vue_dist_vue_esm__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! vue/dist/vue.esm */ "./node_modules/vue/dist/vue.esm.js");
/* harmony import */ var gsap__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! gsap */ "./node_modules/gsap/esm/index.js");
/* harmony import */ var _github_cards__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../github_cards */ "./app/javascript/github_cards/index.js");
/* harmony import */ var _volta_tabbed_examples__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../volta_tabbed_examples */ "./app/javascript/volta_tabbed_examples/index.js");
/* harmony import */ var _format__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../format */ "./app/javascript/format/index.js");
/* harmony import */ var _scroll__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ../scroll */ "./app/javascript/scroll/index.js");
/* harmony import */ var _spotlight__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ../spotlight */ "./app/javascript/spotlight/index.js");
/* harmony import */ var _notices__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ../notices */ "./app/javascript/notices/index.js");
/* harmony import */ var _components_feedback_Feedback_vue__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ../components/feedback/Feedback.vue */ "./app/javascript/components/feedback/Feedback.vue");
/* harmony import */ var _components_jwt_generator_JwtGenerator_vue__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ../components/jwt_generator/JwtGenerator.vue */ "./app/javascript/components/jwt_generator/JwtGenerator.vue");
/* harmony import */ var _components_search_Search_vue__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ../components/search/Search.vue */ "./app/javascript/components/search/Search.vue");
/* harmony import */ var _components_concatenation_Concatenation_vue__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! ../components/concatenation/Concatenation.vue */ "./app/javascript/components/concatenation/Concatenation.vue");
/* harmony import */ var _api_status__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! ../api_status */ "./app/javascript/api_status/index.js");
/* harmony import */ var _code_snippet_events__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! ../code_snippet_events */ "./app/javascript/code_snippet_events/index.js");
/* harmony import */ var _navigation__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! ../navigation */ "./app/javascript/navigation/index.js");
/* harmony import */ var _careers__WEBPACK_IMPORTED_MODULE_16__ = __webpack_require__(/*! ../careers */ "./app/javascript/careers/index.js");
/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

















$(document).ready(function () {
  Object(_scroll__WEBPACK_IMPORTED_MODULE_6__["default"])();
  Object(_notices__WEBPACK_IMPORTED_MODULE_8__["default"])();
  Object(_github_cards__WEBPACK_IMPORTED_MODULE_3__["default"])();
  new _volta_tabbed_examples__WEBPACK_IMPORTED_MODULE_4__["default"]();
  new _format__WEBPACK_IMPORTED_MODULE_5__["default"]();
  Object(_api_status__WEBPACK_IMPORTED_MODULE_13__["default"])();
  Object(_scroll__WEBPACK_IMPORTED_MODULE_6__["default"])();
  Object(_code_snippet_events__WEBPACK_IMPORTED_MODULE_14__["default"])();
  Object(_navigation__WEBPACK_IMPORTED_MODULE_15__["default"])();
  Object(_spotlight__WEBPACK_IMPORTED_MODULE_7__["default"])();
  new _careers__WEBPACK_IMPORTED_MODULE_16__["default"]();

  if (document.getElementById('jwt-generator-app')) {
    new vue_dist_vue_esm__WEBPACK_IMPORTED_MODULE_1__["default"]({
      el: '#jwt-generator-app',
      template: '<JwtGenerator/>',
      components: {
        JwtGenerator: _components_jwt_generator_JwtGenerator_vue__WEBPACK_IMPORTED_MODULE_10__["default"]
      }
    });
  }

  if (document.getElementById('search-app')) {
    new vue_dist_vue_esm__WEBPACK_IMPORTED_MODULE_1__["default"]({
      el: '#search-app',
      template: '<Search/>',
      components: {
        Search: _components_search_Search_vue__WEBPACK_IMPORTED_MODULE_11__["default"]
      }
    });
  }

  if (document.getElementById('feedback-app')) {
    new vue_dist_vue_esm__WEBPACK_IMPORTED_MODULE_1__["default"]({
      el: '#feedback-app',
      template: '<Feedback/>',
      render: function render(createElement) {
        var context = {
          props: {
            codeLanguage: window.feedbackProps.code_language || window.initialLanguage,
            codeLanguageSelectedWhilstOnPage: window.feedbackProps.code_language_selected_whilst_on_page || false,
            codeLanguageSetByUrl: window.feedbackProps.code_language_set_by_url,
            currentUser: window.feedbackProps.current_user,
            feedbackAuthor: window.feedbackProps.feedback_author,
            githubUrl: window.feedbackProps.github_url,
            recaptcha: window.feedbackProps.recaptcha,
            source: window.feedbackProps.source
          }
        };
        return createElement(_components_feedback_Feedback_vue__WEBPACK_IMPORTED_MODULE_9__["default"], context);
      }
    });
  }

  if (document.getElementById('concatenation-app')) {
    new vue_dist_vue_esm__WEBPACK_IMPORTED_MODULE_1__["default"]({
      el: '#concatenation-app',
      template: '<Concatenation/>',
      components: {
        Concatenation: _components_concatenation_Concatenation_vue__WEBPACK_IMPORTED_MODULE_12__["default"]
      }
    });
  } // If we're on a two pane page, make sure that the main pane is focused


  var rightPane = document.querySelector(".Vlt-main");

  if (rightPane) {
    rightPane.click();
  }

  Volta.init(['accordion', 'tooltip', 'tab', 'modal', 'dropdown']);
  setTimeout(function () {
    var sidebarActive = document.querySelector('.Vlt-sidemenu__link_active');

    if (sidebarActive) {
      sidebarActive.scrollIntoView(true);
    }
  }, 100); // If there are any links in the sidebar, we need to be able to click them
  // and not trigger the Volta accordion

  $(".Vlt-sidemenu__trigger a").click(function () {
    window.location = $(this).attr("href");
    return false;
  }); // Track A/B testing clicks

  $("[data-ab]").click(function (e) {
    var r = new Request('/usage/ab_result', {
      method: 'POST',
      credentials: 'same-origin',
      body: JSON.stringify({
        't': $(this).data('ab')
      }),
      headers: {
        'Content-Type': 'application/json'
      }
    });
    fetch(r).then(function (response) {
      if (response.ok) {
        return response.json();
      }

      return Promise.reject({
        message: 'Bad response from server',
        response: response
      });
    });
  }); // Mermaid diagrams

  mermaid.initialize({
    startOnLoad: true,
    sequence: {
      useMaxWidth: false
    },
    themeCSS: '.actor { fill: #BDD5EA; stroke: #81B1DB; }',
    htmlLabels: true
  });
});

/***/ }),

/***/ "./app/javascript/scroll/index.js":
/*!****************************************!*\
  !*** ./app/javascript/scroll/index.js ***!
  \****************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony default export */ __webpack_exports__["default"] = (function () {
  $(document).ready(function () {
    var $body = $('.Vlt-main');
    var nav = $('.Nxd-header');
    var codeNav = $('.Nxd-api__code__header');
    $body.on('scroll', function () {
      var scrollTop = $body.scrollTop(); //navigation

      if (scrollTop > 50) {
        nav.addClass('Nxd-scroll-minify');
      } else {
        nav.removeClass('Nxd-scroll-minify');
      } //api code


      if (scrollTop > 70 && codeNav.length > 0) {
        codeNav.addClass('Nxd-api__code__header--sticky');
      } else if (codeNav.length > 0) {
        codeNav.removeClass('Nxd-api__code__header--sticky');
      }
    });
  });
});

/***/ }),

/***/ "./app/javascript/spotlight/index.js":
/*!*******************************************!*\
  !*** ./app/javascript/spotlight/index.js ***!
  \*******************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony default export */ __webpack_exports__["default"] = (function () {
  $(document).ready(function () {
    Volta.flash.init();
    $(document).on('ajax:success', '#spotlight-form', function (event, response) {
      Volta.flash.show('success');
      event.target.reset();
    }).on('ajax:error', '#spotlight-form', function (event) {
      Volta.flash.show('error');
    });
  });
});

/***/ }),

/***/ "./app/javascript/volta_tabbed_examples/index.js":
/*!*******************************************************!*\
  !*** ./app/javascript/volta_tabbed_examples/index.js ***!
  \*******************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return VoltaTabbedExamples; });
/* harmony import */ var _user_preference__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./user_preference */ "./app/javascript/volta_tabbed_examples/user_preference.js");
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }



var VoltaTabbedExamples =
/*#__PURE__*/
function () {
  function VoltaTabbedExamples() {
    _classCallCheck(this, VoltaTabbedExamples);

    this.userPreference = new _user_preference__WEBPACK_IMPORTED_MODULE_0__["default"](true);

    if ($('.Vlt-tabs').length) {
      this.context = $('.Vlt-tabs');
      this.restoreTabs = this.restoreTabs.bind(this);
      this.setupEvents = this.setupEvents.bind(this);
      this.onTabClick = this.onTabClick.bind(this);
      this.onPopState = this.onPopState.bind(this);
      this.persistLanguage = this.persistLanguage.bind(this);
      this.restoreTabs();
      this.setupEvents();
    }
  }

  _createClass(VoltaTabbedExamples, [{
    key: "shouldRestoreTabs",
    value: function shouldRestoreTabs() {
      return !this.context.find('.Vlt-tabs__header--bordered').data('has-initial-tab');
    }
  }, {
    key: "languages",
    value: function languages() {
      var obj = {};
      $(this.context).find("[data-language]").each(function (index, el) {
        $(el).data('language').split(',').forEach(function (language) {
          obj[language] = {
            platform: $(el).data('platform') || false
          };
        });
      });
      return obj;
    }
  }, {
    key: "restoreTabs",
    value: function restoreTabs() {
      if (this.shouldRestoreTabs()) {
        var languages = this.languages();
        var language = this.userPreference.topMatch(Object.keys(languages));

        if (language) {
          if (languages[language]['platform']) {
            this.setPlatform(languages[language]['platform'], this.context);
          } else {
            this.setLanguage(language);
          }
        }
      } else {
        var selectedLanguage = this.context.find('li.Vlt-tabs__link_active').data('language');
        this.setLanguage(selectedLanguage);
      }
    }
  }, {
    key: "setupEvents",
    value: function setupEvents() {
      $('.Vlt-tabs__link').click(this.onTabClick);
      $(window).on('popstate', this.onPopState);
    }
  }, {
    key: "onPopState",
    value: function onPopState(event) {
      if (window.history.state && window.history.state.language) {
        this.setLanguage(window.history.state.language);
      }
    }
  }, {
    key: "onTabClick",
    value: function onTabClick(event) {
      // Prevent nested tabs from changing the url
      if ($(event.target).parents('.Vlt-tabs').length > 1) {
        return;
      }

      var language = $(event.currentTarget).data('language');
      var languageType = $(event.currentTarget).data('language-type');
      var linkable = $(event.currentTarget).data('language-linkable');

      if (language) {
        if (linkable) {
          document.dispatchEvent(new CustomEvent('codeLanguageChange', {
            "detail": {
              "language": language
            }
          }));

          if ($(".skip-pushstate").length == 0) {
            var rootPath = $('body').data('push-state-root');
            window.history.pushState({
              language: language
            }, 'language', "".concat(rootPath, "/").concat(language));
          }
        }

        this.persistLanguage(language, languageType, linkable);
      }
    }
  }, {
    key: "persistLanguage",
    value: function persistLanguage(language, languageType) {
      if (language) {
        this.userPreference.promote(languageType, language);
      }
    }
  }, {
    key: "setLanguage",
    value: function setLanguage(language) {
      setTimeout(function () {
        $("[data-language='".concat(language, "']")).click(); // Remove skip pushstate after the first load. This is a bit of a hack, but it works to stop breaking
        // the back button

        $(".skip-pushstate").removeClass('skip-pushstate');
      }, 0);
    }
  }, {
    key: "setPlatform",
    value: function setPlatform(platform) {
      setTimeout(function () {
        $("[data-platform='".concat(platform, "']")).click();
      }, 0);
    }
  }]);

  return VoltaTabbedExamples;
}();



/***/ }),

/***/ "./app/javascript/volta_tabbed_examples/user_preference.js":
/*!*****************************************************************!*\
  !*** ./app/javascript/volta_tabbed_examples/user_preference.js ***!
  \*****************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "default", function() { return UserPreference; });
/* harmony import */ var lodash_intersection__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! lodash/intersection */ "./node_modules/lodash/intersection.js");
/* harmony import */ var lodash_intersection__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(lodash_intersection__WEBPACK_IMPORTED_MODULE_0__);
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }



var UserPreference =
/*#__PURE__*/
function () {
  function UserPreference(useSingleStore) {
    _classCallCheck(this, UserPreference);

    this.useSingleStore = useSingleStore;
    this.platformPreference = this.platforms();
    this.terminalProgramsPreference = this.terminalPrograms();
    this.frameworkPreference = this.frameworks();
  }

  _createClass(UserPreference, [{
    key: "languages",
    value: function languages() {
      return this.get(this.getKeyFromType('languages'));
    }
  }, {
    key: "platforms",
    value: function platforms() {
      return this.get(this.getKeyFromType('platforms'));
    }
  }, {
    key: "terminalPrograms",
    value: function terminalPrograms() {
      return this.get(this.getKeyFromType('terminal_programs'));
    }
  }, {
    key: "frameworks",
    value: function frameworks() {
      return this.get(this.getKeyFromType('frameworks'));
    }
  }, {
    key: "all",
    value: function all() {
      return this.platforms().concat(this.terminalPrograms(), this.languages(), this.frameworks());
    }
  }, {
    key: "getKeyFromType",
    value: function getKeyFromType(type) {
      if (this.useSingleStore) {
        return 'preferences.all';
      }

      switch (type) {
        case 'languages':
          return 'preferences.languages';

        case 'platforms':
          return 'preferences.platforms';

        case 'terminal_programs':
          return 'preferences.terminal_programs';

        case 'frameworks':
          return 'preferences.frameworks';
      }
    }
  }, {
    key: "getByType",
    value: function getByType(type) {
      switch (type) {
        case 'languages':
          return this.languages();

        case 'platforms':
          return this.platforms();

        case 'terminal_programs':
          return this.terminalPrograms();

        case 'frameworks':
          return this.frameworks();
      }
    }
  }, {
    key: "get",
    value: function get(key) {
      var value = window.localStorage.getItem(key);

      if (!value) {
        return [];
      }

      return JSON.parse(value);
    }
  }, {
    key: "store",
    value: function store(type, value) {
      var key = this.getKeyFromType(type);
      localStorage.setItem(key, JSON.stringify(value));
    }
  }, {
    key: "promote",
    value: function promote(type, value) {
      var list = this.getByType(type) || [];
      list = list.filter(function (item) {
        return item !== value;
      });
      list.unshift(value);
      this.store(type, list);
    }
  }, {
    key: "topMatch",
    value: function topMatch(available) {
      var result = lodash_intersection__WEBPACK_IMPORTED_MODULE_0___default()(this.all(), available);
      return result[0] || false;
    }
  }]);

  return UserPreference;
}();



/***/ }),

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=script&lang=js&":
/*!****************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--8-0!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/concatenation/Concatenation.vue?vue&type=script&lang=js& ***!
  \****************************************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _character_counter__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./character_counter */ "./app/javascript/components/concatenation/character_counter.js");
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

/* harmony default export */ __webpack_exports__["default"] = ({
  data: function data() {
    return {
      body: 'It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.'
    };
  },
  computed: {
    smsInfo: function smsInfo() {
      return new _character_counter__WEBPACK_IMPORTED_MODULE_0__["default"](this.body).getInfo();
    },
    messages: function messages() {
      return this.smsInfo.messages;
    },
    unicodeRequired: function unicodeRequired() {
      return this.smsInfo.unicodeRequired;
    },
    smsComposition: function smsComposition() {
      var count = this.smsInfo.charactersCount;
      var characters = this.pluralize('character', count);
      var messagesLength = this.messages.length;
      var parts = this.pluralize('part', messagesLength);
      return "".concat(count, " ").concat(characters, " sent in ").concat(messagesLength, " message ").concat(parts);
    }
  },
  methods: {
    pluralize: function pluralize(singular, count) {
      if (count === 1) {
        return singular;
      }

      return "".concat(singular, "s");
    }
  }
});

/***/ }),

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/feedback/Feedback.vue?vue&type=script&lang=js&":
/*!******************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--8-0!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/feedback/Feedback.vue?vue&type=script&lang=js& ***!
  \******************************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/* harmony default export */ __webpack_exports__["default"] = ({
  props: ['codeLanguage', 'codeLanguageSelectedWhilstOnPage', 'codeLanguageSetByUrl', 'currentUser', 'feedbackAuthor', 'githubUrl', 'recaptcha', 'source'],
  data: function data() {
    return {
      comment: '',
      error: false,
      feedbackComplete: undefined,
      id: undefined,
      recaptchaToken: undefined,
      sentiment: undefined,
      showExtendedFields: false,
      submittingFeedback: undefined,
      uploadingSentiment: false,
      programmingLanguage: this.codeLanguage,
      progammingLanguageSelectedWhilstOnPage: undefined,
      progammingLanguageSetByUrl: undefined
    };
  },
  mounted: function mounted() {
    document.addEventListener('codeLanguageChange', this.handleCodeLanguageChange.bind(this));
  },
  beforeDestroy: function beforeDestroy() {
    document.removeEventListener('codeLanguageChange', this.handleCodeLanguageChange.bind(this));
  },
  computed: {
    email: function email() {
      return this.feedbackAuthor && this.feedbackAuthor.email || this.currentUser && this.currentUser.email;
    },
    isSubmitDisabled: function isSubmitDisabled() {
      return this.submittingFeedback || this.comment === '';
    }
  },
  methods: {
    setSentiment: function setSentiment(sentiment) {
      this.sentiment = sentiment;
      this.showExtendedFields = sentiment == 'negative';
      this.uploadingSentiment = true;
      this.error = undefined;
      this.createOrUpdate();
    },
    parameters: function parameters() {
      return {
        'g-recaptcha-response': this.recaptchaToken,
        feedback_feedback: {
          id: this.id,
          sentiment: this.sentiment,
          comment: this.comment,
          email: this.email,
          code_language: this.programmingLanguage,
          code_language_selected_whilst_on_page: this.programmingLanguageSelectedWhilstOnPage,
          code_language_set_by_url: this.programmingLanguageSetByUrl,
          source: this.source
        }
      };
    },
    invisibleCaptchaCallback: function invisibleCaptchaCallback(recaptchaToken) {
      this.recaptchaToken = recaptchaToken;
      this.createOrUpdate();
    },
    createOrUpdate: function createOrUpdate() {
      var _this = this;

      if (this.recaptcha && this.recaptcha.enabled && !this.recaptcha.skip && this.recaptchaToken == undefined) {
        var element = document.createElement('div');
        document.getElementById('recaptcha-container').append(element);
        var id = grecaptcha.render(element, {
          sitekey: this.recaptcha.sitekey,
          callback: this.invisibleCaptchaCallback.bind(this),
          size: 'invisible',
          badge: 'inline'
        });
        return grecaptcha.execute(id);
      }

      fetch('/feedback/feedbacks', {
        method: 'POST',
        credentials: 'same-origin',
        body: JSON.stringify(this.parameters()),
        headers: {
          'Content-Type': 'application/json'
        }
      }).then(function (response) {
        if (response.ok) {
          return response.json();
        }

        return Promise.reject({
          message: 'Bad response from server',
          response: response
        });
      }).then(function (payload) {
        _this.feedbackComplete = _this.submittingFeedback;
        _this.uploadingSentiment = false;
        _this.submittingFeedback = false;
        _this.id = payload.id;
      })["catch"](function (error) {
        console.log(error);
        _this.uploadingSentiment = false;
        _this.submittingFeedback = false;

        if (error.response) {
          error.response.json().then(function (payload) {
            _this.error = payload.error;
          })["catch"](function () {
            _this.error = "Something went wrong! Try again later";
          });
        } else {
          _this.error = "Something went wrong! Try again later";
        }
      });
    },
    submitFeedback: function submitFeedback() {
      this.submittingFeedback = true;
      this.createOrUpdate();
    },
    handleCodeLanguageChange: function handleCodeLanguageChange(event) {
      this.programmingLanguage = event.detail.language;
      this.programmingSelectedWhilstOnPage = true;
      this.programmingSetByUrl = false;
    }
  }
});

/***/ }),

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=script&lang=js&":
/*!***************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--8-0!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=script&lang=js& ***!
  \***************************************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var jsrsasign__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! jsrsasign */ "./node_modules/jsrsasign/lib/jsrsasign.js");
/* harmony import */ var jsrsasign__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(jsrsasign__WEBPACK_IMPORTED_MODULE_0__);
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

/* harmony default export */ __webpack_exports__["default"] = ({
  data: function data() {
    return {
      sub: '',
      acl: '',
      iat: '',
      jti: '',
      nbf: '',
      applicationId: '',
      validFor: '',
      validForTimeUnit: 3600,
      privateKey: ''
    };
  },
  created: function created() {
    var tNow = jsrsasign__WEBPACK_IMPORTED_MODULE_0__["KJUR"].jws.IntDate.get('now');
    var tEnd = tNow + 3600 * 6;
    this.iat = tNow;
    this.nbf = tNow;
    this.jti = this.generateJti();
  },
  computed: {
    invalidAcl: function invalidAcl() {
      var invalid = false;

      if (this.acl) {
        try {
          JSON.parse(this.acl);
        } catch (e) {
          invalid = true;
        }
      }

      return invalid;
    },
    callout: function callout() {
      var message;

      if (this.privateKey) {
        if (!this.applicationId) {
          message = 'Next, provide an Application ID';
        }
      } else if (this.applicationId) {
        message = 'Next, provide a Private Key';
      } else {
        message = '<h4>Use your <code>private key</code> and <code>application_id</code> to create a JWT for your Nexmo Application</h4>The JWT is generated on the client-side so your private key <strong>never leaves your browser</strong>.';
      }

      return message;
    },
    exp: function exp() {
      var validFor = this.validFor || 6;
      return this.iat + validFor * this.validForTimeUnit;
    },
    jwt: function jwt() {
      var result = '';

      if (this.privateKey && this.applicationId) {
        try {
          result = this.generateJwt();
        } catch (e) {
          result = '';
        }
      }

      return result;
    },
    invalidPrivateKey: function invalidPrivateKey() {
      var invalid = false;

      if (this.privateKey && this.applicationId) {
        try {
          this.generateJwt();
        } catch (e) {
          invalid = true;
        }
      }

      return invalid;
    },
    computedClass: function computedClass() {
      if (this.invalidPrivateKey || this.invalidAcl) return 'Vlt-callout--critical';
      if (this.applicationId && this.privateKey) return '';
      if (this.applicationId || this.privateKey) return 'Vlt-callout--warning';
      if (!this.applicationId && !this.privateKey) return 'Vlt-callout--tip';
    }
  },
  methods: {
    generateJti: function generateJti() {
      var text = "";
      var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

      for (var i = 0; i < 12; i++) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
      }

      return text;
    },
    buildHeader: function buildHeader() {
      return JSON.stringify({
        typ: 'JWT',
        alg: 'RS256'
      });
    },
    buildPayload: function buildPayload() {
      var payload = {};
      payload.iat = this.iat;
      payload.exp = this.exp;
      payload.jti = this.jti;
      payload.application_id = this.applicationId;

      if (this.sub) {
        payload.sub = this.sub;
      }

      if (this.acl) {
        payload.acl = JSON.parse(this.acl);
      }

      return JSON.stringify(payload);
    },
    generateJwt: function generateJwt() {
      var prvKey = jsrsasign__WEBPACK_IMPORTED_MODULE_0__["KEYUTIL"].getKey(this.privateKey);
      return jsrsasign__WEBPACK_IMPORTED_MODULE_0__["KJUR"].jws.JWS.sign("RS256", this.buildHeader(), this.buildPayload(), prvKey);
    }
  }
});

/***/ }),

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/NDPArticle.vue?vue&type=script&lang=js&":
/*!******************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--8-0!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/search/NDPArticle.vue?vue&type=script&lang=js& ***!
  \******************************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
/* harmony default export */ __webpack_exports__["default"] = ({
  props: ['hit'],
  computed: {
    badge: function badge() {
      return this.hit.product;
    },
    description: function description() {
      return this.hit.description ? this.hit.description.substring(0, 150) : '';
    },
    showHeading: function showHeading() {
      return this.hit.heading && this.hit.heading == this.hit.title;
    },
    snippet: function snippet() {
      return "...".concat(this.hit._snippetResult.body.value, "...");
    },
    url: function url() {
      return "".concat(this.hit.path, "#").concat(this.hit.anchor);
    }
  }
});

/***/ }),

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/Search.vue?vue&type=script&lang=js&":
/*!**************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--8-0!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/search/Search.vue?vue&type=script&lang=js& ***!
  \**************************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var algoliasearch__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! algoliasearch */ "./node_modules/algoliasearch/src/browser/builds/algoliasearch.js");
/* harmony import */ var algoliasearch__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(algoliasearch__WEBPACK_IMPORTED_MODULE_0__);
/* harmony import */ var lodash_debounce__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! lodash/debounce */ "./node_modules/lodash/debounce.js");
/* harmony import */ var lodash_debounce__WEBPACK_IMPORTED_MODULE_1___default = /*#__PURE__*/__webpack_require__.n(lodash_debounce__WEBPACK_IMPORTED_MODULE_1__);
/* harmony import */ var _NDPArticle_vue__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./NDPArticle.vue */ "./app/javascript/components/search/NDPArticle.vue");
/* harmony import */ var _ZendeskArticle_vue__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./ZendeskArticle.vue */ "./app/javascript/components/search/ZendeskArticle.vue");
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//




/* harmony default export */ __webpack_exports__["default"] = ({
  data: function data() {
    return {
      analyticsTriggered: false,
      client: undefined,
      expanded: false,
      loading: false,
      query: '',
      results: [],
      analyticsStrongIndicationOfReadingTimer: undefined
    };
  },
  created: function created() {
    this.client = algoliasearch__WEBPACK_IMPORTED_MODULE_0___default()(document.querySelector('meta[name=algolia_application_id]').getAttribute('content'), document.querySelector('meta[name=algolia_search_key]').getAttribute('content'));
  },
  mounted: function mounted() {
    if (document.querySelector('.Nxd-template')) {
      document.querySelector('.Nxd-template').addEventListener('click', this.onClickOutside.bind(this));
    }
  },
  onDestroy: function onDestroy() {
    if (document.querySelector('.Nxd-template')) {
      document.querySelector('.Nxd-template').removeEventListener('click', this.onClickOutside.bind(this));
    }
  },
  computed: {
    showResults: function showResults() {
      return this.query != '';
    }
  },
  methods: {
    resultTitle: function resultTitle(name) {
      if (name == 'zendesk_nexmo_articles') {
        return 'Knowledgebase';
      } else if (name.includes('nexmo_developer')) {
        return 'Nexmo Developer';
      }
    },
    isZendeskArticle: function isZendeskArticle(result) {
      return result.index == 'zendesk_nexmo_articles';
    },
    isNDPArticle: function isNDPArticle(result) {
      return result.index.includes('nexmo_developer');
    },
    hitKey: function hitKey(result, hit) {
      return result.index + hit.objectID;
    },
    onClickOutside: function onClickOutside(event) {
      if (this.showResults) {
        this.reset();
      }

      if (this.expanded) {
        this.expanded = false;
      }
    },
    onEscDownHandler: function onEscDownHandler(event) {
      if (!this.analyticsTriggered && this.query !== '') {
        this.triggerAnalyticalSearch();
      }

      this.reset();
    },
    reset: function reset() {
      this.resetAnalyticsListeners();
      this.query = '';
      this.results = [];
      this.loading = false;
    },
    onInputHandler: function onInputHandler(event) {
      event.stopPropagation();

      if (this.query === '') {
        this.reset();
      } else {
        lodash_debounce__WEBPACK_IMPORTED_MODULE_1___default()(this.handleSearch.bind(this), 250)(event);
      }
    },
    handleSearch: function handleSearch(event) {
      this.loading = this.query === '';
      this.analyticsTriggered = false;
      this.performSearch();
      this.resetAnalyticsListeners();
      this.analyticsStrongIndicationOfReadingTimer = setTimeout(this.triggerAnalyticalSearch, 2000);
      window.addEventListener('mousemove', this.triggerAnalyticalSearch);
    },
    performSearch: function performSearch() {
      var _this = this;

      var analytics = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : false;
      var parameters = Array.from(document.querySelectorAll('meta[name=algolia_index]')).map(function (element) {
        return {
          indexName: element.getAttribute('content'),
          query: _this.query,
          params: {
            analytics: analytics,
            hitsPerPage: analytics ? 1 : 4
          }
        };
      });
      var searchPromise = this.client.search(parameters);

      if (!analytics) {
        searchPromise.then(function (response) {
          _this.results = response['results'];
          _this.loading = false;
        });
      }
    },
    resetAnalyticsListeners: function resetAnalyticsListeners() {
      clearTimeout(this.analyticsStrongIndicationOfReadingTimer);
      window.removeEventListener('mousemove', this.triggerAnalyticalSearch);
    },
    triggerAnalyticalSearch: function triggerAnalyticalSearch() {
      this.performSearch(true);
      this.analyticsTriggered = true;
      this.resetAnalyticsListeners();
    }
  },
  components: {
    ZendeskArticle: _ZendeskArticle_vue__WEBPACK_IMPORTED_MODULE_3__["default"],
    NDPArticle: _NDPArticle_vue__WEBPACK_IMPORTED_MODULE_2__["default"]
  }
});

/***/ }),

/***/ "./node_modules/babel-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/ZendeskArticle.vue?vue&type=script&lang=js&":
/*!**********************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib??ref--8-0!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/search/ZendeskArticle.vue?vue&type=script&lang=js& ***!
  \**********************************************************************************************************************************************************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
//
//
//
//
//
//
//
//
//
//
//
/* harmony default export */ __webpack_exports__["default"] = ({
  props: ['hit'],
  computed: {
    badge: function badge() {
      return this.hit.section.full_path;
    },
    snippet: function snippet() {
      return "...".concat(this.hit._snippetResult.body_safe.value, "...");
    },
    title: function title() {
      return this.hit.title;
    },
    url: function url() {
      return "https://help.nexmo.com/hc/en-us/articles/".concat(this.hit.id);
    }
  }
});

/***/ }),

/***/ "./node_modules/css-loader/dist/cjs.js?!./node_modules/vue-loader/lib/loaders/stylePostLoader.js!./node_modules/postcss-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css&":
/*!***********************************************************************************************************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/css-loader/dist/cjs.js??ref--3-1!./node_modules/vue-loader/lib/loaders/stylePostLoader.js!./node_modules/postcss-loader/lib??ref--3-2!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css& ***!
  \***********************************************************************************************************************************************************************************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__(/*! ../../../../node_modules/css-loader/dist/runtime/api.js */ "./node_modules/css-loader/dist/runtime/api.js")(true);
// Module
exports.push([module.i, "\ntextarea[data-v-301089c4] {\n   width: 100%;\n   height: 150px;\n   resize: vertical;\n}\ncode[data-v-301089c4] {\n   whiteSpace: normal;\n   wordBreak: break-all;\n}\n", "",{"version":3,"sources":["/Users/bgreenberg2/Documents/dev/nexmo-developer/lib/nexmo_developer/app/javascript/components/concatenation/app/javascript/components/concatenation/Concatenation.vue","Concatenation.vue"],"names":[],"mappings":";AAsFA;GACA,WAAA;GACA,aAAA;GACA,gBAAA;ACCC;ADCD;GACA,kBAAA;GACA,oBAAA;ACCA","file":"Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css&","sourcesContent":["<template>\n  <div class=\"Vlt-box\">\n    <h2>Try it out</h2>\n\n    <h4>Message</h4>\n    <div class=\"Vlt-textarea\">\n      <textarea v-model=\"body\" />\n    </div>\n\n    <div class=\"Vlt-margin--top2\" />\n\n    <h4>Data</h4>\n    <div class=\"Vlt-box Vlt-box--white Vlt-box--lesspadding\">\n      <div class=\"Vlt-grid\">\n        <div class=\"Vlt-col Vlt-col--1of3\">\n          <b>Unicode is Required?</b>\n          <i v-if=\"unicodeRequired\" class=\"icon icon--large icon-check-circle color--success\"></i>\n          <i v-else class=\"icon icon--large icon-times-circle color--error\"></i>\n        </div>\n        <div class=\"Vlt-col Vlt-col--2of3\">\n        </div>\n        <hr class=\"hr--shorter\"/>\n        <div class=\"Vlt-col Vlt-col--1of3\">\n          <b>Length</b>\n        </div>\n        <div class=\"Vlt-col Vlt-col--2of3\" v-html=\"smsComposition\" id=\"sms-composition\"></div>\n      </div>\n    </div>\n\n    <h4>Parts</h4>\n    <div class=\"Vlt-box Vlt-box--white Vlt-box--lesspadding\" id=\"parts\">\n      <div v-for= \"(message, index) in messages\" class=\"Vlt-grid\">\n        <div class=\"Vlt-col Vlt-col--1of3\"><b>Part {{index + 1}}</b></div>\n        <div class=\"Vlt-col Vlt-col--2of3\">\n          <code>\n            <span v-if=\"messages.length > 1\">\n              <span class=\"Vlt-badge Vlt-badge--blue\">User Defined Header</span>\n              <span>&nbsp;</span>\n            </span>\n            {{message}}\n          </code>\n        </div>\n        <hr v-if=\"index + 1 !== messages.length\" class=\"hr--shorter\"/>\n      </div>\n    </div>\n  </div>\n</template>\n\n<script>\nimport CharacterCounter from './character_counter';\n\nexport default {\n  data: function () {\n    return {\n      body: 'It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.'\n    };\n  },\n  computed: {\n    smsInfo: function() {\n      return new CharacterCounter(this.body).getInfo();\n    },\n    messages: function() {\n      return this.smsInfo.messages;\n    },\n    unicodeRequired: function() {\n      return this.smsInfo.unicodeRequired;\n    },\n    smsComposition: function() {\n      let count = this.smsInfo.charactersCount;\n      let characters = this.pluralize('character', count);\n      let messagesLength = this.messages.length;\n      let parts = this.pluralize('part', messagesLength);\n\n      return `${count} ${characters} sent in ${messagesLength} message ${parts}`;\n    }\n  },\n  methods: {\n    pluralize: function(singular, count) {\n      if (count === 1) { return singular; }\n      return `${singular}s`;\n    }\n  }\n}\n</script>\n\n<style scoped>\n  textarea {\n    width: 100%;\n    height: 150px;\n    resize: vertical;\n  }\n  code {\n    whiteSpace: normal;\n    wordBreak: break-all;\n }\n</style>\n","\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n textarea {\n   width: 100%;\n   height: 150px;\n   resize: vertical;\n }\n code {\n   whiteSpace: normal;\n   wordBreak: break-all;\n}\n"]}]);



/***/ }),

/***/ "./node_modules/style-loader/index.js?!./node_modules/css-loader/dist/cjs.js?!./node_modules/vue-loader/lib/loaders/stylePostLoader.js!./node_modules/postcss-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css&":
/*!*************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/style-loader??ref--3-0!./node_modules/css-loader/dist/cjs.js??ref--3-1!./node_modules/vue-loader/lib/loaders/stylePostLoader.js!./node_modules/postcss-loader/lib??ref--3-2!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css& ***!
  \*************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

// style-loader: Adds some css to the DOM by adding a <style> tag

// load the styles
var content = __webpack_require__(/*! !../../../../node_modules/css-loader/dist/cjs.js??ref--3-1!../../../../node_modules/vue-loader/lib/loaders/stylePostLoader.js!../../../../node_modules/postcss-loader/lib??ref--3-2!../../../../node_modules/vue-loader/lib??vue-loader-options!./Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css& */ "./node_modules/css-loader/dist/cjs.js?!./node_modules/vue-loader/lib/loaders/stylePostLoader.js!./node_modules/postcss-loader/lib/index.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=style&index=0&id=301089c4&scoped=true&lang=css&");
if(typeof content === 'string') content = [[module.i, content, '']];
// Prepare cssTransformation
var transform;

var options = {"sourceMap":true}
options.transform = transform
// add the styles to the DOM
var update = __webpack_require__(/*! ../../../../node_modules/style-loader/lib/addStyles.js */ "./node_modules/style-loader/lib/addStyles.js")(content, options);
if(content.locals) module.exports = content.locals;
// Hot Module Replacement
if(false) {}

/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/concatenation/Concatenation.vue?vue&type=template&id=301089c4&scoped=true&":
/*!********************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/concatenation/Concatenation.vue?vue&type=template&id=301089c4&scoped=true& ***!
  \********************************************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c("div", { staticClass: "Vlt-box" }, [
    _c("h2", [_vm._v("Try it out")]),
    _vm._v(" "),
    _c("h4", [_vm._v("Message")]),
    _vm._v(" "),
    _c("div", { staticClass: "Vlt-textarea" }, [
      _c("textarea", {
        directives: [
          {
            name: "model",
            rawName: "v-model",
            value: _vm.body,
            expression: "body"
          }
        ],
        domProps: { value: _vm.body },
        on: {
          input: function($event) {
            if ($event.target.composing) {
              return
            }
            _vm.body = $event.target.value
          }
        }
      })
    ]),
    _vm._v(" "),
    _c("div", { staticClass: "Vlt-margin--top2" }),
    _vm._v(" "),
    _c("h4", [_vm._v("Data")]),
    _vm._v(" "),
    _c("div", { staticClass: "Vlt-box Vlt-box--white Vlt-box--lesspadding" }, [
      _c("div", { staticClass: "Vlt-grid" }, [
        _c("div", { staticClass: "Vlt-col Vlt-col--1of3" }, [
          _c("b", [_vm._v("Unicode is Required?")]),
          _vm._v(" "),
          _vm.unicodeRequired
            ? _c("i", {
                staticClass: "icon icon--large icon-check-circle color--success"
              })
            : _c("i", {
                staticClass: "icon icon--large icon-times-circle color--error"
              })
        ]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-col Vlt-col--2of3" }),
        _vm._v(" "),
        _c("hr", { staticClass: "hr--shorter" }),
        _vm._v(" "),
        _vm._m(0),
        _vm._v(" "),
        _c("div", {
          staticClass: "Vlt-col Vlt-col--2of3",
          attrs: { id: "sms-composition" },
          domProps: { innerHTML: _vm._s(_vm.smsComposition) }
        })
      ])
    ]),
    _vm._v(" "),
    _c("h4", [_vm._v("Parts")]),
    _vm._v(" "),
    _c(
      "div",
      {
        staticClass: "Vlt-box Vlt-box--white Vlt-box--lesspadding",
        attrs: { id: "parts" }
      },
      _vm._l(_vm.messages, function(message, index) {
        return _c("div", { staticClass: "Vlt-grid" }, [
          _c("div", { staticClass: "Vlt-col Vlt-col--1of3" }, [
            _c("b", [_vm._v("Part " + _vm._s(index + 1))])
          ]),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-col Vlt-col--2of3" }, [
            _c("code", [
              _vm.messages.length > 1
                ? _c("span", [
                    _c("span", { staticClass: "Vlt-badge Vlt-badge--blue" }, [
                      _vm._v("User Defined Header")
                    ]),
                    _vm._v(" "),
                    _c("span", [_vm._v(" ")])
                  ])
                : _vm._e(),
              _vm._v("\n          " + _vm._s(message) + "\n        ")
            ])
          ]),
          _vm._v(" "),
          index + 1 !== _vm.messages.length
            ? _c("hr", { staticClass: "hr--shorter" })
            : _vm._e()
        ])
      }),
      0
    )
  ])
}
var staticRenderFns = [
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "Vlt-col Vlt-col--1of3" }, [
      _c("b", [_vm._v("Length")])
    ])
  }
]
render._withStripped = true



/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/feedback/Feedback.vue?vue&type=template&id=5e5b128c&scoped=true&":
/*!**********************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/feedback/Feedback.vue?vue&type=template&id=5e5b128c&scoped=true& ***!
  \**********************************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c("div", { staticClass: "Vlt-box Vlt-box--left feedback" }, [
    _c("div", { staticClass: "Vlt-grid" }, [
      _c("div", { staticClass: "Vlt-col Vlt-col--3of4" }, [
        _c("h5", [_vm._v("Was this documentation helpful?")]),
        _vm._v(" "),
        _c("div", { staticClass: "sentiments" }, [
          _vm.uploadingSentiment
            ? _c("div", [
                _c("div", { staticClass: "Vlt-spinner Vlt-spinner--small" })
              ])
            : _vm._e(),
          _vm._v(" "),
          _c("div", [
            _c(
              "span",
              {
                class: [
                  { "Vlt-btn_active": _vm.sentiment == "positive" },
                  "Vlt-btn Vlt-btn--large Vlt-btn--tertiary Vlt-btn--icon"
                ],
                on: {
                  click: function($event) {
                    return _vm.setSentiment("positive")
                  }
                }
              },
              [
                _c("svg", { staticClass: "Vlt-green" }, [
                  _c("use", {
                    attrs: {
                      "xlink:href": "/symbol/volta-icons.svg#Vlt-icon-happy"
                    }
                  })
                ])
              ]
            ),
            _vm._v(" "),
            _c(
              "span",
              {
                class: [
                  { "Vlt-btn_active": _vm.sentiment == "negative" },
                  "Vlt-btn Vlt-btn--large Vlt-btn--tertiary Vlt-btn--icon"
                ],
                on: {
                  click: function($event) {
                    return _vm.setSentiment("negative")
                  }
                }
              },
              [
                _c("svg", { staticClass: "Vlt-red" }, [
                  _c("use", {
                    attrs: {
                      "xlink:href": "/symbol/volta-icons.svg#Vlt-icon-unhappy"
                    }
                  })
                ])
              ]
            )
          ])
        ])
      ]),
      _vm._v(" "),
      _c("div", { staticClass: "Vlt-col Vlt-col--right Vlt-col--1of4" }, [
        _vm.githubUrl
          ? _c("span", { attrs: { id: "feedback__improve" } }, [
              _c("svg", { staticClass: "Vlt-icon Vlt-black" }, [
                _c("use", {
                  attrs: {
                    "xlink:href": "/symbol/volta-icons.svg#Vlt-icon-github"
                  }
                })
              ]),
              _vm._v(" "),
              _c("a", { attrs: { href: _vm.githubUrl, target: "_blank" } }, [
                _vm._v(" Improve this page")
              ])
            ])
          : _vm._e()
      ])
    ]),
    _vm._v(" "),
    _vm.error
      ? _c("p", { staticClass: "form__error" }, [_vm._v(_vm._s(_vm.error))])
      : _vm._e(),
    _vm._v(" "),
    (_vm.sentiment && !_vm.showExtendedFields) || _vm.feedbackComplete
      ? _c("div", [
          _c("hr"),
          _vm._v(" "),
          _c("p", [_vm._v("Great! Thanks for the feedback.")])
        ])
      : _vm._e(),
    _vm._v(" "),
    _vm.showExtendedFields && _vm.id && !_vm.feedbackComplete
      ? _c("div", [
          _c("hr"),
          _vm._v(" "),
          _vm._m(0),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-form__element" }, [
            _vm._m(1),
            _vm._v(" "),
            _vm._m(2),
            _vm._v(" "),
            _c("div", { staticClass: "Vlt-textarea" }, [
              _c("textarea", {
                directives: [
                  {
                    name: "model",
                    rawName: "v-model",
                    value: _vm.comment,
                    expression: "comment"
                  }
                ],
                domProps: { value: _vm.comment },
                on: {
                  input: function($event) {
                    if ($event.target.composing) {
                      return
                    }
                    _vm.comment = $event.target.value
                  }
                }
              })
            ])
          ]),
          _vm._v(" "),
          !_vm.currentUser
            ? _c(
                "div",
                { staticClass: "Vlt-form__element Vlt-form__element--elastic" },
                [_vm._m(3), _vm._v(" "), _vm._m(4), _vm._v(" "), _vm._m(5)]
              )
            : _vm._e(),
          _vm._v(" "),
          _c("input", {
            staticClass: "Vlt-btn Vlt-btn--primary Vlt-btn--app",
            attrs: {
              disabled: _vm.isSubmitDisabled,
              type: "submit",
              value: "Send Feedback"
            },
            on: { click: _vm.submitFeedback }
          }),
          _vm._v(" "),
          _vm._m(6)
        ])
      : _vm._e(),
    _vm._v(" "),
    _vm.currentUser
      ? _c("p", [
          _c("br"),
          _vm._v(
            "\n    Logged in as " + _vm._s(_vm.currentUser.email) + ".\n    "
          ),
          _c("a", { attrs: { href: _vm.currentUser.signout_path } }, [
            _vm._v("Sign out")
          ])
        ])
      : _vm._e()
  ])
}
var staticRenderFns = [
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("p", [
      _vm._v(
        "We see that this page didn’t meet your expectations. We’re really sorry!"
      ),
      _c("br")
    ])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("p", [
      _c("strong", [
        _vm._v(
          "We’d like a chance to fix that. Please would you give us some more information?"
        )
      ])
    ])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { staticClass: "Vlt-label" }, [
      _vm._v("What didn’t work for me: "),
      _c("small", { staticClass: "Vlt-grey-darker" }, [_vm._v("(required)")])
    ])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("p", [
      _c("strong", [
        _vm._v("Can we let you know when we've solved your issue?")
      ])
    ])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("label", { staticClass: "Vlt-label" }, [
      _vm._v("My email: "),
      _c("small", { staticClass: "Vlt-grey-darker" }, [_vm._v("(optional)")])
    ])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("div", { staticClass: "Vlt-input" }, [
      _c("input", {
        attrs: { type: "email", size: "20", value: "email", id: "email" }
      })
    ])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("p", [
      _vm._v("Your data will be treated in accordance with our "),
      _c("a", { attrs: { href: "https://www.nexmo.com/privacy-policy" } }, [
        _vm._v("Privacy Policy")
      ]),
      _vm._v(", which sets out the rights you have in respect of your data.")
    ])
  }
]
render._withStripped = true



/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=template&id=6831c45a&":
/*!*******************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/jwt_generator/JwtGenerator.vue?vue&type=template&id=6831c45a& ***!
  \*******************************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c("div", { staticClass: "Vlt-card" }, [
    _c("h1", [_vm._v("JWT Generator")]),
    _vm._v(" "),
    _c(
      "div",
      {
        directives: [
          {
            name: "show",
            rawName: "v-show",
            value: !_vm.jwt,
            expression: "!jwt"
          }
        ],
        class: [_vm.computedClass, "Vlt-callout"]
      },
      [
        _c("i"),
        _vm._v(" "),
        _vm.invalidAcl
          ? _c("div", { staticClass: "Vlt-callout__content" }, [
              _vm._v("\n      Invalid ACL provided. Must be JSON\n    ")
            ])
          : _vm.invalidPrivateKey
          ? _c("div", { staticClass: "Vlt-callout__content" }, [
              _vm._v("\n      Invalid private key provided\n    ")
            ])
          : _vm._e(),
        _vm._v(" "),
        !_vm.invalidPrivateKey && !_vm.invalidAcl
          ? _c("div", {
              staticClass: "Vlt-callout__content",
              domProps: { innerHTML: _vm._s(_vm.callout) }
            })
          : _vm._e()
      ]
    ),
    _vm._v(" "),
    _c("div", { staticClass: "Vlt-grid" }, [
      _c("div", { staticClass: "Vlt-col" }, [
        _c("h2", [_vm._v("Parameters")]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-form__element" }, [
          _c("label", { staticClass: "Vlt-label" }, [_vm._v("Private Key")]),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-textarea" }, [
            _c("textarea", {
              directives: [
                {
                  name: "model",
                  rawName: "v-model",
                  value: _vm.privateKey,
                  expression: "privateKey"
                }
              ],
              attrs: { rows: "8", cols: "50", id: "private-key" },
              domProps: { value: _vm.privateKey },
              on: {
                input: function($event) {
                  if ($event.target.composing) {
                    return
                  }
                  _vm.privateKey = $event.target.value
                }
              }
            })
          ])
        ]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-form__element" }, [
          _c("label", { staticClass: "Vlt-label" }, [_vm._v("Application ID")]),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-input" }, [
            _c("input", {
              directives: [
                {
                  name: "model",
                  rawName: "v-model",
                  value: _vm.applicationId,
                  expression: "applicationId"
                }
              ],
              attrs: { id: "application-id" },
              domProps: { value: _vm.applicationId },
              on: {
                input: function($event) {
                  if ($event.target.composing) {
                    return
                  }
                  _vm.applicationId = $event.target.value
                }
              }
            })
          ])
        ]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-form__element" }, [
          _c(
            "label",
            {
              staticClass: "Vlt-label",
              attrs: { htmlFor: "example-input-icon-button" }
            },
            [_vm._v("Valid For")]
          ),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-composite" }, [
            _c("div", { staticClass: "Vlt-input" }, [
              _c("input", {
                directives: [
                  {
                    name: "model",
                    rawName: "v-model.number",
                    value: _vm.validFor,
                    expression: "validFor",
                    modifiers: { number: true }
                  }
                ],
                attrs: { type: "number", placeholder: "6" },
                domProps: { value: _vm.validFor },
                on: {
                  input: function($event) {
                    if ($event.target.composing) {
                      return
                    }
                    _vm.validFor = _vm._n($event.target.value)
                  },
                  blur: function($event) {
                    return _vm.$forceUpdate()
                  }
                }
              })
            ]),
            _vm._v(" "),
            _c("div", { staticClass: "Vlt-composite__append" }, [
              _c("div", { staticClass: "Vlt-native-dropdown" }, [
                _c(
                  "select",
                  {
                    directives: [
                      {
                        name: "model",
                        rawName: "v-model.number",
                        value: _vm.validForTimeUnit,
                        expression: "validForTimeUnit",
                        modifiers: { number: true }
                      }
                    ],
                    attrs: { defaultValue: "3600" },
                    on: {
                      change: function($event) {
                        var $$selectedVal = Array.prototype.filter
                          .call($event.target.options, function(o) {
                            return o.selected
                          })
                          .map(function(o) {
                            var val = "_value" in o ? o._value : o.value
                            return _vm._n(val)
                          })
                        _vm.validForTimeUnit = $event.target.multiple
                          ? $$selectedVal
                          : $$selectedVal[0]
                      }
                    }
                  },
                  [
                    _c("option", { attrs: { value: "1" } }, [
                      _vm._v("Seconds")
                    ]),
                    _vm._v(" "),
                    _c("option", { attrs: { value: "60" } }, [
                      _vm._v("Minutes")
                    ]),
                    _vm._v(" "),
                    _c("option", { attrs: { value: "3600" } }, [
                      _vm._v("Hours")
                    ]),
                    _vm._v(" "),
                    _c("option", { attrs: { value: "86400" } }, [
                      _vm._v("Days")
                    ])
                  ]
                )
              ])
            ])
          ])
        ]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-form__element" }, [
          _c("label", { staticClass: "Vlt-label" }, [_vm._v("Sub (optional)")]),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-input" }, [
            _c("input", {
              directives: [
                {
                  name: "model",
                  rawName: "v-model",
                  value: _vm.sub,
                  expression: "sub"
                }
              ],
              domProps: { value: _vm.sub },
              on: {
                input: function($event) {
                  if ($event.target.composing) {
                    return
                  }
                  _vm.sub = $event.target.value
                }
              }
            })
          ])
        ]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-form__element" }, [
          _c("label", { staticClass: "Vlt-label" }, [_vm._v("ACL (optional)")]),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-textarea" }, [
            _c("textarea", {
              directives: [
                {
                  name: "model",
                  rawName: "v-model",
                  value: _vm.acl,
                  expression: "acl"
                }
              ],
              attrs: { rows: "4", cols: "50", id: "acl" },
              domProps: { value: _vm.acl },
              on: {
                input: function($event) {
                  if ($event.target.composing) {
                    return
                  }
                  _vm.acl = $event.target.value
                }
              }
            })
          ])
        ])
      ]),
      _vm._v(" "),
      _c("div", { staticClass: "Vlt-col" }, [
        _c("h2", [_vm._v("Encoded")]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-form__element" }, [
          _c("label", { staticClass: "Vlt-label" }, [_vm._v("Your JWT")]),
          _vm._v(" "),
          _c("div", { staticClass: "Vlt-textarea" }, [
            _c("textarea", {
              directives: [
                {
                  name: "model",
                  rawName: "v-model",
                  value: _vm.jwt,
                  expression: "jwt"
                }
              ],
              attrs: { rows: "29", cols: "50", id: "jwt" },
              domProps: { value: _vm.jwt },
              on: {
                input: function($event) {
                  if ($event.target.composing) {
                    return
                  }
                  _vm.jwt = $event.target.value
                }
              }
            })
          ])
        ])
      ])
    ]),
    _vm._v(" "),
    _c("div", { staticClass: "Vlt-grid" }, [
      _c("div", { staticClass: "Vlt-col" }, [
        _c("h2", [_vm._v("Decoded")]),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-table Vlt-table--data" }, [
          _c("table", [
            _vm._m(0),
            _vm._v(" "),
            _c("tbody", [
              _c("tr", [
                _vm._m(1),
                _c("td", [_vm._v(_vm._s(_vm.applicationId))]),
                _c("td", [
                  _vm._v("The application ID this JWT uses for authentication")
                ])
              ]),
              _vm._v(" "),
              _c("tr", [
                _vm._m(2),
                _c("td", [_vm._v(_vm._s(_vm.iat))]),
                _c("td", [_vm._v("The time at which the token was issued")])
              ]),
              _vm._v(" "),
              _c("tr", [
                _vm._m(3),
                _c("td", [_vm._v(_vm._s(_vm.nbf))]),
                _c("td", [
                  _vm._v("The time at which the token should become valid")
                ])
              ]),
              _vm._v(" "),
              _c("tr", [
                _vm._m(4),
                _c("td", [_vm._v(_vm._s(_vm.exp))]),
                _c("td", [_vm._v("The time at which the token should expire")])
              ]),
              _vm._v(" "),
              _c("tr", [
                _vm._m(5),
                _c("td", [_vm._v(_vm._s(_vm.sub))]),
                _c("td", [
                  _vm._v(
                    "The subject identified by the JWT (only used for the Client SDKs)"
                  )
                ])
              ]),
              _vm._v(" "),
              _c("tr", [
                _vm._m(6),
                _c("td", [_vm._v(_vm._s(_vm.acl))]),
                _c("td", [
                  _vm._v("A list of permissions that this token will have")
                ])
              ]),
              _vm._v(" "),
              _c("tr", [
                _vm._m(7),
                _c("td", [_vm._v(_vm._s(_vm.jti))]),
                _c("td", [_vm._v("A unique identifier for the JWT")])
              ])
            ])
          ])
        ])
      ])
    ])
  ])
}
var staticRenderFns = [
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("thead", [
      _c("tr", [
        _c("th", [_vm._v("Name")]),
        _vm._v(" "),
        _c("th", [_vm._v("Value")]),
        _vm._v(" "),
        _c("th", [_vm._v("Meaning")])
      ])
    ])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("td", [_c("code", [_vm._v("application_id")])])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("td", [_c("code", [_vm._v("iat")])])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("td", [_c("code", [_vm._v("nbf")])])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("td", [_c("code", [_vm._v("exp")])])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("td", [_c("code", [_vm._v("sub")])])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("td", [_c("code", [_vm._v("acl")])])
  },
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("td", [_c("code", [_vm._v("jti")])])
  }
]
render._withStripped = true



/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/NDPArticle.vue?vue&type=template&id=19ea2ea0&":
/*!**********************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/search/NDPArticle.vue?vue&type=template&id=19ea2ea0& ***!
  \**********************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c("div", { staticClass: "Nxd-search__result" }, [
    _c(
      "a",
      { staticClass: "Nxd-search__result__link", attrs: { href: _vm.url } },
      [
        _c("div", [
          _c("h6", { staticClass: "Vlt-blue-dark" }, [
            _vm._v("\n        " + _vm._s(_vm.hit.title) + "\n        "),
            _vm.showHeading
              ? _c("small", [_vm._v(" > " + _vm._s(_vm.hit.heading))])
              : _vm._e()
          ]),
          _vm._v(" "),
          _c("p", { staticClass: "Nxd-search__result__desc" }, [
            _vm._v(_vm._s(_vm.description))
          ]),
          _vm._v(" "),
          _c("p", {
            staticClass: "Nxd-search__result__highlight",
            domProps: { innerHTML: _vm._s(_vm.snippet) }
          }),
          _vm._v(" "),
          _c(
            "span",
            { staticClass: "Vlt-badge Vlt-badge--grey Nxd-search__badge" },
            [_vm._v(_vm._s(_vm.badge))]
          )
        ])
      ]
    )
  ])
}
var staticRenderFns = []
render._withStripped = true



/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/Search.vue?vue&type=template&id=f2a57ba8&scoped=true&":
/*!******************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/search/Search.vue?vue&type=template&id=f2a57ba8&scoped=true& ***!
  \******************************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c("div", [
    _c("div", [
      _c("div", { staticClass: "Vlt-composite" }, [
        _c(
          "div",
          {
            staticClass: "Vlt-composite__prepend Vlt-composite__prepend--icon"
          },
          [
            _c("svg", [
              _c("use", {
                attrs: {
                  "xlink:href": "/symbol/volta-icons.svg#Vlt-icon-search"
                }
              })
            ])
          ]
        ),
        _vm._v(" "),
        _c("div", { staticClass: "Vlt-input" }, [
          _c("input", {
            directives: [
              {
                name: "model",
                rawName: "v-model",
                value: _vm.query,
                expression: "query"
              }
            ],
            attrs: {
              name: "query",
              placeholder: "Search",
              id: "searchbox-test",
              type: "text",
              autoComplete: "off"
            },
            domProps: { value: _vm.query },
            on: {
              keydown: function($event) {
                if (
                  !$event.type.indexOf("key") &&
                  _vm._k($event.keyCode, "esc", 27, $event.key, [
                    "Esc",
                    "Escape"
                  ])
                ) {
                  return null
                }
                return _vm.onEscDownHandler($event)
              },
              input: [
                function($event) {
                  if ($event.target.composing) {
                    return
                  }
                  _vm.query = $event.target.value
                },
                _vm.onInputHandler
              ]
            }
          })
        ])
      ])
    ]),
    _vm._v(" "),
    _c(
      "svg",
      {
        directives: [
          {
            name: "show",
            rawName: "v-show",
            value: _vm.query,
            expression: "query"
          }
        ],
        staticClass: "Nxd-search__clear"
      },
      [
        _c("use", {
          attrs: { "xlink:href": "/symbol/volta-icons.svg#Vlt-icon-cross" }
        })
      ]
    ),
    _vm._v(" "),
    _c(
      "div",
      {
        directives: [
          {
            name: "show",
            rawName: "v-show",
            value: _vm.showResults,
            expression: "showResults"
          }
        ],
        staticClass: "Nxd-search"
      },
      [
        _c("div", { staticClass: "Nxd-search__wrapper" }, [
          _c(
            "div",
            {
              directives: [
                {
                  name: "show",
                  rawName: "v-show",
                  value: _vm.loading,
                  expression: "loading"
                }
              ],
              staticClass: "spinner"
            },
            [_c("i", { staticClass: "icon icon-cog" })]
          ),
          _vm._v(" "),
          _c(
            "div",
            {
              directives: [
                {
                  name: "show",
                  rawName: "v-show",
                  value: !_vm.loading,
                  expression: "!loading"
                }
              ],
              staticClass: "Nxd-search__wrapper"
            },
            _vm._l(_vm.results, function(result) {
              return _c(
                "div",
                { key: result.index, staticClass: "Nxd-search__results" },
                [
                  _c("h3", { staticClass: "Nx-search__title" }, [
                    _vm._v(
                      "\n            " +
                        _vm._s(_vm.resultTitle(result.index)) +
                        "\n          "
                    )
                  ]),
                  _vm._v(" "),
                  result.hits.length > 0
                    ? _c("div", [
                        _vm.isZendeskArticle(result)
                          ? _c(
                              "div",
                              _vm._l(result.hits, function(hit) {
                                return _c("ZendeskArticle", {
                                  key: _vm.hitKey(result, hit),
                                  attrs: { hit: hit }
                                })
                              }),
                              1
                            )
                          : _vm.isNDPArticle(result)
                          ? _c(
                              "div",
                              _vm._l(result.hits, function(hit) {
                                return _c("NDPArticle", {
                                  key: _vm.hitKey(result, hit),
                                  attrs: { hit: hit }
                                })
                              }),
                              1
                            )
                          : _vm._e()
                      ])
                    : _c("div", [_vm._m(0, true)])
                ]
              )
            }),
            0
          )
        ])
      ]
    )
  ])
}
var staticRenderFns = [
  function() {
    var _vm = this
    var _h = _vm.$createElement
    var _c = _vm._self._c || _h
    return _c("p", { staticClass: "Nxd-search--no-results" }, [
      _c("i", [_vm._v("No results")])
    ])
  }
]
render._withStripped = true



/***/ }),

/***/ "./node_modules/vue-loader/lib/loaders/templateLoader.js?!./node_modules/vue-loader/lib/index.js?!./app/javascript/components/search/ZendeskArticle.vue?vue&type=template&id=3b48151e&":
/*!**************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/vue-loader/lib??vue-loader-options!./app/javascript/components/search/ZendeskArticle.vue?vue&type=template&id=3b48151e& ***!
  \**************************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
var render = function() {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  return _c("div", { staticClass: "Nxd-search__result" }, [
    _c(
      "a",
      {
        staticClass: "Nxd-search__result__link",
        attrs: { href: _vm.url, target: "_blank" }
      },
      [
        _c("div", [
          _c("h6", { staticClass: "Vlt-blue-dark" }, [
            _vm._v(_vm._s(_vm.title))
          ]),
          _vm._v(" "),
          _c("p", {
            staticClass: "Nxd-search__result__highlight",
            domProps: { innerHTML: _vm._s(_vm.snippet) }
          }),
          _vm._v(" "),
          _c(
            "span",
            { staticClass: "Vlt-badge Vlt-badge--grey Nxd-search__badge" },
            [_vm._v(_vm._s(_vm.badge))]
          )
        ])
      ]
    )
  ])
}
var staticRenderFns = []
render._withStripped = true



/***/ })

},[["./app/javascript/packs/application.js","runtime~application",0]]]);
//# sourceMappingURL=application-180575daa73f18fdd4db.chunk.js.map