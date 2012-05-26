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

# A few jQuery extensions to help us snag CSS properties
$.fn = $.fn or {}
$.fn.css2 = $.fn.css
$.fn.css = () ->
  if arguments.length
    return $.fn.css2.apply(this, arguments)
  attrs = [
    'font-family',
    'font-size',
    'font-weight',
    'font-style',
    'color',
    'text-transform',
    'text-decoration',
    'letter-spacing',
    'word-spacing',
    'line-height',
    'text-align',
    'vertical-align',
    'direction',
    'background-color',
    'background-image',
    'background-repeat',
    'background-position',
    'background-attachment',
    'opacity',
#    'width',
#    'height',
    'top',
    'right',
    'bottom',
    'left',
    'margin-top',
    'margin-right',
    'margin-bottom',
    'margin-left',
    'padding-top',
    'padding-right',
    'padding-bottom',
    'padding-left',
    'border-top-width',
    'border-right-width',
    'border-bottom-width',
    'border-left-width',
    'border-top-color',
    'border-right-color',
    'border-bottom-color',
    'border-left-color',
    'border-top-style',
    'border-right-style',
    'border-bottom-style',
    'border-left-style',
    'position',
    'display',
    'visibility',
    'z-index',
    'overflow-x',
    'overflow-y',
    'white-space',
    'clip',
    'float',
    'clear',
    'cursor',
    'list-style-image',
    'list-style-position',
    'list-style-type',
    'marker-offset'];
  obj = {}
  for attr in attrs
    obj[attr] = $.fn.css2.call(this, attr)
  return obj

class DssCopy
  copy: (node, options) ->
    opts = $.extend {}, {'style':true}, options
    
    # Determine the right HTML to copy -- with or without style
    ret = null
    if opts.style
      ret = @.hashToHtml(@.grabStyle(node))
    else
      ret = node.clone().wrap('<div></div>').parent().html()
     
    # Perform the copy
    @.doCopyString(ret)

    # Also return the HTML
    ret

  # The copy right now is implemented just for demo purposes
  # TODO: Figure out how to stand up something that would work for others
  doCopyString: (str) ->
    copyPasteServer = "http://localhost:4567"
    $.post(copyPasteServer + "/copy", {'data':str})

  cssForNode: (node) ->
    return node.css()
    # xxx should node be a? 
    sheets = document.styleSheets
    o = {}
    for i in sheets
      rules = i.rules || i.cssRules
      for r in rules
        if node.is(r.selectorText)
          o = $.extend(o, @.css2json(r.style), @.css2json(node.attr('style')))
    return o

  css2json: (css) ->
    s = {}
    if not css 
      return s
    if css instanceof CSSStyleDeclaration
      for i in css
        if css[i].toLowerCase 
          s[i.toLowerCase()] = css[i]
    else if typeof css == "string"
      css = css.split("; ")
      for i in css
        l = css[i].split(": ")
        s[l[0].toLowerCase()] = (l[1])
    s

  descForNode: (node) ->
    desc = {}
    if (node[0].tagName?)
      desc["type"] = "node"
      desc["tagName"] = node[0].tagName
      desc["attrs"] = {}
      for i in node[0].attributes
        desc.attrs[i.nodeName] = i.nodeValue
    else if node[0].nodeName == "#text"
      desc["type"] = "text"
      desc["value"] = node[0].textContent
    else if node[0].nodeName == "#comment"
      desc["type"] = "comment"
      desc["value"] = node[0].textContent
    desc 

  buildStyles: (node) ->
    styles = @.cssForNode(node) #window.getComputedStyle(node[0])
    html = @.copy(node, {'style':no})
    copy = $(html)
    console.log window.getComputedStyle(copy[0])

  grabStyle: (node) ->
    hash = @.buildHash(node)
    @.bubbleUp(hash)
    hash

  buildHash: (node, parent) ->
    # grab styles
    definition = @.descForNode(node)
    hash = {html:definition}
    if definition.type == "node"
      hash["styles"] = @.cssForNode(node)
      hash["children"] = []
      for child in node.contents()
        hash.children.push(@.buildHash($(child), hash))
    hash

  hashToHtml: (hash) =>
    str = ""
    if hash.html.type == "node"
      str = "<" + hash.html.tagName + " "
      for k,v of hash.html.attrs
        str += k + "=\"" + v + "\" "
      str += "style=\""
      for k,v of hash.styles
        str += k + ":" + v + ";"
      str += "\""
      str += ">"
      for kid in hash.children
        str += @.hashToHtml(kid)
      str += "</" + hash.html.tagName + ">"
    else if hash.html.type == "text"
      str = hash.html.value
    else if hash.html.type == "comment"
      str = "<!-- " + hash.html.value + " -->"
    str

  # node is a hash
  # {
  #   children: [nodes]
  #   styles: {css-prop:css-val}
  #   parent: parent-pointer or null
  #   html: node definition
  # }
  bubbleUp: (node) ->
   # Bubble from the leaves up to the root
   if node.children?
     for child in node.children
       @.bubbleUp(child)

   # Delete all CSS properties that our parent has
   if node.parent?
     for cssProp,cssVal of node.styles
       if node.parent.styles[cssProp]? and node.parent.styles[cssProp] == cssVal
         delete node.styles[cssProp]

DSS.Copy = new DssCopy()
