# Kix Evaluator
#
# - Abstract definition of "Evaluator"
# - Default JS evaluator
# - Evaluator Registry
#
# Ted Benson
# eob@csail.mit.edu | @edwardbenson | github:eob
# 


# ========================================================================
# |
# | Absract Evaluator
# |
# ========================================================================
class AbstractEvaluator
  # - Evaluates the `expression`.
  # - Optionally checks (or is sensitive to) the requested return type
  # - Context is an array of frames form which lookup will proceed top-down.
  # - Bookmarks is an array of 
  evaluate: (expression, returnType, context, bookmarks) ->
    alert("Please implement the evaluate(..) function!")

  # - Returns the signature that this evaluator responds to. For
  #   example, "sql" would be an appropriate response for a SQL-backed evaluator
  signature: () ->
    alert("Please implement the signature() function!")


# ========================================================================
# |
# | Default Evaluators
# |
# ========================================================================

# Reads into a json object
class JsonEvaluator
  signature: () -> "json"
  evaluate: (expression, returnType, contexts, bookmarks) ->
    console.log("Default Evaluator evaluating: " + expression)
    context = contexts[contexts.length - 1]

    if expression == "."
      return context 
    for key in bookmarks
      if expression.indexOf(key) == 0 and (expression.length == key.length or expression[key.length] == ".")
        eval("var ret = bookmarks." + expression + ";")
        return ret
    ret = null
    if expression[0] == "."
      eval("var ret = context" + expression + ";")
    else
      cmd = "var ret = context." + expression + ";"
      console.log(cmd)
      eval(cmd)
      return ret

# Interprets inline JavaScript 
class JavascriptEvaluator
  signature: () -> "js"
  evaluate: (expression, returnType, context) ->
    eval("var ret = " + expression + ";")
    return ret

# ========================================================================
# |
# | Evaluator Registry
# |  multiplexes multiple evaluators
# |
# ========================================================================
class EvaluatorRegistry
  constructor: () ->
    @defaultEvaluator = "json"
    @evaluators = {}
    @.addEvaluator(new JavascriptEvaluator())
    @.addEvaluator(new JsonEvaluator())

  addEvaluator: (evaluator) ->
    @evaluators[evaluator.signature()] = evaluator

  # An expression takes the form:
  #  "Engine:Expr", in which case we try to locate the right engine, or
  #  "Expr", in which case we use the default engine
  evaluate: (expression, returnType, context, bookmarks) ->
    regex = /^([A-Za-z0-9]+):(.*)$/g
    groups = regex.exec(expression)
    if (groups)
      engine = groups[1]
      expr = groups[2]
      if @evaluators[engine]
        return @evaluators[engine].evaluate(expr, returnType, context, bookmarks)
      else
        console.log("No evaluator found to match " + engine + ". Expression: " + expr)
        return @failNicely(expression, returnType, context, bookmarks)
    else
      return @evaluators[@defaultEvaluator].evaluate(expression, returnType, context, bookmarks)
  
  failNicely: (expression, returnType, context, bookmarks) ->
    if returnType == 'array'
      return []
    else if returnType == 'object'
      return {}
    else if returnType == 'string'
      return ""
    else
      console.log("No return type specified")
      return ""

window.Evaluator = new EvaluatorRegistry()
