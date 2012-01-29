
define(function() {
  var getPathComponent;
  return getPathComponent = function(path, i) {
    var s;
    return (s = path.split('/'))[(function() {
      if (i != null) {
        return i;
      } else {
        return s.length - 1;
      }
    })()];
  };
});
