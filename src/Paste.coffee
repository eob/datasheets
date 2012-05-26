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

class DssPaste
  # Options are
  # *  location: One of 'before', 'after', 'prepend', 'append', 'replace'
  # *  style: true
  # *  data: true
  paste: (anchor, options) =>
    @.fetchPasteContent (html) =>
      opts = $.extend {}, {'location':'prepend', 'style':true, 'data':true}, options
      node = $(html)

      replacementNode = $()
      if opts.data and opts.style
        replacementNode = node
      else if opts.data and not opts.style
        data = DSS.Engine.extractData(node)
        console.log("Pasted data:")
        console.log(data)
        template = DSS.Engine.extractTemplate(anchor)
        replacementNode = DSS.Engine.render(template, [data])
        replacementNode = template
      else if opts.style and not opts.data
        data = DSS.Engine.extractData(anchor)
        console.log("Pasted data:")
        console.log(data)
        template = DSS.Engine.extractTemplate(node)
        DSS.Engine.render(template, [data])
        replacementNode = template
 
      @.pasteNode(anchor, replacementNode, opts.location)

  fetchPasteContent: (callback) =>
    pasteServer = "http://localhost:4567"
    $.getJSON(pasteServer + "/paste?callback=?", callback)

  # Helper function to inject a node into the DOM based on an offet
  # to some anchor node.
  pasteNode: (anchor, node, location) ->
    switch location
      when "replace"
        anchor.replaceWith(node)
        break
      when "prepend"
        anchor.prepend(node)
        break
      when "append"
        anchor.append(node)
        break
      when "before"
        anchor.before(node)
        break
      when "after"
        anchor.after(node)
        break
      else
        console.log("Error: did not understand location: " + location)

DSS.Paste = new DssPaste()
