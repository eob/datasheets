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

class ApplySheet
  applyParsed: (parsed) =>
    #console.log(parsed)
    #console.log("Applying parsed")
    for rule,props of parsed
      #console.log("Applying Rule: " + rule)
      elems = $(rule)
      #console.log(elems)
      for elem in $(rule)
        for key,val of props
          key = "data-" + key
          #console.log("Applying " + key + ": " + val + " to element ")
          $(elem).attr(key,val)
          #console.log(elem)

  applyString: (str) =>
    console.log("Applying string: " + str)
    parsed = @.parseString(str)
    @.applyParsed(parsed)

  applyUrl: (url) =>
    console.log("Applying URL: " + url)
    pasteServer = "http://localhost:4567/parrot?callback=?"
    params = {'url':url}
    $.getJSON(pasteServer, params, @.applyString)

  parseString: (str) =>
    rules = {}
    str = @.removeComments(str)
    blocks = str.split('}')
    blocks.pop()
    for block in blocks
      pair = block.split('{')
      rules[$.trim(pair[0])] = @.parseCSSBlock(pair[1])
    return rules

  removeComments: (str) =>
    return str.replace(/\/\*(\r|\n|.)*\*\//g,"")

  parseCSSBlock: (str) =>
    rule = {}
    declarations = str.split(';')
    declarations.pop()
    for d in declarations
      loc = d.indexOf(':')
      property = $.trim(d.substring(0, loc))
      value = $.trim(d.substring(loc + 1))
      if property != "" and value != ""
        rule[property] = value
    return rule

DSS.ApplySheet = new ApplySheet()
