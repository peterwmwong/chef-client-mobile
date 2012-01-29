
define(['Services', 'shared/DateHelper', 'cell!shared/ListView', 'framework/Nav'], function(S, DateHelper, ListView, Nav) {
  return {
    init: function() {
      var _this = this;
      this.model.set({
        title: 'Watch'
      });
      return this.model.bind({
        'activate': function() {
          return _this.$('#ShowList').trigger('resetActive');
        }
      });
    },
    render: function(_) {
      var _this = this;
      return S.user.getShows(new Date(), function(shows) {
        var i;
        _this.$el.append(_(ListView, {
          id: 'ShowList',
          list: (function() {
            var _results;
            _results = [];
            for (i = 0; i <= 10; i++) {
              _results.push({
                link: this.pageURI('pages/showdetails/ShowDetails', {
                  id: i
                }),
                text: "" + i
              });
            }
            return _results;
          }).call(_this)
        }));
        return _this.model.trigger('refreshScroller');
      });
    }
  };
});
