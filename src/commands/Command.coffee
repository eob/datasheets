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
module = (name, parent) ->
  parent = window || parent

# Ensure the DSS namespace
module 'HCSS'
module 'Command',HCSS

$ = HCSS.jQuery

class HCSS.Command.Command

  # Does thie command reply to the node?
  #### Returns
  # *Boolean*
  appliesTo: (node, context) ->
    false

  # Execute this command
  #### Side Effects
  # node and context potentially modified
  #### Returns 
  # *Boolean*: whether engine should recurse into children of node
  # Note that this command can do its own recursion (for example, 
  # loops or conditionals) in which case the return value should be false.
  applyTo: (node, context, args, engine) ->
    false

  # Recovers data
  #### Side Effects
  #
  recoverData: (node, context) ->

  # Recovers template
  recoverTemplate: (node, context) ->
  
