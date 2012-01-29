
define(['data/JSONP'], function(_arg) {
  var JSONPService, userid;
  JSONPService = _arg.JSONPService;
  userid = 'pwong';
  return new JSONPService('users', {
    baseURL: 'api/users/',
    methods: {
      getWatchedShows: function() {
        return "" + userid + "/watched-shows";
      },
      getShows: function(date) {
        return "" + userid + "/schedule/" + (date.getYear() + 1900) + "-" + (date.getMonth()) + "-" + (date.getDate());
      }
    }
  });
});
