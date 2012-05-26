# Copyright (c) 2012 Edward Benson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Preamble
$ = jQueryDss
module = (name) ->
  window[name] = window[name] or {}

# Ensure the DSS namespace
module 'DSS'

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
    #console.log("Default Evaluator evaluating: " + expression)
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
      #console.log(cmd)
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

DSS.Evaluator = new EvaluatorRegistry()
