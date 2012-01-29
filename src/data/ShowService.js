
define(['data/JSONP'], function(_arg) {
  var JSONPService;
  JSONPService = _arg.JSONPService;
  return new JSONPService('shows', {
    baseURL: 'api/shows/',
    methods: {
      getDetails: function(sid) {
        return "" + sid;
      }
    }
  });
});
