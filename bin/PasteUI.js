(function() {
  var $, DssPasteUI, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  DssPasteUI = (function() {
    function DssPasteUI() {
      this.targetSelected = __bind(this.targetSelected, this);
      this.paste = __bind(this.paste, this);      this.target = null;
      this.ui = "<div>\n  <p align=\"center\" style=\"font-size: 1.3em\">\n    <input type=\"checkbox\" checked id=\"pasteData\" />Data &nbsp \n  <input type=\"checkbox\" checked id=\"pasteStyle\" />Style</p><br />\n  <div style=\"padding-left: 40px; float: left; margin-right: 5px;\">\n  <img src=\"http://localhost:8000/demo/where.png\" />\n  </div>\n  <div style=\"margin-left: 5px\">\n    <div style=\"margin-top:9px\">\n      <input type=\"radio\" style=\"margin-right: 3px\" data-location=\"before\" id=\"pasteBefore\" name=\"pasteWhere\" />Before\n    </div>\n    <div style=\"margin-top:18px\">\n      <input type=\"radio\" style=\"margin-right: 3px\" data-location=\"prepend\" id=\"pastePrepend\" name=\"pasteWhere\" />Prepend<br />\n    </div>\n    <div style=\"margin-top:-1px\">\n      <input type=\"radio\" tyle=\"margin-right: 3px\" data-location=\"replace\" id=\"pasteReplace\" name=\"pasteWhere\" />Replace<br />\n    </div>\n    <div style=\"margin-top:0px\">\n      <input type=\"radio\" style=\"margin-right: 3px\" data-location=\"append\" id=\"pasteAppend\" name=\"pasteWhere\" />Append<br />\n    </div>\n    <div style=\"margin-top:13px\">\n      <input type=\"radio\" style=\"margin-right: 3px\" data-location=\"after\" id=\"pasteAfter\" name=\"pasteWhere\" />After\n    </div>\n  </div>\n  <br />\n  <p align=\"center\">\n  <button class=\"btn btn-primary pasterBtn\">Paste</button>&nbsp<button class=\"btn pasteCancelBtn\">Cancel</button></p>\n</div>";
    }
    DssPasteUI.prototype.paste = function() {
      this.target = null;
      return window.DSS.ElementPicker.pick(this.targetSelected, {
        'autoClear': false
      });
    };
    DssPasteUI.prototype.targetSelected = function(target) {
      this.target = target;
      DSS.Callout.callout(target, "Paste", this.ui);
      $(".pasteCancelBtn").click(__bind(function(event) {
        event.preventDefault();
        DSS.ElementPicker.clearSelection();
        return DSS.Callout.close(this.target);
      }, this));
      return $(".pasterBtn").click(__bind(function(event) {
        var data, loc, opts, style;
        event.preventDefault();
        DSS.ElementPicker.clearSelection();
        data = $("#pasteData").is(":checked");
        style = $("#pasteStyle").is(":checked");
        loc = $("input:radio[name=pasteWhere]:checked").data("location");
        opts = {
          'location': loc,
          'style': style,
          'data': data
        };
        DSS.Callout.close(this.target);
        DSS.Paste.paste(this.target, opts);
        return this.target = null;
      }, this));
    };
    return DssPasteUI;
  })();
  DSS.PasteUI = new DssPasteUI();
}).call(this);
