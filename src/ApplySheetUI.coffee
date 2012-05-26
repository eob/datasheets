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

class ApplyStylesheetUI
  constructor: () ->
    @anchor = $("""<div id="applySheetAnchor" style="margin:0; z-index:1000; position:absolute; top:139px; left:5px; height: 5px; width: 5px;"></div>""")
    $("body").append(@anchor)
    @ui = """
      <div style="padding: 5px; width:340px">
        <input style="width: 225px" id="applyDssUrl" style="border: 2px solid #555;" value="http://localhost:8000/demo/dss/" />
        <p align="center" style="marign-bottom:0">
        <button class="btn btn-primary applyDssBtn">Apply</button>&nbsp;<button class="btn applyDssCancelBtn">Cancel</button></p>
      </div>
    """
  show: () =>
    # Display the paste options
    
    DSS.Callout.callout(@anchor, "Apply Datasheet", @ui)

    $(".applyDssCancelBtn").click (event) =>
      event.preventDefault()
      DSS.Callout.close(@anchor)

    $(".applyDssBtn").click (event) =>
      event.preventDefault()
      dss = $("#applyDssUrl").val()
      console.log("Got URL for application: " + dss)
      DSS.ApplySheet.applyUrl(dss)
      DSS.Callout.close(@anchor)

DSS.ApplySheetUI = new ApplyStylesheetUI()
