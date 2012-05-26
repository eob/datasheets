(function() {
  var $, Edit, module;
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  Edit = (function() {
    function Edit() {}
    return Edit;
  })();
  DSS.Edit = new Edit();
}).call(this);
