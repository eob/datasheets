(function() {
  var KixUI;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  KixUI = (function() {
    function KixUI() {}
    KixUI.prototype.ToTextbox = function(elem) {
      return Aloha.ready(function() {
        return Aloha.jQuery(elem[0]).aloha();
      });
    };
    KixUI.prototype.FromTextbox = function(elem) {
      var html;
      html = elem.val();
      console.log(html);
      return elem.replaceWith($(html));
    };
    KixUI.prototype.LoadData = function() {
      return $.getJSON($("#kixLoadData").val(), function(data) {
        return window.Templator.evaluate($("html"), [data]);
      });
    };
    KixUI.prototype.LoadAloha = function() {
      var alo, setup;
      $("head").append("<link rel=\"stylesheet\" href=\"/demo/aloha/css/aloha.css\" id=\"aloha-style-include\" type=\"text/css\">");
      setup = document.createElement("script");
      setup.type = "text/javascript";
      setup.src = "/demo/aloha-setup.js";
      document.head.appendChild(setup);
      alo = document.createElement("script");
      alo.type = "text/javascript";
      alo.src = "/demo/aloha/lib/aloha.js";
      alo.setAttribute("data-aloha-plugins", "common/format, common/table, common/list, common/link, common/highlighteditables, common/block, common/undo, common/contenthandler, common/paste, common/characterpicker, common/commands, extra/flag-icons, common/abbr, extra/wai-lang, extra/browser, extra/linkbrowser");
      return document.head.appendChild(alo);
    };
    KixUI.prototype.Annotate = function() {
      $(".kixRepeatContainer").css("border", "2px dashed black");
      $(".kixRepeatedNode").css("border", "1px solid red");
      $(".kixValueNode").css("background-color", "#FCF6CF");
      return $(".kixValueNode").css("color", "#000");
    };
    KixUI.prototype.Redact = function() {
      $(".kixValueNode").css("background-color", "#222");
      return $(".kixValueNode").css("color", "#222");
    };
    KixUI.prototype.CreateSidebar = function() {
      var html;
      $("head").append("<link rel=\"stylesheet\" href=\"/demo/kix.css\" type=\"text/css\" />");
      html = "<div id=\"KixSidebar\">\n  <a href=\"#\" id=\"KixButton\">Kix</a>\n  <div id=\"KixMenu\">\n    <h3>Data</h3>\n    <table>\n     <tr>\n       <td>JSON:</td>\n       <td align=\"right\"><input type=\"text\" id=\"kixLoadData\" /></td>\n     </tr>\n     <tr><td></td>\n      <td align=\"right\"><input type=\"submit\" id=\"kixLoadDataBtn\" value=\"Load Data\" /></td>\n    </tr>\n    </table>\n    <h3>Template</h3>\n    <input type=\"submit\" id=\"kixShowFields\" value=\"Highlight Template\">\n  </div>\n</div>";
      $("body").append(html);
      $("#kixLoadDataBtn").click(__bind(function() {
        return this.LoadData();
      }, this));
      $("#kixShowFields").click(__bind(function() {
        return this.Annotate();
      }, this));
      return $("#KixButton").click(function() {
        var container;
        container = $("#KixSidebar");
        if (container.css("left") === "-200px") {
          return container.css("left", "0px");
        } else {
          return container.css("left", "-200px");
        }
      });
    };
    return KixUI;
  })();
  window.KixUI = new KixUI();
  $(function() {
    window.KixUI.CreateSidebar();
    return window.KixUI.LoadAloha();
  });
}).call(this);
