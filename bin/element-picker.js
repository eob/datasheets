(function() {
  var $, ElementPicker, module;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQueryDss;
  module = function(name) {
    return window[name] = window[name] || {};
  };
  module('DSS');
  ElementPicker = (function() {
    function ElementPicker(options) {
      this.keyDown = __bind(this.keyDown, this);
      this.mouseUp = __bind(this.mouseUp, this);
      this.mouseMove = __bind(this.mouseMove, this);
      this.hitSelection = __bind(this.hitSelection, this);
      this.pick = __bind(this.pick, this);      this.opts = $.extend({}, {
        'autoClear': true
      }, options);
      this.highlightedClass = 'elementPickerSelected';
      this.prevKey = 37;
      this.nextKey = 39;
      this.childKey = 40;
      this.parentKey = 38;
      this.selectKey = 13;
      this.quitKey = 27;
      this.state = 'OFF';
      this.copyPasteServer = "http://localhost:4567";
      this.shouldPaste = false;
      this.border = $('<div id=\'floatingBorder\' class=\'floatingBorder\' />');
      this.border.css({
        display: 'none',
        position: 'absolute',
        zIndex: 65000,
        background: 'rgba(255,0,0,0.3)'
      });
      this.pasterElem = null;
      this.border.hide();
      this.selected = $();
      this.last = new Date;
      $('html').append(this.border);
    }
    ElementPicker.prototype.pick = function(callback, options) {
      this.opts = $.extend({}, {
        'autoClear': true
      }, options);
      if (this.state === 'OFF') {
        this.state = 'ON';
        this.callback = callback;
        this.select($('body'));
        $('html').keydown(this.keyDown).keyup(this.keyUp);
        $('html').mousemove(this.mouseMove);
        return $('html').mouseup(this.mouseUp);
      } else {
        return console.log("Picker error: tried to pick but picker is already active");
      }
    };
    ElementPicker.prototype.disablePicker = function() {
      if (this.state === 'ON') {
        this.state = 'OFF';
        return this.clearSelection();
      }
    };
    ElementPicker.prototype.keyUp = function(event) {
      return $('html').data('pressed', false);
    };
    ElementPicker.prototype.clearSelection = function() {
      this.border.hide();
      return this.selected = $();
    };
    ElementPicker.prototype.select = function(element) {
      var offset;
      this.clearSelection();
      offset = element.offset();
      this.border.css({
        width: element.outerWidth() - 1,
        height: element.outerHeight() - 1,
        left: offset.left,
        top: offset.top
      });
      this.border.show();
      return this.selected = element;
    };
    ElementPicker.prototype.getSelection = function() {
      return this.selected;
    };
    ElementPicker.prototype.hitSelection = function(node) {
      if (this.opts.autoClear) {
        this.clearSelection();
      }
      return this.callback(node);
    };
    ElementPicker.prototype.mouseMove = function(event) {
      var el, now;
      if (this.state === "OFF") {
        return;
      }
      el = event.target;
      now = new Date;
      if (now - this.last < 25) {
        return;
      }
      this.last = now;
      if (el === document.body) {
        this.clearSelection();
      } else if (el.id === 'floatingBorder') {
        this.border.hide();
        el = document.elementFromPoint(event.clientX, event.clientY);
      }
      el = $(el);
      return this.select(el);
    };
    ElementPicker.prototype.mouseUp = function(event) {
      var n;
      if (this.state === "OFF") {
        return;
      }
      this.state = "OFF";
      n = this.getSelection();
      this.hitSelection(n);
      return event.preventDefault();
    };
    ElementPicker.prototype.keyDown = function(event) {
      var data, n;
      if (this.state === "OFF") {
        return;
      }
      data = $('html').data();
      if (!data['pressed']) {
        data['pressed'] = true;
        switch (event.which) {
          case this.selectKey:
            this.state = "OFF";
            n = this.getSelection();
            this.clearSelection();
            this.hitSelection(n);
            event.preventDefault();
            break;
          case this.nextKey:
            n = this.getSelection().next();
            if (n.length > 0) {
              this.select(n);
            }
            event.preventDefault();
            break;
          case this.prevKey:
            n = this.getSelection().prev();
            if (n.length > 0) {
              this.select(n);
            }
            event.preventDefault();
            break;
          case this.childKey:
            n = this.getSelection().children();
            if (n.length > 0) {
              this.select($(n[0]));
            }
            event.preventDefault();
            break;
          case this.parentKey:
            n = this.getSelection().parent();
            if (n.length > 0) {
              this.select(n);
            }
            event.preventDefault();
            break;
          case this.quitKey:
            this.disablePicker();
            return event.preventDefault();
        }
      }
    };
    return ElementPicker;
  })();
  DSS.ElementPicker = new ElementPicker();
}).call(this);
