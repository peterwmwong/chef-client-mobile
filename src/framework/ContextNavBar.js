
define(['AppConfig', './Nav'], function(AppConfig, Nav) {
  return {
    tag: '<ul>',
    render: function(_) {
      var ctxid, text;
      return [
        (function() {
          var _ref, _results;
          _ref = AppConfig.contexts;
          _results = [];
          for (ctxid in _ref) {
            text = _ref[ctxid].text;
            _results.push(_("<li data-ctxid='" + ctxid + "'>", text || ctxid));
          }
          return _results;
        })()
      ];
    },
    on: {
      'click li': function(_arg) {
        var target;
        target = _arg.target;
        $('li.active').removeClass('active');
        return Nav.switchContext($(target).addClass('active').data('ctxid'));
      }
    }
  };
});
