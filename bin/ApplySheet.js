(function() {
  var $, ApplySheet, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  ApplySheet = (function() {
    function ApplySheet() {
      this.parseCSSBlock = __bind(this.parseCSSBlock, this);
      this.removeComments = __bind(this.removeComments, this);
      this.parseString = __bind(this.parseString, this);
      this.applyUrl = __bind(this.applyUrl, this);
      this.applyString = __bind(this.applyString, this);
      this.applyParsed = __bind(this.applyParsed, this);
    }
    ApplySheet.prototype.applyParsed = function(parsed) {
      var elem, elems, key, props, rule, val, _results;
      _results = [];
      for (rule in parsed) {
        props = parsed[rule];
        elems = $(rule);
        _results.push((function() {
          var _i, _len, _ref, _results2;
          _ref = $(rule);
          _results2 = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            elem = _ref[_i];
            _results2.push((function() {
              var _results3;
              _results3 = [];
              for (key in props) {
                val = props[key];
                key = "data-" + key;
                _results3.push($(elem).attr(key, val));
              }
              return _results3;
            })());
          }
          return _results2;
        })());
      }
      return _results;
    };
    ApplySheet.prototype.applyString = function(str) {
      var parsed;
      console.log("Applying string: " + str);
      parsed = this.parseString(str);
      return this.applyParsed(parsed);
    };
    ApplySheet.prototype.applyUrl = function(url) {
      var params, pasteServer;
      console.log("Applying URL: " + url);
      pasteServer = "http://localhost:4567/parrot?callback=?";
      params = {
        'url': url
      };
      return $.getJSON(pasteServer, params, this.applyString);
    };
    ApplySheet.prototype.parseString = function(str) {
      var block, blocks, pair, rules, _i, _len;
      rules = {};
      str = this.removeComments(str);
      blocks = str.split('}');
      blocks.pop();
      for (_i = 0, _len = blocks.length; _i < _len; _i++) {
        block = blocks[_i];
        pair = block.split('{');
        rules[$.trim(pair[0])] = this.parseCSSBlock(pair[1]);
      }
      return rules;
    };
    ApplySheet.prototype.removeComments = function(str) {
      return str.replace(/\/\*(\r|\n|.)*\*\//g, "");
    };
    ApplySheet.prototype.parseCSSBlock = function(str) {
      var d, declarations, loc, property, rule, value, _i, _len;
      rule = {};
      declarations = str.split(';');
      declarations.pop();
      for (_i = 0, _len = declarations.length; _i < _len; _i++) {
        d = declarations[_i];
        loc = d.indexOf(':');
        property = $.trim(d.substring(0, loc));
        value = $.trim(d.substring(loc + 1));
        if (property !== "" && value !== "") {
          rule[property] = value;
        }
      }
      return rule;
    };
    return ApplySheet;
  })();
  DSS.ApplySheet = new ApplySheet();
}).call(this);
