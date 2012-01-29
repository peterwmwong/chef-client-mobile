
define(['Services', 'cell!shared/ListView', 'framework/Nav'], function(S, ListView, Nav) {
  return {
    render: function(_) {
      return [_('img'), _('.titleGroup', _('h2.title'), _('h4.year'), _('h4.network')), _('p.description'), _('.castGroup', _('h4.castHeader', 'Cast'), _('#castListContainer', ''))];
    },
    afterRender: function() {
      var _this = this;
      this.model.bind({
        'activate': function() {
          return _this.$('#castListView').trigger('resetActive');
        }
      });
      return this.model.bindAndCall({
        'change:data': function(_arg) {
          var data;
          data = _arg.cur;
          _this.model.set({
            title: 'Loading...'
          });
          return S.show.getDetails(data.id, function(d) {
            var id, name;
            _this.model.set({
              title: d.title
            });
            _this.$('.title').html(d.title);
            _this.$('.year').html(d.year);
            _this.$('.description').html((d.description.length <= 125) && d.description || ("" + (d.description.slice(0, 125)) + "..."));
            _this.$('.network').html(d.network);
            _this.$('#ListView').remove();
            _this.$('#castListContainer').append(cell.prototype.$R(ListView, {
              id: 'castListView',
              list: (function() {
                var _i, _len, _ref, _ref2, _results;
                _ref = d.cast;
                _results = [];
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                  _ref2 = _ref[_i], id = _ref2.id, name = _ref2.name;
                  _results.push({
                    link: this.pageURI('pages/profiledetails/ProfileDetails', {
                      id: id,
                      title: name
                    }),
                    text: name
                  });
                }
                return _results;
              }).call(_this)
            }));
            return _this.model.trigger('refreshScroller');
          });
        }
      });
    }
  };
});
