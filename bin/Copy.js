(function() {
  var $, DssCopy, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  $.fn = $.fn || {};
  $.fn.css2 = $.fn.css;
  $.fn.css = function() {
    var attr, attrs, obj, _i, _len;
    if (arguments.length) {
      return $.fn.css2.apply(this, arguments);
    }
    attrs = ['font-family', 'font-size', 'font-weight', 'font-style', 'color', 'text-transform', 'text-decoration', 'letter-spacing', 'word-spacing', 'line-height', 'text-align', 'vertical-align', 'direction', 'background-color', 'background-image', 'background-repeat', 'background-position', 'background-attachment', 'opacity', 'top', 'right', 'bottom', 'left', 'margin-top', 'margin-right', 'margin-bottom', 'margin-left', 'padding-top', 'padding-right', 'padding-bottom', 'padding-left', 'border-top-width', 'border-right-width', 'border-bottom-width', 'border-left-width', 'border-top-color', 'border-right-color', 'border-bottom-color', 'border-left-color', 'border-top-style', 'border-right-style', 'border-bottom-style', 'border-left-style', 'position', 'display', 'visibility', 'z-index', 'overflow-x', 'overflow-y', 'white-space', 'clip', 'float', 'clear', 'cursor', 'list-style-image', 'list-style-position', 'list-style-type', 'marker-offset'];
    obj = {};
    for (_i = 0, _len = attrs.length; _i < _len; _i++) {
      attr = attrs[_i];
      obj[attr] = $.fn.css2.call(this, attr);
    }
    return obj;
  };
  DssCopy = (function() {
    function DssCopy() {
      this.hashToHtml = __bind(this.hashToHtml, this);
    }
    DssCopy.prototype.copy = function(node, options) {
      var opts, ret;
      opts = $.extend({}, {
        'style': true
      }, options);
      ret = null;
      if (opts.style) {
        ret = this.hashToHtml(this.grabStyle(node));
      } else {
        ret = node.clone().wrap('<div></div>').parent().html();
      }
      this.doCopyString(ret);
      return ret;
    };
    DssCopy.prototype.doCopyString = function(str) {
      var copyPasteServer;
      copyPasteServer = "http://localhost:4567";
      return $.post(copyPasteServer + "/copy", {
        'data': str
      });
    };
    DssCopy.prototype.cssForNode = function(node) {
      var i, o, r, rules, sheets, _i, _j, _len, _len2;
      return node.css();
      sheets = document.styleSheets;
      o = {};
      for (_i = 0, _len = sheets.length; _i < _len; _i++) {
        i = sheets[_i];
        rules = i.rules || i.cssRules;
        for (_j = 0, _len2 = rules.length; _j < _len2; _j++) {
          r = rules[_j];
          if (node.is(r.selectorText)) {
            o = $.extend(o, this.css2json(r.style), this.css2json(node.attr('style')));
          }
        }
      }
      return o;
    };
    DssCopy.prototype.css2json = function(css) {
      var i, l, s, _i, _j, _len, _len2;
      s = {};
      if (!css) {
        return s;
      }
      if (css instanceof CSSStyleDeclaration) {
        for (_i = 0, _len = css.length; _i < _len; _i++) {
          i = css[_i];
          if (css[i].toLowerCase) {
            s[i.toLowerCase()] = css[i];
          }
        }
      } else if (typeof css === "string") {
        css = css.split("; ");
        for (_j = 0, _len2 = css.length; _j < _len2; _j++) {
          i = css[_j];
          l = css[i].split(": ");
          s[l[0].toLowerCase()] = l[1];
        }
      }
      return s;
    };
    DssCopy.prototype.descForNode = function(node) {
      var desc, i, _i, _len, _ref;
      desc = {};
      if ((node[0].tagName != null)) {
        desc["type"] = "node";
        desc["tagName"] = node[0].tagName;
        desc["attrs"] = {};
        _ref = node[0].attributes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          desc.attrs[i.nodeName] = i.nodeValue;
        }
      } else if (node[0].nodeName === "#text") {
        desc["type"] = "text";
        desc["value"] = node[0].textContent;
      } else if (node[0].nodeName === "#comment") {
        desc["type"] = "comment";
        desc["value"] = node[0].textContent;
      }
      return desc;
    };
    DssCopy.prototype.buildStyles = function(node) {
      var copy, html, styles;
      styles = this.cssForNode(node);
      html = this.copy(node, {
        'style': false
      });
      copy = $(html);
      return console.log(window.getComputedStyle(copy[0]));
    };
    DssCopy.prototype.grabStyle = function(node) {
      var hash;
      hash = this.buildHash(node);
      this.bubbleUp(hash);
      return hash;
    };
    DssCopy.prototype.buildHash = function(node, parent) {
      var child, definition, hash, _i, _len, _ref;
      definition = this.descForNode(node);
      hash = {
        html: definition
      };
      if (definition.type === "node") {
        hash["styles"] = this.cssForNode(node);
        hash["children"] = [];
        _ref = node.contents();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          hash.children.push(this.buildHash($(child), hash));
        }
      }
      return hash;
    };
    DssCopy.prototype.hashToHtml = function(hash) {
      var k, kid, str, v, _i, _len, _ref, _ref2, _ref3;
      str = "";
      if (hash.html.type === "node") {
        str = "<" + hash.html.tagName + " ";
        _ref = hash.html.attrs;
        for (k in _ref) {
          v = _ref[k];
          str += k + "=\"" + v + "\" ";
        }
        str += "style=\"";
        _ref2 = hash.styles;
        for (k in _ref2) {
          v = _ref2[k];
          str += k + ":" + v + ";";
        }
        str += "\"";
        str += ">";
        _ref3 = hash.children;
        for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
          kid = _ref3[_i];
          str += this.hashToHtml(kid);
        }
        str += "</" + hash.html.tagName + ">";
      } else if (hash.html.type === "text") {
        str = hash.html.value;
      } else if (hash.html.type === "comment") {
        str = "<!-- " + hash.html.value + " -->";
      }
      return str;
    };
    DssCopy.prototype.bubbleUp = function(node) {
      var child, cssProp, cssVal, _i, _len, _ref, _ref2, _results;
      if (node.children != null) {
        _ref = node.children;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          this.bubbleUp(child);
        }
      }
      if (node.parent != null) {
        _ref2 = node.styles;
        _results = [];
        for (cssProp in _ref2) {
          cssVal = _ref2[cssProp];
          _results.push((node.parent.styles[cssProp] != null) && node.parent.styles[cssProp] === cssVal ? delete node.styles[cssProp] : void 0);
        }
        return _results;
      }
    };
    return DssCopy;
  })();
  DSS.Copy = new DssCopy();
}).call(this);
