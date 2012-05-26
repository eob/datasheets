(function() {
  var $, AbstractTreeLevelCommand, AbstractTreeNodeCommand, AttrCommand, DyeCommand, EnterCommand, RepeatInnerCommand, ReplaceInnerCommand, StopCommand, Templator, ValueCommand, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  AbstractTreeNodeCommand = (function() {
    function AbstractTreeNodeCommand() {}
    AbstractTreeNodeCommand.prototype.appliesTo = function(node) {
      return alert("Please implement the appliesTo method!");
    };
    return AbstractTreeNodeCommand;
  })();
  AbstractTreeLevelCommand = (function() {
    function AbstractTreeLevelCommand() {}
    AbstractTreeLevelCommand.prototype.appliesTo = function(node) {
      return alert("Please implement the appliesTo method!");
    };
    return AbstractTreeLevelCommand;
  })();
  DyeCommand = (function() {
    function DyeCommand() {}
    DyeCommand.prototype.signature = function() {
      return "dye";
    };
    DyeCommand.prototype.appliesTo = function(node) {
      return true;
    };
    DyeCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      if (node.css != null) {
        node.css('border', '1px solid black');
        return [];
      }
    };
    return DyeCommand;
  })();
  StopCommand = (function() {
    function StopCommand() {}
    StopCommand.prototype.signature = function() {
      return "data-stop";
    };
    StopCommand.prototype.appliesTo = function(node) {
      return node.length > 0 && (node.data != null) && (node.data()["stop"] != null);
    };
    return StopCommand;
  })();
  ValueCommand = (function() {
    function ValueCommand() {}
    ValueCommand.prototype.signature = function() {
      return "data-value";
    };
    ValueCommand.prototype.appliesTo = function(node) {
      return node.length > 0 && (node.data != null) && (node.data()["value"] != null);
    };
    ValueCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var expr, res;
      expr = node.data()["value"];
      res = evaluator.evaluate(expr, "string", context, bookmarks);
      node.html(res);
      node.addClass("kixValueNode");
      return [];
    };
    ValueCommand.prototype.extractData = function(node, templator, ctx) {
      var keepGoing;
      ctx[node.data("value")] = node.html();
      keepGoing = false;
      return [keepGoing, ctx];
    };
    return ValueCommand;
  })();
  AttrCommand = (function() {
    function AttrCommand() {}
    AttrCommand.prototype.signature = function() {
      return "data-X";
    };
    AttrCommand.prototype.appliesTo = function(node) {
      return node.length > 0 && (node.data != null) && (node.data()["src"] != null);
    };
    AttrCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var expr, res;
      expr = node.data()["src"];
      res = evaluator.evaluate(expr, "string", context, bookmarks);
      node.attr("src", res);
      return [];
    };
    return AttrCommand;
  })();
  EnterCommand = (function() {
    function EnterCommand() {}
    EnterCommand.prototype.signature = function() {
      return "data-enter";
    };
    EnterCommand.prototype.appliesTo = function(node) {
      return node.length > 0 && (node.data != null) && (node.data()["enter"] != null);
    };
    EnterCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var expr, res;
      expr = node.data()["enter"];
      res = evaluator.evaluate(expr, "any", context, bookmarks);
      return [res];
    };
    EnterCommand.prototype.extractData = function(node, templator, ctx) {
      var keepGoing, newCtx;
      newCtx = {};
      ctx[node.data("enter")] = newCtx;
      keepGoing = true;
      return [keepGoing, newCtx];
    };
    return EnterCommand;
  })();
  ReplaceInnerCommand = (function() {
    function ReplaceInnerCommand() {}
    ReplaceInnerCommand.prototype.signature = function() {
      return "data-replaceinner";
    };
    ReplaceInnerCommand.prototype.appliesTo = function(node) {
      return (node.data != null) && (node.data()["replaceinner"] != null);
    };
    ReplaceInnerCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var anchor, bullfrog, expr, parts, url;
      expr = node.data()["replaceinner"];
      parts = expr.split("#");
      url = parts[0];
      bullfrog = "http://localhost:4567/ribbit?callback=?";
      anchor = parts[1];
      return $.getJSON(bullfrog, {
        'url': url,
        'id': anchor
      }, __bind(function(data) {
        var d;
        console.warn("WARNING: in ajax callback. might be merging twice");
        d = $(data);
        templator.render(d, context);
        return node.html(d);
      }, this));
    };
    return ReplaceInnerCommand;
  })();
  RepeatInnerCommand = (function() {
    function RepeatInnerCommand() {}
    RepeatInnerCommand.prototype.signature = function() {
      return "data-repeatInner";
    };
    RepeatInnerCommand.prototype.appliesTo = function(node) {
      var d;
      if (node.length > 0) {
        if (node.data != null) {
          d = node.data();
          if ((d["repeatinner"] != null) || (d["repeatinner2"] != null) || d["repeatinner3"]) {
            return true;
          }
        }
      }
      return false;
    };
    RepeatInnerCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var blockSize, contexts, elem, expr, i, index0, index1, le, loopElems, loopHtml, newNode, _i, _j, _len, _len2, _results;
      blockSize = 1;
      expr = node.data()["repeatinner"];
      if (node.data()["repeatinner2"] != null) {
        expr = node.data()["repeatinner2"];
        blockSize = 2;
      }
      if (node.data()["repeatinner3"] != null) {
        expr = node.data()["repeatinner3"];
        blockSize = 3;
      }
      contexts = evaluator.evaluate(expr, "array", context, bookmarks, templator);
      console.log(contexts);
      node.addClass("kixRepeatContainer");
      loopElems = [];
      for (i = 0; 0 <= blockSize ? i < blockSize : i > blockSize; 0 <= blockSize ? i++ : i--) {
        loopElems.push($(node).children()[i]);
      }
      if (context.length === 0) {
        return loopElem.hide();
      } else {
        loopHtml = $("<div/>");
        for (_i = 0, _len = loopElems.length; _i < _len; _i++) {
          le = loopElems[_i];
          loopHtml.append($(le).clone().addClass("kixRepeadNode"));
        }
        console.log("loop block");
        console.log(loopHtml);
        node.html("");
        if (contexts) {
          index0 = 0;
          index1 = 1;
          _results = [];
          for (_j = 0, _len2 = contexts.length; _j < _len2; _j++) {
            elem = contexts[_j];
            elem["__DSS__idx0"] = index0;
            elem["__DSS__idx1"] = index1;
            newNode = $(loopHtml);
            context.push(elem);
            templator.render(newNode, context, bookmarks);
            context.pop();
            console.log("rendered");
            console.log(newNode.html());
            node.append(newNode.html());
            index0 += 1;
            _results.push(index1 += 1);
          }
          return _results;
        }
      }
    };
    RepeatInnerCommand.prototype.extractData = function(node, templator, ctx) {
      var empty, k, keepGoing, kid, kidData, kids, v, _i, _len, _ref;
      kids = [];
      _ref = node.children();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        kid = _ref[_i];
        kidData = templator.extractData($(kid));
        empty = true;
        for (k in kidData) {
          v = kidData[k];
          empty = false;
        }
        if (!empty) {
          kids.push(kidData);
        }
      }
      ctx[node.data("repeatinner")] = kids;
      keepGoing = false;
      return [keepGoing, ctx];
    };
    return RepeatInnerCommand;
  })();
  Templator = (function() {
    function Templator(evaluatorRegistry) {
      this.evaluator = evaluatorRegistry;
      this.commands = [];
      this.enterCommand = new EnterCommand();
      this.repeatInnerCommand = new RepeatInnerCommand();
      this.valueCommand = new ValueCommand();
      this.addCommand(this.enterCommand);
      this.addCommand(this.valueCommand);
      this.addCommand(new AttrCommand());
      this.addCommand(new ReplaceInnerCommand());
      this.dataStop = new StopCommand();
    }
    Templator.prototype.addCommand = function(command) {
      return this.commands.push(command);
    };
    Templator.prototype.extractTemplate = function(node) {
      return node.clone();
    };
    Templator.prototype.extractData = function(node, context) {
      var command, extractCommands, keepGoing, kid, res, thisContext, _i, _j, _len, _len2, _ref;
      if (context == null) {
        context = {};
      }
      thisContext = context;
      extractCommands = [this.enterCommand, this.valueCommand, this.repeatInnerCommand];
      keepGoing = true;
      for (_i = 0, _len = extractCommands.length; _i < _len; _i++) {
        command = extractCommands[_i];
        if (keepGoing && command.appliesTo(node)) {
          res = command.extractData(node, this, thisContext);
          keepGoing = keepGoing && res[0];
          thisContext = res[1];
        }
      }
      if (keepGoing) {
        _ref = node.children();
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          kid = _ref[_j];
          this.extractData($(kid), thisContext);
        }
      }
      return context;
    };
    Templator.prototype.render = function(node, context, bookmarks) {
      var addedContext, command, contexts, kid, nc, newContexts, toShow, _i, _j, _k, _len, _len2, _len3, _ref, _results;
      if (context == null) {
        context = [window];
      }
      if (bookmarks == null) {
        bookmarks = {};
      }
      newContexts = [];
      _ref = this.commands;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        command = _ref[_i];
        if (command.appliesTo(node)) {
          nc = command.applyTo(node, this.evaluator, context, bookmarks, this);
          context = context.concat(nc);
          newContexts = newContexts.concat(nc);
        }
      }
      if (this.dataStop.appliesTo(node)) {} else if (this.repeatInnerCommand.appliesTo(node)) {
        contexts = this.repeatInnerCommand.applyTo(node, this.evaluator, context, bookmarks, this);
      } else {
        toShow = this._handleConditionals(node.children(), context, bookmarks);
        for (_j = 0, _len2 = toShow.length; _j < _len2; _j++) {
          kid = toShow[_j];
          this.render($(kid), context);
        }
      }
      _results = [];
      for (_k = 0, _len3 = newContexts.length; _k < _len3; _k++) {
        addedContext = newContexts[_k];
        _results.push(context.pop());
      }
      return _results;
    };
    Templator.prototype._handleConditionals = function(nodes, context, heads) {
      return nodes;
    };
    Templator.prototype.hide = function(jqNode) {
      return jqNode.css("display", "none");
    };
    return Templator;
  })();
  DSS.Engine = new Templator(DSS.Evaluator);
}).call(this);
