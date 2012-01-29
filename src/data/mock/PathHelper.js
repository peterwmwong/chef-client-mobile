
define(function() {
  var PathHelper;
  return PathHelper = {
    getPathComponent: function(path, i) {
      var s;
      return (s = PathHelper.getPathComponents(path))[(function() {
        if (i != null) {
          return i;
        } else {
          return s.length - 1;
        }
      })()];
    },
    getPathComponents: function(path) {
      return path.split('/');
    }
  };
});
