( function ( window, undefined ) {
  
  if (window.Aloha === undefined || window.Aloha === null) {
    var Aloha = window.Aloha = {};
  }
	
	Aloha.settings = {
		logLevels: { 'error': true, 'warn': true, 'info': true, 'debug': false, 'deprecated': true },
		errorhandling: false,
		ribbon: false,
		locale: 'en',
		floatingmenu: {
			"horizontalOffset" : "5",
			"behaviour" : "topalign",
			"width" : "510",
			"topalignOffset" : "110" 
		},
		plugins: {
			format: {
				// all elements with no specific configuration get this configuration
				config: [  'b', 'i', 'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'pre', 'removeFormat' ],
				editables: {
				}
			},
			list: {
				// all elements with no specific configuration get an UL, just for fun :)
				config: [ 'ul', 'ol' ],
				editables: {
				}
			},
			link: {
				// all elements with no specific configuration may insert links
				config: [ 'a' ],
				editables: {
				}
			}
		}
	};
  
  css = document.createElement("link")
  css.type = "text/css"
  css.rel = "stylesheet"
//  css.href = "http://cdn.aloha-editor.org/current/css/aloha.css"
  css.href = "http://localhost:8000/demo/aloha/css/aloha.css"
  document.head.appendChild(css)

  setup = document.createElement("script")
  setup.type  = "text/javascript"
//  setup.src   = "http://cdn.aloha-editor.org/current/lib/aloha.js"
  setup.src = "http://localhost:8000/demo/aloha/lib/aloha.js"
  setup.setAttribute("data-aloha-plugins", "common/format,common/link")
  document.head.appendChild(setup)
 
} )( window );

