var exec = require('cordova/exec');

// initializer
function KeyboardListener() {

}

KeyboardListener.prototype.register = function() {
  exec(
    function(key) {
      if(key !== "") {
        var e = new CustomEvent('bt-keyboard', { detail: { 'keycode': key }} );
        document.dispatchEvent(e);
      }      
    },

    function() {
      console.log('boo');
    },

    'KeyboardListener', 'cordovaRegister', []
  );
}

module.exports = new KeyboardListener();