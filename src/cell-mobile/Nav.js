// Generated by CoffeeScript 1.3.3

define(['Config'], function(Config) {
  var Nav, default_tab_page, gen_uid, uid_salt;
  uid_salt = 0;
  gen_uid = function() {
    return Date.now() * 100 + (uid_salt++ % 100);
  };
  default_tab_page = function(tab) {
    return "" + tab + "Page";
  };
  _.extend((Nav = function() {}).prototype, Backbone.Events, {
    _uid_to_location: {},
    _tab_histories: {},
    _isnt_first: false,
    _loading_uid: void 0,
    _tab_history: function(tab) {
      var _base;
      return (_base = this._tab_histories)[tab] || (_base[tab] = []);
    },
    _set_location: function(new_location, options) {
      var prev_location;
      if (!this._loading_uid) {
        this._isnt_first = true;
        this._loading_uid = new_location.uid;
        prev_location = this.location;
        this.trigger('change:location', this.location = new_location, prev_location, options);
        return this._syncLocation();
      }
    },
    _syncLocation: function() {
      var data, page, tab, uid, _ref;
      _ref = this.location, tab = _ref.tab, uid = _ref.uid, page = _ref.page, data = _ref.data;
      return Backbone.history.navigate("#" + tab + "/" + uid + "/" + page + "?" + (encodeURIComponent(JSON.stringify(data))));
    },
    _go_back_to: function(uid) {
      var i, location, removed_location, tab, tab_history, _i, _j, _len, _len1, _ref, _ref1, _ref2;
      if (!this._loading_uid && this._isnt_first && (tab = (_ref = this._uid_to_location[uid]) != null ? _ref.tab : void 0)) {
        _ref1 = (tab_history = this._tab_history(tab));
        for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
          location = _ref1[i];
          if (!(location.uid === uid)) {
            continue;
          }
          _ref2 = tab_history.splice(i + 1);
          for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
            removed_location = _ref2[_j];
            this._uid_to_location[removed_location.uid] = void 0;
          }
          this._set_location(location, {
            is_back: true,
            is_switch_tab: location.tab !== this.location.tab
          });
          return true;
        }
      }
      return false;
    },
    go_to_referrer: function(location_uid) {
      var referrer_uid, _ref;
      if (this._uid_to_location[referrer_uid = (_ref = this._uid_to_location[location_uid]) != null ? _ref._referrer_uid : void 0]) {
        return this._go_back_to(referrer_uid);
      }
    },
    switch_tab: function(tab) {
      var el, i, tab_history;
      if (!this._loading_uid) {
        tab_history = this._tab_history(tab);
        el = void 0;
        if (i = tab_history.length) {
          el = tab_history[i - 1];
        } else {
          tab_history.push(el = {
            uid: gen_uid(),
            tab: tab,
            page: default_tab_page(tab),
            data: {},
            has_referrer: false
          });
          this._uid_to_location[el.uid] = el;
        }
        this._set_location(el, {
          is_back: false,
          is_switch_tab: true
        });
      }
    },
    go_to: function(_arg) {
      var data, el, isnt_first, page, tab, tab_history, _ref;
      tab = _arg.tab, page = _arg.page, data = _arg.data;
      if (!this._loading_uid) {
        if (!(page != null)) {
          throw "no page specified";
        }
        isnt_first = this._isnt_first;
        tab || (tab = this.location.tab);
        if (isnt_first && tab !== this.location.tab) {
          throw "Trying to go to another tab.  Use switch_tab instead.";
        }
        tab_history = this._tab_history(tab);
        tab_history.push(el = {
          uid: gen_uid(),
          tab: tab,
          page: page,
          data: data || {},
          has_referrer: this.location != null,
          _referrer_uid: (_ref = this.location) != null ? _ref.uid : void 0
        });
        this._uid_to_location[el.uid] = el;
        if (el) {
          this._set_location(el, {
            is_back: false,
            is_switch_tab: !isnt_first
          });
        }
      }
    },
    start: function(set_location_loaded_callback) {
      var model,
        _this = this;
      set_location_loaded_callback(function(uid) {
        if ((uid != null) && _this._loading_uid === uid) {
          return _this._loading_uid = void 0;
        }
      });
      model = this;
      new (Backbone.Router.extend({
        initialize: function() {
          this.route(/.*/, '404', function() {
            return model.switch_tab(Config.default_tab);
          });
          this.route(/(\w+)(\/(\d+))?(\/(\w+))?(\?(.*))?/, 'tab_salt_page_pagedata', function(tab, _0, uid, _2, page, _3, data) {
            if (!(uid && model._go_back_to(Number(uid)))) {
              return model.go_to({
                tab: tab,
                page: page || default_tab_page(tab),
                data: data && (JSON.parse(decodeURIComponent(data)))
              });
            }
          });
        }
      }));
      Backbone.history.start();
    }
  });
  return new Nav;
});
