(function() {
  var $, DssPaste, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  DssPaste = (function() {
    function DssPaste() {
      this.fetchPasteContent = __bind(this.fetchPasteContent, this);
      this.paste = __bind(this.paste, this);
    }
    DssPaste.prototype.paste = function(anchor, options) {
      return this.fetchPasteContent(__bind(function(html) {
        var data, node, opts, replacementNode, template;
        opts = $.extend({}, {
          'location': 'prepend',
          'style': true,
          'data': true
        }, options);
        node = $(html);
        replacementNode = $();
        if (opts.data && opts.style) {
          replacementNode = node;
        } else if (opts.data && !opts.style) {
          data = DSS.Engine.extractData(node);
          console.log("Pasted data:");
          console.log(data);
          template = DSS.Engine.extractTemplate(anchor);
          replacementNode = DSS.Engine.render(template, [data]);
          replacementNode = template;
        } else if (opts.style && !opts.data) {
          data = DSS.Engine.extractData(anchor);
          console.log("Pasted data:");
          console.log(data);
          template = DSS.Engine.extractTemplate(node);
          DSS.Engine.render(template, [data]);
          replacementNode = template;
        }
        return this.pasteNode(anchor, replacementNode, opts.location);
      }, this));
    };
    DssPaste.prototype.fetchPasteContent = function(callback) {
      var pasteServer;
      pasteServer = "http://localhost:4567";
      return $.getJSON(pasteServer + "/paste?callback=?", callback);
    };
    DssPaste.prototype.pasteNode = function(anchor, node, location) {
      switch (location) {
        case "replace":
          anchor.replaceWith(node);
          break;
        case "prepend":
          anchor.prepend(node);
          break;
        case "append":
          anchor.append(node);
          break;
        case "before":
          anchor.before(node);
          break;
        case "after":
          anchor.after(node);
          break;
        default:
          return console.log("Error: did not understand location: " + location);
      }
    };
    return DssPaste;
  })();
  DSS.Paste = new DssPaste();
}).call(this);
