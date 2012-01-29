
define(['framework/Nav'], function(Nav) {
  return {
    render: function(_) {
      return [_('#backbutton', _('span', 'Back')), _('#titles', _('#title'), _('#prevtitle')), _('#gobutton', _('span', 'Do It'))];
    },
    afterRender: function() {
      var $backbutton, $backbuttonText, $prevtitle, $title, animating, pageHistoryLengthMap,
        _this = this;
      animating = false;
      $backbutton = this.$('#backbutton');
      $backbuttonText = this.$('#backbutton > span');
      $title = this.$('#title');
      $prevtitle = this.$('#prevtitle');
      pageHistoryLengthMap = {};
      $title.bind('webkitAnimationEnd', function() {
        $title.attr('class', '');
        $prevtitle.attr('class', '');
        return animating = false;
      });
      return Nav.bindAndCall({
        'change:current.title': function(_arg) {
          var cur, data, isBack, prev, prevTitle, rev;
          cur = _arg.cur, prev = _arg.prev, data = _arg.data;
          isBack = data != null ? data.isBack : void 0;
          prevTitle = prev;
          $title.html(cur || '');
          if (!animating) {
            $backbutton.css('visibility', Nav.canBack() && 'visible' || 'hidden');
            rev = isBack && '-reverse' || '';
            if (prevTitle) {
              $prevtitle.html(prevTitle).attr('class', 'animate headingOut' + rev);
            }
            $title.attr('class', 'animate headingIn' + rev);
            return animating = true;
          }
        }
      });
    },
    on: {
      'click #backbutton': function() {
        return Nav.goBack();
      }
    }
  };
});
