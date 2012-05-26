(function() {
  var $, DssCopyUI, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  DssCopyUI = (function() {
    function DssCopyUI() {
      this.targetSelected = __bind(this.targetSelected, this);
      this.copy = __bind(this.copy, this);
    }
    DssCopyUI.prototype.copy = function() {
      return window.DSS.ElementPicker.pick(this.targetSelected, {
        'autoClear': true
      });
    };
    DssCopyUI.prototype.targetSelected = function(target) {
      return window.DSS.Copy.copy(target);
    };
    return DssCopyUI;
  })();
  DSS.CopyUI = new DssCopyUI();
}).call(this);
