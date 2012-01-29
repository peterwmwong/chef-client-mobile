
define(['require', 'Services', 'shared/DateHelper', 'cell!shared/ListView'], function(require, S, DateHelper, ListView) {
  var ShowDetailsPage;
  ShowDetailsPage = 'pages/showdetails/ShowDetails';
  return {
    init: function() {
      var _this = this;
      return this.model.bind({
        'activate': function() {
          _this.model.set({
            title: DateHelper.getDisplayable(new Date())
          });
          return _this.$('#ShowList').trigger('resetActive');
        }
      });
    },
    render: function(_) {
      var _this = this;
      return S.user.getShows(new Date(), function(shows) {
        var s;
        _this.$el.append(_(ListView, {
          id: 'ShowList',
          list: (function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = shows.length; _i < _len; _i++) {
              s = shows[_i];
              _results.push({
                link: this.pageURI(ShowDetailsPage, {
                  id: s.id,
                  title: s.title
                }),
                text: s.title
              });
            }
            return _results;
          }).call(_this)
        }));
        _this.model.trigger('refreshScroller');
        return require([ShowDetailsPage], function() {});
      });
    }
  };
});
