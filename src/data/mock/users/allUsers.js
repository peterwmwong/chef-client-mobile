
define(['data/mock/shows/allShows'], function(shows) {
  var s;
  return {
    gqiu: {
      name: "Grace Qiu",
      shows: (function() {
        var _i, _len, _ref, _results;
        _ref = Object.keys(shows).slice(0, 6);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
          _results.push(shows[s]);
        }
        return _results;
      })()
    },
    pwong: {
      name: "Peter Wong",
      shows: (function() {
        var _i, _len, _ref, _results;
        _ref = Object.keys(shows).slice(5);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          s = _ref[_i];
          _results.push(shows[s]);
        }
        return _results;
      })()
    }
  };
});
