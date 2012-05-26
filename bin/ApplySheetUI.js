(function() {
  var $, ApplyStylesheetUI, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  ApplyStylesheetUI = (function() {
    function ApplyStylesheetUI() {
      this.show = __bind(this.show, this);      this.anchor = $("<div id=\"applySheetAnchor\" style=\"margin:0; z-index:1000; position:absolute; top:139px; left:5px; height: 5px; width: 5px;\"></div>");
      $("body").append(this.anchor);
      this.ui = "<div style=\"padding: 5px; width:340px\">\n  <input style=\"width: 225px\" id=\"applyDssUrl\" style=\"border: 2px solid #555;\" value=\"http://localhost:8000/demo/dss/\" />\n  <p align=\"center\" style=\"marign-bottom:0\">\n  <button class=\"btn btn-primary applyDssBtn\">Apply</button>&nbsp;<button class=\"btn applyDssCancelBtn\">Cancel</button></p>\n</div>";
    }
    ApplyStylesheetUI.prototype.show = function() {
      DSS.Callout.callout(this.anchor, "Apply Datasheet", this.ui);
      $(".applyDssCancelBtn").click(__bind(function(event) {
        event.preventDefault();
        return DSS.Callout.close(this.anchor);
      }, this));
      return $(".applyDssBtn").click(__bind(function(event) {
        var dss;
        event.preventDefault();
        dss = $("#applyDssUrl").val();
        console.log("Got URL for application: " + dss);
        DSS.ApplySheet.applyUrl(dss);
        return DSS.Callout.close(this.anchor);
      }, this));
    };
    return ApplyStylesheetUI;
  })();
  DSS.ApplySheetUI = new ApplyStylesheetUI();
}).call(this);
