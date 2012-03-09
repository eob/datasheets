# Kix Templator 
#
#
# Ted Benson
# eob@csail.mit.edu | @edwardbenson | github:eob
# 


# ========================================================================
# |
# | Commands
# |
# ========================================================================
class AbstractTreeNodeCommand
  appliesTo: (node) ->
    alert("Please implement the appliesTo method!")

# Pass in the parent
# Returns the list of nodes to consider for individual
class AbstractTreeLevelCommand
  appliesTo: (node) ->
    alert("Please implement the appliesTo method!")

# Not for use. Applies to everything and draws a border around it
class DyeCommand
  signature: () ->
    return "dye"
  appliesTo: (node) ->
    return true
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    if node.css?
      node.css('border', '1px solid black')
      return []

class ValueCommand
  signature: () ->
    return "data-value"
  appliesTo: (node) ->
    return node.data? and node.data()["value"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["value"]
    res = evaluator.evaluate(expr, "string", context, bookmarks)
    node.html(res)
    node.addClass("kixValueNode")
    return []

class AttrCommand
  signature: () ->
    return "data-X"
  appliesTo: (node) ->
    return node.data? and node.data()["src"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["src"]
    res = evaluator.evaluate(expr, "string", context, bookmarks)
    node.attr("src", res)
    return []

class EnterCommand
  signature: () ->
    return "data-enter"
  appliesTo: (node) ->
    return node.data? and node.data()["enter"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["enter"]
    res = evaluator.evaluate(expr, "any", context, bookmarks)
    return [res]

class RepeatInnerCommand
  signature: () ->
    return "data-repeatInner"
  appliesTo: (node) ->
    return node.data? and node.data()["repeatinner"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["repeatinner"]
    contexts = evaluator.evaluate(expr, "array", context, bookmarks, templator)
    node.addClass("kixRepeatContainer")
    # 1. Clear out all the child elements except the first
    loopElem = $(node.children()[0])
    # 2. If contexts is empty, hide the first
    if context.length == 0
      loopElem.hide()
    else
      # 3. Else, loop once per context, wrapping in a push-pop of context
      loopHtml = loopElem.clone().wrap('<div></div>').parent().html()
      node.html("")
      for elem in contexts
        console.log(elem)
        newNode = $(loopHtml)
        newNode.addClass("kixRepeatedNode")
        context.push(elem)
        templator.evaluate(newNode, context, bookmarks)
        context.pop()
        node.append(newNode)

# ========================================================================
# |
# | Node Commands
# |
# ========================================================================



# If commands work on brothers of a tree at once,
# then add those nodes to the list of ones to explore
# each takes a set to a set

# ========================================================================
# |
# |  Templator
# |
# ========================================================================
class Templator 
  constructor: (evaluatorRegistry) ->
    @evaluator = evaluatorRegistry
    @commands = []
    # Note: the order in which commands are added is the order
    # in which they are applied to the DOM
    @.addCommand(new EnterCommand())
    @.addCommand(new ValueCommand())
    @.addCommand(new AttrCommand())
    @.repeatInner = new RepeatInnerCommand()

  addCommand: (command) ->
    @commands.push(command)

  evaluate: (node, context, bookmarks) ->
    unless context?
      context = [window]
    unless bookmarks?
      bookmarks = {}
    newContexts = []

    for command in @commands
      if command.appliesTo(node)
        nc = command.applyTo(node, @evaluator, context, bookmarks, @)
        context = context.concat(nc) # To propagate downward
        newContexts = newContexts.concat(nc) # To remove upon exit upware

    # Continue down the tree
    if @.repeatInner.appliesTo(node)
      contexts = @.repeatInner.applyTo(node, @evaluator, context, bookmarks, @)
    else
      # Travel into children
      toShow = @._handleConditionals(node.children(), context, bookmarks)
      for kid in toShow
        @.evaluate($(kid), context)
 
    for addedContext in newContexts 
      context.pop()
    
  # Side-effects:
  #  - Hides the branches that won't be entered
  # Returns:
  #  - The list of nodes at this level to be shown
  _handleConditionals: (nodes, context, heads) ->
    return nodes

  hide: (jqNode) ->
    jqNode.css("display", "none")

window.Templator = new Templator(window.Evaluator)

# context 
# each time span a new level, push it 
