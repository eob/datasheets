(function() {
  var AbstractEvaluator, EvaluatorRegistry, JavascriptEvaluator, JsonEvaluator;
  AbstractEvaluator = (function() {
    function AbstractEvaluator() {}
    AbstractEvaluator.prototype.evaluate = function(expression, returnType, context, bookmarks) {
      return alert("Please implement the evaluate(..) function!");
    };
    AbstractEvaluator.prototype.signature = function() {
      return alert("Please implement the signature() function!");
    };
    return AbstractEvaluator;
  })();
  JsonEvaluator = (function() {
    function JsonEvaluator() {}
    JsonEvaluator.prototype.signature = function() {
      return "json";
    };
    JsonEvaluator.prototype.evaluate = function(expression, returnType, contexts, bookmarks) {
      var cmd, context, key, ret, _i, _len;
      console.log("Default Evaluator evaluating: " + expression);
      context = contexts[contexts.length - 1];
      if (expression === ".") {
        return context;
      }
      for (_i = 0, _len = bookmarks.length; _i < _len; _i++) {
        key = bookmarks[_i];
        if (expression.indexOf(key) === 0 && (expression.length === key.length || expression[key.length] === ".")) {
          eval("var ret = bookmarks." + expression + ";");
          return ret;
        }
      }
      ret = null;
      if (expression[0] === ".") {
        return eval("var ret = context" + expression + ";");
      } else {
        cmd = "var ret = context." + expression + ";";
        console.log(cmd);
        eval(cmd);
        return ret;
      }
    };
    return JsonEvaluator;
  })();
  JavascriptEvaluator = (function() {
    function JavascriptEvaluator() {}
    JavascriptEvaluator.prototype.signature = function() {
      return "js";
    };
    JavascriptEvaluator.prototype.evaluate = function(expression, returnType, context) {
      eval("var ret = " + expression + ";");
      return ret;
    };
    return JavascriptEvaluator;
  })();
  EvaluatorRegistry = (function() {
    function EvaluatorRegistry() {
      this.defaultEvaluator = "json";
      this.evaluators = {};
      this.addEvaluator(new JavascriptEvaluator());
      this.addEvaluator(new JsonEvaluator());
    }
    EvaluatorRegistry.prototype.addEvaluator = function(evaluator) {
      return this.evaluators[evaluator.signature()] = evaluator;
    };
    EvaluatorRegistry.prototype.evaluate = function(expression, returnType, context, bookmarks) {
      var engine, expr, groups, regex;
      regex = /^([A-Za-z0-9]+):(.*)$/g;
      groups = regex.exec(expression);
      if (groups) {
        engine = groups[1];
        expr = groups[2];
        if (this.evaluators[engine]) {
          return this.evaluators[engine].evaluate(expr, returnType, context, bookmarks);
        } else {
          console.log("No evaluator found to match " + engine + ". Expression: " + expr);
          return this.failNicely(expression, returnType, context, bookmarks);
        }
      } else {
        return this.evaluators[this.defaultEvaluator].evaluate(expression, returnType, context, bookmarks);
      }
    };
    EvaluatorRegistry.prototype.failNicely = function(expression, returnType, context, bookmarks) {
      if (returnType === 'array') {
        return [];
      } else if (returnType === 'object') {
        return {};
      } else if (returnType === 'string') {
        return "";
      } else {
        console.log("No return type specified");
        return "";
      }
    };
    return EvaluatorRegistry;
  })();
  window.Evaluator = new EvaluatorRegistry();
}).call(this);
