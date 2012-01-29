
define(['require', './Model', './Nav', 'cell!./Page'], function(require, Model, Nav, Page) {
  return {
    tag: function() {
      return "<div data-ctxid='" + this.options.contextid + "'>";
    },
    afterRender: function() {
      var $el, bind, curPage, f, pageCache;
      pageCache = {};
      curPage = null;
      $el = this.$el;
      f = (bind = {})["change:current[context=" + this.options.contextid + "]"] = function(_arg) {
        var cur, isBack, isContextSwitch, pageCell, pageInClass, prev, prevPageCell, rev, _ref;
        cur = _arg.cur, prev = _arg.prev, (_ref = _arg.data, isBack = _ref.isBack, isContextSwitch = _ref.isContextSwitch);
        if (!isContextSwitch) {
          pageCell = pageCache[cur.hash];
          prevPageCell = prev && pageCache[prev.hash];
          if (prevPageCell && isBack) {
            pageCache[prev.hash] = void 0;
            prevPageCell.$el.bind('webkitAnimationEnd', function() {
              return prevPageCell.$el.remove();
            });
          }
          if (!pageCell) {
            pageCell = pageCache[cur.hash] = new Page({
              model: cur
            });
          }
          pageCell.$el.prependTo($el);
          pageInClass = 'Page';
          pageInClass += ' animate ' + ((prev != null ? prev.context : void 0) === cur.context ? (rev = isBack && '-reverse' || '', curPage != null ? curPage.$el.attr('class', 'Page animate headingOut' + rev) : void 0, curPage != null ? curPage.model.trigger('deactivate') : void 0, 'headingIn' + rev) : 'fadeIn');
          pageCell.$el.attr('class', pageInClass);
          return (curPage = pageCell).model.trigger({
            type: 'activate',
            isback: isBack
          });
        }
      };
      Nav.bind(bind);
      return f({
        cur: this.options.initialHash,
        data: {
          isBack: false
        }
      });
    }
  };
});
