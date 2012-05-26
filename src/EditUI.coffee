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

class EditUI
  constructor: () ->
    @.loadAloha()
    @AlohaRequire = ['aloha', 'aloha/jquery', 'aloha/floatingmenu', 'common/link']

  editData: () =>
    $.each($(".kixValueNode"), (idx, elem) =>
      elem = Aloha.jQuery(elem)
      if elem.offset?
        alohaFunc = (Aloha, $, FloatingMenu) ->
          $(elem).aloha()
        Aloha.require(@AlohaRequire, alohaFunc)
    )

  stopEditingData: () =>
    $.each($(".kixValueNode"), (idx, elem) =>
      elem = Aloha.jQuery(elem)
      if elem.offset?
        Aloha.jQuery(elem).mahalo()
    )

  editTemplate: () ->
    $.each($(".kixValueNode"), (idx, elem) =>
      elem = $(elem)
      if elem.offset?
        Aloha.jQuery(elem).alohaBlock()
    )
    Aloha.jQuery(".segment").aloha()
  
  stopEditingTemplate: () ->
    $.each($(".kixValueNode"), (idx, elem) =>
      elem = Aloha.jQuery(elem)
      if elem.offset? and elem.mahaloBlock?
        elem.mahaloBlock()
    )
    Aloha.jQuery(".segment").mahalo()

  loadAloha: () ->
	  # Stuff 
    config= document.createElement("script")
    config.type  = "text/javascript"
    config.src   = "http://localhost:8000/demo/aloha-setup.js"
    document.head.appendChild(config)

DSS.EditUI = new EditUI()
