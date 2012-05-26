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

class DssPasteUI
  constructor: () ->
    @target = null
    @ui = """
      <div>
        <p align="center" style="font-size: 1.3em">
          <input type="checkbox" checked id="pasteData" />Data &nbsp 
        <input type="checkbox" checked id="pasteStyle" />Style</p><br />
        <div style="padding-left: 40px; float: left; margin-right: 5px;">
        <img src="http://localhost:8000/demo/where.png" />
        </div>
        <div style="margin-left: 5px">
          <div style="margin-top:9px">
            <input type="radio" style="margin-right: 3px" data-location="before" id="pasteBefore" name="pasteWhere" />Before
          </div>
          <div style="margin-top:18px">
            <input type="radio" style="margin-right: 3px" data-location="prepend" id="pastePrepend" name="pasteWhere" />Prepend<br />
          </div>
          <div style="margin-top:-1px">
            <input type="radio" tyle="margin-right: 3px" data-location="replace" id="pasteReplace" name="pasteWhere" />Replace<br />
          </div>
          <div style="margin-top:0px">
            <input type="radio" style="margin-right: 3px" data-location="append" id="pasteAppend" name="pasteWhere" />Append<br />
          </div>
          <div style="margin-top:13px">
            <input type="radio" style="margin-right: 3px" data-location="after" id="pasteAfter" name="pasteWhere" />After
          </div>
        </div>
        <br />
        <p align="center">
        <button class="btn btn-primary pasterBtn">Paste</button>&nbsp<button class="btn pasteCancelBtn">Cancel</button></p>
      </div>
    """

  # Triggers the Element Picker, witha callback to the the Paste UI
  # once an element has been picked
  paste: () =>
    @target = null
    window.DSS.ElementPicker.pick(@.targetSelected, {'autoClear':no})

  targetSelected: (target) =>
    @target = target
    # Display the paste options
    DSS.Callout.callout(target, "Paste", @ui)

    $(".pasteCancelBtn").click (event) =>
      event.preventDefault()
      DSS.ElementPicker.clearSelection()
      DSS.Callout.close(@target)

    $(".pasterBtn").click (event) =>
      # Once they have selected the paste options, clear selection
      # an call the low-level DSS Paste library with their choice
      event.preventDefault()
      DSS.ElementPicker.clearSelection()
      data = $("#pasteData").is(":checked")
      style = $("#pasteStyle").is(":checked") 
      loc = $("input:radio[name=pasteWhere]:checked").data("location") 
      opts = {'location':loc, 'style':style, 'data':data}
      DSS.Callout.close(@target)
      DSS.Paste.paste(@target, opts)
      @target = null

DSS.PasteUI = new DssPasteUI()
