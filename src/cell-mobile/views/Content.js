// Generated by CoffeeScript 1.3.3

define(['__', 'cell-mobile/Nav', 'cell!./PageContainer'], function(__, Nav, PageContainer) {
  return {
    after_render: function() {
      var _this = this;
      return Nav.on('change:location', function(cur_location, prev_location, _arg) {
        var $prev_page, is_back, is_switch_tab;
        is_back = _arg.is_back, is_switch_tab = _arg.is_switch_tab;
        if (is_switch_tab) {
          if (prev_location) {
            _this.$tab(prev_location.tab).removeClass('active');
          }
          _this.$tab(cur_location.tab).addClass('active');
          _this.$page(cur_location).addClass('active').removeClass('page-slide-out page-slide-out-reverse page-slide-in page-slide-in-reverse');
          return _this.options.location_uid_loaded(cur_location.uid);
        } else {
          if (prev_location) {
            ($prev_page = _this.$page(prev_location)).removeClass('active page-slide-in page-slide-in-reverse').addClass("page-slide-out" + (is_back && '-reverse' || ''));
          }
          return _this.$page(cur_location).removeClass('page-slide-out page-slide-out-reverse').addClass("active page-slide-in" + (is_back && '-reverse' || ''));
        }
      });
    },
    $page: function(location) {
      var $page;
      $page = this.$el.children(".tab[data-tab='" + location.tab + "']").children(".PageContainer[data-location-uid='" + location.uid + "']");
      if ($page[0]) {
        return $page;
      } else {
        return __.$(PageContainer, {
          location: location
        }).attr('data-location-uid', location.uid).appendTo(this.$tab(location.tab));
      }
    },
    $tab: function(tab) {
      var $tab;
      if (($tab = this.$el.children(".tab[data-tab='" + tab + "']"))[0]) {
        return $tab;
      } else {
        return __.$('.tab', {
          'data-tab': tab
        }).appendTo(this.$el);
      }
    },
    events: {
      'webkitAnimationEnd .tab > .PageContainer.active': function(_arg) {
        var target;
        target = _arg.target;
        return this.options.location_uid_loaded(Number($(target).data('location-uid')));
      },
      'webkitAnimationEnd .tab > .PageContainer.page-slide-out,.PageContainer.page-slide-out-reverse': function(_arg) {
        var target;
        target = _arg.target;
        return $(target).removeClass('page-slide-out page-slide-out-reverse');
      },
      'webkitAnimationEnd .tab > .PageContainer.page-slide-out-reverse': function(_arg) {
        var target;
        target = _arg.target;
        return $(target).remove();
      }
    }
  };
});
