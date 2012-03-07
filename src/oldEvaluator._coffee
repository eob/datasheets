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
  evaluate: (expression, returnType, context, bookmarks) ->
    console.log("Default Evaluator evaluating: " + expression)
    console.log("Context is: ")
    console.log(context)
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

# A template is a node
class Template
  constructor: (node) ->
    @node = node
  hasData: (data) ->
    True

class IfTemplate 
  applies: (template) ->
    template.node.hasData("if")


# Rendered is a node and the set of children nodes
class Rendered
  constructor: (template, context) ->
    @template = template
    @.render();

class Templator
  constructor: (jQuery) ->
    @jQuery = jQuery
    @evaluator = new Evaluator()
    @evaluator.addEvaluator(new JsEvaluator())

  # There are two possibilities:
  #   1.  The node has a loop-inner
  #   2.  The node is a loop
  #   3.  Else
  RecoverTemplate: (node, firstTime=true) ->
    if firstTime
      n = @jQuery(node).clone()
    else
      n = @jQuery(node)

    if n.data("repeatinner")
      # Only keep one child
      onlyChild = jQuery(n.children()[0])
      n.empty()
      n.append(onlyChild)
    
    if (n.data("repeat"))
      # Get the definition of this element -- tag + attributes
      signature = @.nodeSignature(n)
      bro = n.next()
      while bro.length > 0 and @.nodeSignature(bro) == signature
        bro.remove()
        bro = n.next()
    
    @.RecoverTemplate(c, false) for c in n.children()
    return n

  nodeSignature: (jqNode) ->
    return jqNode.clone().empty().wrap("<div></div>").parent().html()

  enterNode: (node, ctx, topRepeat = false) ->
    contexts = []
    for c in ctx
      contexts.push(c)
    jNode = @jQuery(node)

    data = jNode.data()
    
    if data["enter"]
      console.log("Entering")
      expr = data["enter"]
      obj = @evaluator.evaluate(expr, "any", contexts[contexts.length - 1], {})
      console.log(obj)
      contexts.push(obj)

    if data["repeat"] and (! topRepeat)
      expr = data["repeat"]
      container = @evaluator.evaluate(expr, "array", contexts[contexts.length - 1], {})
      loopHtml = @jQuery(node).clone().wrap('<div></div>').parent().html();
      lastOne = node
      for elem in container
        newNode = @jQuery(loopHtml) 
        contexts.push(elem)
        @enterNode(newNode, contexts, true)
        contexts.pop()
        @jQuery(newNode).insertAfter(lastOne)
        lastOne = @jQuery(newNode)
      @jQuery(node).remove()
 
    if jNode.attr("itemprop")?
      expr = jNode.attr("itemprop"]
      html = @evaluator.evaluate(expr, "string", contexts[contexts.length - 1], {})
      jNode.html(html)
    else if data["repeatinner"]
      expr = data["repeatinner"]
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

window['Templator'] = new Templator($)
