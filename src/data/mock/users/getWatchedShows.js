
define(['data/mock/shows/allShows'], function(allShows) {
  var id, k, result, s, v, _, _results;
  _ = function(o) {
    return o;
  };
  _results = [];
  for (id in allShows) {
    s = allShows[id];
    result = {
      id: id
    };
    for (k in s) {
      v = s[k];
      result[k] = v;
    }
    _results.push(result);
  }
  return _results;
});
