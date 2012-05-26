(function() {
  var $, DssCallout, module;
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  DssCallout = (function() {
    function DssCallout() {}
    DssCallout.prototype.callout = function(node, title, body) {
      $(node).popover({
        'title': title,
        'content': body,
        'trigger': 'manual'
      });
      return $(node).popover('show');
    };
    DssCallout.prototype.close = function(node) {
      return $(node).popover('hide');
    };
    return DssCallout;
  })();
  DSS.Callout = new DssCallout();
}).call(this);
