
define(['require', './Nav'], function(require, Nav) {
  return {
    tag: function() {
      return "<div data-cellpath='" + this.model.page + "'>";
    },
    render: function(_) {
      var _this = this;
      return require(["cell!" + this.model.page], function(page) {
        page.prototype.pageURI = Nav.pageHash;
        _this.$el.append(_(page, {
          model: _this.model
        }));
        return _this.pageRendered();
      });
    },
    pageRendered: function() {
      var active, scroller,
        _this = this;
      active = true;
      this.model.bind({
        'deactivate': function() {
          return active = false;
        }
      });
      this.model.bind({
        'activate': function() {
          active = true;
          return _this.$el.css('visibility', 'visible');
        }
      });
      this.$el.bind('webkitAnimationEnd', function() {
        if (!active) return _this.$el.css('visibility', 'hidden');
      });
      scroller = new iScroll(this.el);
      return this.model.bindAndCall({
        'refreshScroller': function() {
          return scroller.refresh();
        }
      });
    }
  };
});
