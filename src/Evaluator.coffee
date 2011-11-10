# Every Evaluator module must implement the functions:
#   - evaluate(expression, returnType, context) : returnType
#   - signature() : String
class DefaultEvaluator
  evaluate: (expression, returnType, context, bookmarks) ->
    if expression == "."
      return context 
    for key in bookmarks
      if expression.indexOf(key) == 0 and (expression.length == key.length or expression[key.length] == ".")
        eval("var ret = bookmarks." + expression + ";")
        return ret
    if expression[0] == "."
      eval("var ret = context" + expression + ";")
      return ret
    else
      eval("var ret = context." + expression + ";")
      return ret

# Interprets inline JavaScript 
class JsEvaluator
  signature: () -> "js"
  evaluate: (expression, returnType, context) ->
    eval("var ret = " + expression + ";")
    return ret

# The main entry point
class Evaluator
  constructor: () ->
    @defaultEvaluator = new DefaultEvaluator()
    @evaluators = {}

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
      return @defaultEvaluator.evaluate(expression, returnType, context, bookmarks)
  
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

class Templator
  constructor: (jQuery) ->
    @jQuery = jQuery
    @evaluator = new Evaluator()
    @evaluator.addEvaluator(new JsEvaluator())
  
  enterNode: (node, ctx) ->
    contexts = []
    for c in ctx
      contexts.push(c)
    jNode = @jQuery(node)

    data = @jQuery(node).data()
    
    if data["enter"]
      expr = data["enter"]
      obj = @evaluator.evaluate(expr, "any", contexts[contexts.length - 1], {})
      contexts.push(obj)
   
    if data["content"]
      expr = data["content"]
      html = @evaluator.evaluate(expr, "string", contexts[contexts.length - 1], {})
      @jQuery(node).html(html)
    else if data["repeat"]
      console.log("Repeat")
      expr = data["repeat"]
      container = @evaluator.evaluate(expr, "array", contexts[contexts.length - 1], {})
      loopElem = @jQuery(node).children()[0]
      loopHtml = @jQuery(loopElem).clone().wrap('<div></div>').parent().html();
      @jQuery(node).html("")
      for elem in container
        newNode = @jQuery(loopHtml) 
        contexts.push(elem)
        @enterNode(newNode, contexts)
        contexts.pop()
        @jQuery(node).append(newNode)
    else
      for child in @jQuery(node).children()
        @enterNode(child, contexts)

  go: () ->
    @enterNode(@jQuery('body'), [window])

window['Templator'] = Templator
