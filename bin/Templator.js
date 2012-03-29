(function() {
  var AbstractTreeLevelCommand, AbstractTreeNodeCommand, AttrCommand, DyeCommand, EnterCommand, RepeatInnerCommand, ReplaceInnerCommand, StopCommand, Templator, ValueCommand;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
      return (node.data != null) && (node.data()["stop"] != null);
    };
    return StopCommand;
  })();
  ValueCommand = (function() {
    function ValueCommand() {}
    ValueCommand.prototype.signature = function() {
      return "data-value";
    };
    ValueCommand.prototype.appliesTo = function(node) {
      return (node.data != null) && (node.data()["value"] != null);
    };
    ValueCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var expr, res;
      expr = node.data()["value"];
      res = evaluator.evaluate(expr, "string", context, bookmarks);
      node.html(res);
      node.addClass("kixValueNode");
      return [];
    };
    return ValueCommand;
  })();
  AttrCommand = (function() {
    function AttrCommand() {}
    AttrCommand.prototype.signature = function() {
      return "data-X";
    };
    AttrCommand.prototype.appliesTo = function(node) {
      return (node.data != null) && (node.data()["src"] != null);
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
      return (node.data != null) && (node.data()["enter"] != null);
    };
    EnterCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var expr, res;
      expr = node.data()["enter"];
      res = evaluator.evaluate(expr, "any", context, bookmarks);
      return [res];
    };
    return EnterCommand;
  })();
  ReplaceInnerCommand = (function() {
    function ReplaceInnerCommand() {}
    ReplaceInnerCommand.prototype.signature = function() {
      return "data-replaceinner";
    };
    ReplaceInnerCommand.prototype.appliesTo = function(node) {
      console.log("replace inner command");
      return (node.data != null) && (node.data()["replaceinner"] != null);
    };
    ReplaceInnerCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var anchor, bullfrog, expr, parts, url;
      console.log("replace inner");
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
        templator.evaluate(d, context);
        return node.append(d);
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
      return (node.data != null) && (node.data()["repeatinner"] != null);
    };
    RepeatInnerCommand.prototype.applyTo = function(node, evaluator, context, bookmarks, templator) {
      var contexts, elem, expr, loopElem, loopHtml, newNode, _i, _len, _results;
      expr = node.data()["repeatinner"];
      contexts = evaluator.evaluate(expr, "array", context, bookmarks, templator);
      node.addClass("kixRepeatContainer");
      loopElem = $(node.children()[0]);
      if (context.length === 0) {
        return loopElem.hide();
      } else {
        loopHtml = loopElem.clone().wrap('<div></div>').parent().html();
        node.html("");
        _results = [];
        for (_i = 0, _len = contexts.length; _i < _len; _i++) {
          elem = contexts[_i];
          console.log(elem);
          newNode = $(loopHtml);
          newNode.addClass("kixRepeatedNode");
          context.push(elem);
          templator.evaluate(newNode, context, bookmarks);
          context.pop();
          _results.push(node.append(newNode));
        }
        return _results;
      }
    };
    return RepeatInnerCommand;
  })();
  Templator = (function() {
    function Templator(evaluatorRegistry) {
      this.evaluator = evaluatorRegistry;
      this.commands = [];
      this.addCommand(new EnterCommand());
      this.addCommand(new ValueCommand());
      this.addCommand(new AttrCommand());
      this.addCommand(new ReplaceInnerCommand());
      this.repeatInner = new RepeatInnerCommand();
      this.dataStop = new StopCommand();
    }
    Templator.prototype.addCommand = function(command) {
      return this.commands.push(command);
    };
    Templator.prototype.evaluate = function(node, context, bookmarks) {
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
      if (this.dataStop.appliesTo(node)) {} else if (this.repeatInner.appliesTo(node)) {
        contexts = this.repeatInner.applyTo(node, this.evaluator, context, bookmarks, this);
      } else {
        toShow = this._handleConditionals(node.children(), context, bookmarks);
        for (_j = 0, _len2 = toShow.length; _j < _len2; _j++) {
          kid = toShow[_j];
          this.evaluate($(kid), context);
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
      console.log(nodes);
      return nodes;
    };
    Templator.prototype.hide = function(jqNode) {
      return jqNode.css("display", "none");
    };
    return Templator;
  })();
  window.Templator = new Templator(window.Evaluator);
}).call(this);
