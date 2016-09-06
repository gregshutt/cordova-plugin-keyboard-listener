var exec = require('cordova/exec');

var KeyboardListener = { 
  register: function() {
    exec(
      function(key) {
        if(key !== "") {
          // dispatch a custom keyboard listener event
          var e = new CustomEvent('keyboard-listener-keypress', { detail: { 'keycode': key }} );
          document.dispatchEvent(e);

          // also simulate a keypress, since the ios plugin eats up the keys
          // yanked from http://stackoverflow.com/questions/596481/simulate-javascript-key-events
          e = document.createEvent("KeyboardEvent");
          var initMethod = typeof keyboardEvent.initKeyboardEvent !== 'undefined' ? "initKeyboardEvent" : "initKeyEvent";
          e[initMethod](
                   "keydown", // event type : keydown, keyup, keypress
                    true, // bubbles
                    true, // cancelable
                    window, // viewArg: should be window
                    false, // ctrlKeyArg
                    false, // altKeyArg
                    false, // shiftKeyArg
                    false, // metaKeyArg
                    key, // keyCodeArg : unsigned long the virtual key code, else 0
                    0 // charCodeArgs : unsigned long the Unicode character associated with the depressed key, else 0
          );
          document.dispatchEvent(e);
        }
      },

      function() {
        // TODO
      },

      'KeyboardListener', 'cordovaRegister', []
    );
  }
};

module.exports = KeyboardListener;
