(function() {
  var $, EditUI, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  EditUI = (function() {
    function EditUI() {
      this.stopEditingData = __bind(this.stopEditingData, this);
      this.editData = __bind(this.editData, this);      this.loadAloha();
      this.AlohaRequire = ['aloha', 'aloha/jquery', 'aloha/floatingmenu', 'common/link'];
    }
    EditUI.prototype.editData = function() {
      return $.each($(".kixValueNode"), __bind(function(idx, elem) {
        var alohaFunc;
        elem = Aloha.jQuery(elem);
        if (elem.offset != null) {
          alohaFunc = function(Aloha, $, FloatingMenu) {
            return $(elem).aloha();
          };
          return Aloha.require(this.AlohaRequire, alohaFunc);
        }
      }, this));
    };
    EditUI.prototype.stopEditingData = function() {
      return $.each($(".kixValueNode"), __bind(function(idx, elem) {
        elem = Aloha.jQuery(elem);
        if (elem.offset != null) {
          return Aloha.jQuery(elem).mahalo();
        }
      }, this));
    };
    EditUI.prototype.editTemplate = function() {
      $.each($(".kixValueNode"), __bind(function(idx, elem) {
        elem = $(elem);
        if (elem.offset != null) {
          return Aloha.jQuery(elem).alohaBlock();
        }
      }, this));
      return Aloha.jQuery(".segment").aloha();
    };
    EditUI.prototype.stopEditingTemplate = function() {
      $.each($(".kixValueNode"), __bind(function(idx, elem) {
        elem = Aloha.jQuery(elem);
        if ((elem.offset != null) && (elem.mahaloBlock != null)) {
          return elem.mahaloBlock();
        }
      }, this));
      return Aloha.jQuery(".segment").mahalo();
    };
    EditUI.prototype.loadAloha = function() {
      var config;
      config = document.createElement("script");
      config.type = "text/javascript";
      config.src = "http://localhost:8000/demo/aloha-setup.js";
      return document.head.appendChild(config);
    };
    return EditUI;
  })();
  DSS.EditUI = new EditUI();
}).call(this);
