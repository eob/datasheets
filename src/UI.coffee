class KixUI
  ToTextbox: (elem) ->
    Aloha.ready(() ->
      Aloha.jQuery(elem[0]).aloha()
    )
    #html = elem.wrap("<div></div>").parent().html()
    #textbox = $("<textarea id='EDITING' style='width:100%' rows=28></textarea>")
    #textbox.val(html)
    #elem.replaceWith(textbox)

  FromTextbox: (elem) ->
    html = elem.val()
    console.log(html)
    elem.replaceWith($(html))

  LoadData: () ->
    $.getJSON($("#kixLoadData").val(), (data) ->
      window.Templator.evaluate($("html"), [data])
    )

  LoadAloha: () ->
	  # Stuff 
    $("head").append("<link rel=\"stylesheet\" href=\"/demo/aloha/css/aloha.css\" id=\"aloha-style-include\" type=\"text/css\">")
    setup = document.createElement("script")
    setup.type  = "text/javascript"
    setup.src   = "/demo/aloha-setup.js"
    document.head.appendChild(setup)
    alo = document.createElement("script")
    alo.type  = "text/javascript"
    alo.src   = "/demo/aloha/lib/aloha.js"
    alo.setAttribute("data-aloha-plugins", "common/format, common/table, common/list, common/link, common/highlighteditables, common/block, common/undo, common/contenthandler, common/paste, common/characterpicker, common/commands, extra/flag-icons, common/abbr, extra/wai-lang, extra/browser, extra/linkbrowser")
    document.head.appendChild(alo)

  Annotate: () ->
    $(".kixRepeatContainer").css("border", "2px dashed black")
    $(".kixRepeatedNode").css("border", "1px solid red")
    $(".kixValueNode").css("background-color", "#FCF6CF")
    $(".kixValueNode").css("color", "#000")

  Redact: () ->
    $(".kixValueNode").css("background-color", "#222")
    $(".kixValueNode").css("color", "#222")


  CreateSidebar: () ->
    $("head").append("<link rel=\"stylesheet\" href=\"/demo/kix.css\" type=\"text/css\" />")
    html = """
    <div id="KixSidebar">
      <a href="#" id="KixButton">Kix</a>
      <div id="KixMenu">
        <h3>Data</h3>
        <table>
         <tr>
           <td>JSON:</td>
           <td align="right"><input type="text" id="kixLoadData" /></td>
         </tr>
         <tr><td></td>
          <td align="right"><input type="submit" id="kixLoadDataBtn" value="Load Data" /></td>
        </tr>
        </table>
        <h3>Template</h3>
        <input type="submit" id="kixShowFields" value="Highlight Template">
      </div>
    </div>
    """
    $("body").append(html)

    $("#kixLoadDataBtn").click(() =>
      @.LoadData()
    )

    $("#kixShowFields").click(() =>
      @.Annotate()
    )
    
    $("#KixButton").click(() ->
      container = $("#KixSidebar")
      if (container.css("left") == "-200px")
        container.css("left", "0px")
      else 
        container.css("left", "-200px")
    ) 

window.KixUI = new KixUI()
$(() -> 
  window.KixUI.CreateSidebar()
  window.KixUI.LoadAloha()
)
