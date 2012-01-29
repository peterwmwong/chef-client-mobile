
define({
  set: function(hash) {
    return window.location.hash = hash;
  },
  get: function() {
    return window.location.hash;
  },
  onChange: function(cb) {
    return $(window).on('hashchange', cb);
  }
});
