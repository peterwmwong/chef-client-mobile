
define(function() {
  var i, offsetDayMap, today;
  today = new Date();
  offsetDayMap = ['Today', 'Yesterday'].concat((function() {
    var _results;
    _results = [];
    for (i = 2; i < 7; i++) {
      _results.push("" + i + " days ago");
    }
    return _results;
  })(), "a week ago");
  return {
    getDisplayable: function(o) {
      if (today.getYear() === o.getYear() && today.getMonth() === o.getMonth()) {
        return offsetDayMap[today.getDate() - o.getDate()];
      } else {
        return o.toLocaleDateString();
      }
    }
  };
});
