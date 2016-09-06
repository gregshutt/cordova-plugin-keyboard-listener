var exec = require('cordova/exec');

var KeyboardListener = { 
  register: function() {
    exec(
      function(key) {
        if(key !== "") {
          // dispatch a custom keyboard listener event
          var e = new CustomEvent('keyboard-listener-keypress', { detail: { 'keycode': key }} );
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
