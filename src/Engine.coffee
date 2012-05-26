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

class StopCommand
  signature: () ->
    return "data-stop"
  appliesTo: (node) ->
    return node.length > 0 and node.data? and node.data()["stop"]?
 
class ValueCommand
  signature: () ->
    return "data-value"
  appliesTo: (node) ->
    return node.length > 0 and node.data? and node.data()["value"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["value"]
    res = evaluator.evaluate(expr, "string", context, bookmarks)
    node.html(res)
    node.addClass("kixValueNode")
    return []
  extractData: (node, templator, ctx) ->
    ctx[node.data("value")] = node.html()
    keepGoing = no
    [keepGoing, ctx]

class AttrCommand
  signature: () ->
    return "data-X"
  appliesTo: (node) ->
    return node.length > 0 and node.data? and node.data()["src"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["src"]
    res = evaluator.evaluate(expr, "string", context, bookmarks)
    node.attr("src", res)
    return []

class EnterCommand
  signature: () ->
    return "data-enter"
  appliesTo: (node) ->
    return node.length > 0 and node.data? and node.data()["enter"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["enter"]
    res = evaluator.evaluate(expr, "any", context, bookmarks)
    return [res]
  extractData: (node, templator, ctx) ->
    newCtx = {}
    ctx[node.data("enter")] = newCtx
    keepGoing = yes
    [keepGoing, newCtx]

class ReplaceInnerCommand
  signature: () ->
    return "data-replaceinner"
  appliesTo: (node) ->
    return node.data? and node.data()["replaceinner"]?
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    expr = node.data()["replaceinner"]
    parts = expr.split("#")
    url = parts[0]
    bullfrog = "http://localhost:4567/ribbit?callback=?"
    anchor = parts[1]
    $.getJSON(bullfrog, {'url':url,'id':anchor}, (data) =>
      console.warn("WARNING: in ajax callback. might be merging twice")
      d = $(data)
      templator.render(d, context)
      node.html(d)
    )

class RepeatInnerCommand
  signature: () ->
    return "data-repeatInner"
  appliesTo: (node) ->
    if node.length > 0
      if node.data?
        d = node.data()
        if d["repeatinner"]? or d["repeatinner2"]? or d["repeatinner3"]
          return true
    return false
 
  applyTo: (node, evaluator, context, bookmarks, templator) ->
    blockSize = 1
    expr = node.data()["repeatinner"]
    if node.data()["repeatinner2"]?
      expr = node.data()["repeatinner2"]
      blockSize = 2
    if node.data()["repeatinner3"]?
      expr = node.data()["repeatinner3"]
      blockSize = 3
    contexts = evaluator.evaluate(expr, "array", context, bookmarks, templator)
    console.log(contexts)
    node.addClass("kixRepeatContainer")
    # 1. Clear out all the child elements except the first
    loopElems = []
    loopElems.push($(node).children()[i]) for i in [0...blockSize]
    # 2. If contexts is empty, hide the first
    if context.length == 0
      loopElem.hide()
    else
      loopHtml = $("<div/>")
      for le in loopElems
        loopHtml.append($(le).clone().addClass("kixRepeadNode"))
      console.log("loop block")
      console.log(loopHtml)
      node.html("")
      if contexts
        index0 = 0
        index1 = 1
        for elem in contexts
          elem["__DSS__idx0"] = index0
          elem["__DSS__idx1"] = index1
          newNode = $(loopHtml)
          context.push(elem)
          templator.render(newNode, context, bookmarks)
          context.pop()
          console.log("rendered")
          console.log(newNode.html())
          node.append(newNode.html())
          index0 += 1
          index1 += 1
  extractData: (node, templator, ctx) ->
    kids = []
    for kid in node.children()
      kidData = templator.extractData($(kid))
      empty = true
      for k,v of kidData
        empty = false
      unless empty 
        kids.push(kidData)
    ctx[node.data("repeatinner")] = kids
    keepGoing = no
    [keepGoing, ctx]

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

    @enterCommand = new EnterCommand()
    @repeatInnerCommand  = new RepeatInnerCommand()
    @valueCommand = new ValueCommand()

    @.addCommand(@enterCommand)
    @.addCommand(@valueCommand)
    @.addCommand(new AttrCommand())
    @.addCommand(new ReplaceInnerCommand())
    @.dataStop= new StopCommand()

  addCommand: (command) ->
    @commands.push(command)

  extractTemplate: (node) ->
    node.clone()

  extractData: (node, context) ->
    unless context?
      context = {}
    thisContext = context
    extractCommands = [@enterCommand, @valueCommand, @repeatInnerCommand]
    keepGoing = yes
    for command in extractCommands
      if keepGoing and command.appliesTo(node)
        res = command.extractData(node, @, thisContext)
        keepGoing = keepGoing and res[0]
        thisContext = res[1]

    if keepGoing
      for kid in node.children()
        # TODO: need to handle conditionals
        @.extractData($(kid), thisContext)
     
    context

  render: (node, context, bookmarks) ->
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
    if @.dataStop.appliesTo(node)
      # Nothing
    else if @repeatInnerCommand.appliesTo(node)
      contexts = @repeatInnerCommand.applyTo(node, @evaluator, context, bookmarks, @)
    else
      # Travel into children
      toShow = @._handleConditionals(node.children(), context, bookmarks)
      for kid in toShow
        @.render($(kid), context)
 
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

DSS.Engine = new Templator(DSS.Evaluator)
