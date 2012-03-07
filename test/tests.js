$(document).ready(function(){
 
  var getHtml = function(node) {
    return $(node).clone().wrap('<div></div>').parent().html();
  }

  module("Template -> Pass Through");
  
  test("Pass-through for nontemplated HTML", function() {
    var html = $("<div data-foo=\"bar\"><span class=\"baz\">splat</span></div>");
    var template = window.Templator.RecoverTemplate(html);
    equal(getHtml(template), getHtml(html),
           "Template wasn't html");
  });

  module("Template -> Rendering and Recovery");
 
  test("data-enter", function() {
    var html = $("<div data-enter=\"foo\"><span data-content=\"baz\">splat</span></div>");
    var expected = $("<div data-enter=\"foo\"><span data-content=\"baz\">BAZ</span></div>");
    var templateExpected = $("<div data-enter=\"foo\"><span data-content=\"baz\">BAZ</span></div>");
    var data = {'foo':{'baz':'BAZ'}}; 
    window.Templator.enterNode(html, [data]);  
    var recovered = window.Templator.RecoverTemplate(html);
    equal(getHtml(html), getHtml(expected),
           "Template wasn't html");
    equal(getHtml(recovered), getHtml(templateExpected));
  });

  test("data-content", function() {
    var html = $("<div data-content=\"foo\"><span class=\"baz\">splat</span></div>");
   
    var expected = $("<div data-content=\"foo\">FOO</div>");
    var data = {'foo':'FOO'}; 
    var got = window.Templator.enterNode(html, [data]);  
    equal(getHtml(html), getHtml(expected),
           "Template wasn't html");
  });

  test("data-repeat", function() {
    var html = $("<ul><li data-repeat=\"names\" data-content=\".\">splat</li></ul>");
    var expected = $("<ul><li data-repeat=\"names\" data-content=\".\">Ted</li><li data-repeat=\"names\" data-content=\".\">Grace</li></ul>");
    var recoveredExpect = $("<ul><li data-repeat=\"names\" data-content=\".\">Ted</li></ul>");
    
    var data = {'names':['Ted', 'Grace']}; 
    window.Templator.enterNode(html, [data]);  
    equal(getHtml(html), getHtml(expected),
           "Template wasn't html");
    var recovered = window.Templator.RecoverTemplate(html)
    equal(getHtml(recovered), getHtml(recoveredExpect));
  });


  test("data-repeatInner", function() {
    var html = $("<ul data-repeatInner=\"names\"><li data-content=\".\">splat</li></ul>");
   
    var expected = $("<ul data-repeatInner=\"names\"><li data-content=\".\">Ted</li><li data-content=\".\">Grace</li></ul>");
    var recoveredExpect = $("<ul data-repeatInner=\"names\"><li data-content=\".\">Ted</li></ul>");
    
    var data = {'names':['Ted', 'Grace']}; 
    window.Templator.enterNode(html, [data]);  
    equal(getHtml(html), getHtml(expected),
           "Template wasn't html");
    var recovered = window.Templator.RecoverTemplate(html)
    equal(getHtml(recovered), getHtml(recoveredExpect));
  });

  module("Template -> Recovery");
 
  var testRecovery = function(template, data, expected) {
    var orig = window.Templator.RecoverTemplate(template);
    window.Templator.enterNode(template, [data]);
    var results = window.Templator.RecoverTemplate(template);
    equal(getHtml(orig), getHtml(results), "Recovery failed");
  }

  test("data-content recovery", function() {
    var html = $("<div data-content=\"foo\"><span class=\"baz\">splat</span></div>");
   
    var expected = $("<div data-content=\"foo\">FOO</div>");
    var data = {'foo':'FOO'}; 
    var got = window.Templator.enterNode(html, [data]);  
    equal(getHtml(html), getHtml(expected),
           "Template wasn't html");
  });




});
