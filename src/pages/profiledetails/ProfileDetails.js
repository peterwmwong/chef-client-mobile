
define(['Services', 'cell!shared/ListView'], function(S, ListView) {
  return {
    render: function(_) {
      return [_('img'), _('.nameGroup', _('h2.name'), _('h4.bornInfo')), _('.knownForGroup', _('h4.knownForHeader', 'Known For'), _('#knownForList'))];
    },
    afterRender: function() {
      var _this = this;
      this.model.bind({
        'activate': function() {
          return _this.$('#knownForList > .ListView').trigger('resetActive');
        }
      });
      return this.model.bindAndCall({
        'change:data': function(_arg) {
          var id, title, _ref;
          _ref = _arg.cur, id = _ref.id, title = _ref.title;
          _this.model.set({
            title: title || 'Loading...'
          });
          return S.actor.getDetails(id, function(_arg2) {
            var born, knownFor, name, role;
            name = _arg2.name, born = _arg2.born, knownFor = _arg2.knownFor;
            _this.model.set({
              title: name
            });
            _this.$('.name').html(name);
            _this.$('.bornInfo').html(born.year);
            _this.$('#knownForList > .ListView').remove();
            _this.$('#knownForList').append(cell.prototype.$R(ListView, {
              list: (function() {
                var _i, _len, _ref2, _results;
                _results = [];
                for (_i = 0, _len = knownFor.length; _i < _len; _i++) {
                  _ref2 = knownFor[_i], id = _ref2.id, role = _ref2.role, title = _ref2.title;
                  _results.push({
                    link: this.pageURI("pages/showdetails/ShowDetails", {
                      id: id,
                      title: title
                    }),
                    text: title
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
