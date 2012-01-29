
define(['data/JSONP'], function(_arg) {
  var JSONPService;
  JSONPService = _arg.JSONPService;
  return new JSONPService('actors', {
    baseURL: 'api/actors/',
    methods: {
      getDetails: function(sid) {
        return "" + sid;
      }
    }
  });
});
