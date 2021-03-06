// Generated by CoffeeScript 1.3.3

define(function() {
  return function(_arg) {
    var DEFAULT_TAB, encodeData, it_fires_change_location_with, it_generates_location_uid, it_sets_location_to, loadModule, mock_config;
    loadModule = _arg.loadModule;
    encodeData = function(data) {
      return encodeURIComponent(JSON.stringify(data));
    };
    it_generates_location_uid = function(_arg1) {
      var post_message, to_not_be, to_not_be_val, _ref;
      to_not_be = (_arg1 != null ? _arg1 : {}).to_not_be;
      post_message = to_not_be != null ? 'NOT equal to' + ((_ref = typeof to_not_be) === 'number' || _ref === 'string' ? (to_not_be_val = to_not_be, to_not_be = function() {
        return to_not_be_val;
      }, " " + to_not_be_val) : '...') : '';
      return it("Generates Nav.location.uid " + post_message, function() {
        var uid;
        uid = this.nav.location.uid;
        expect(typeof uid === 'number').toBe(true);
        expect(uid).toBeGreaterThan(0);
        if (to_not_be != null) {
          return expect(uid).not.toBe(to_not_be.call(this));
        }
      });
    };
    it_fires_change_location_with = function(_arg1) {
      var options, previous_location;
      previous_location = _arg1.previous_location, options = _arg1.options;
      return describe("fires 'change:location' event", function() {
        var k, v, _fn;
        it("fires event once", function() {
          return expect(this.on_change_location.calls.length).toBe(1);
        });
        it("with current location (argument 1)", function() {
          return expect(this.on_change_location.calls[0].args[0]).toBe(this.nav.location);
        });
        if (previous_location != null) {
          _fn = function(k, v) {
            return it("with previous location (argument 2) ." + k + " === " + (JSON.stringify(v)), function() {
              return expect(this.on_change_location.calls[0].args[1][k]).toEqual(v);
            });
          };
          for (k in previous_location) {
            v = previous_location[k];
            _fn(k, v);
          }
        } else {
          it("with previous location (argument 2) === undefined", function() {
            return expect(this.on_change_location.calls[0].args[1]).toBe(void 0);
          });
        }
        return it("with options (argument 3)", function() {
          return expect(this.on_change_location.calls[0].args[2]).toEqual(options);
        });
      });
    };
    it_sets_location_to = function(location_attrs) {
      var data, has_referrer, location_hash_rx, page, tab, uid, uid_regex;
      tab = location_attrs.tab, page = location_attrs.page, data = location_attrs.data, uid = location_attrs.uid, has_referrer = location_attrs.has_referrer;
      data = (data != null) && ("\\?" + (encodeData(data))) || '';
      uid_regex = (uid != null) && typeof uid !== 'function' ? uid : "\\d+";
      location_hash_rx = new RegExp("#" + tab + "/" + uid_regex + "/" + page + data);
      it("Sets window.location.hash to match " + location_hash_rx, function() {
        return expect(window.location.hash).toMatch(location_hash_rx);
      });
      return it("Sets Nav.location to " + (JSON.stringify(location_attrs)), function() {
        var expected_uid_val, k, v;
        for (k in location_attrs) {
          v = location_attrs[k];
          if (k !== 'uid') {
            expect(this.nav.location[k]).toEqual(v);
          }
        }
        if (uid != null) {
          expected_uid_val = (typeof uid === 'function') && uid.call(this) || uid;
          return expect(this.nav.location.uid).toEqual(expected_uid_val);
        }
      });
    };
    mock_config = {
      default_tab: DEFAULT_TAB = 'DefaultTab'
    };
    beforeEach(function() {
      var _this = this;
      return loadModule({
        'Config': mock_config
      }, function(nav) {
        var set_location_loaded_callback_obj, _ref;
        _this.nav = nav;
        if ((_ref = Backbone.history) != null) {
          _ref.stop();
        }
        window.location.hash = '';
        _this.nav.on('change:location', _this.on_change_location = jasmine.createSpy('change:location handler'));
        set_location_loaded_callback_obj = {
          callback: function(location_loaded) {
            _this.location_loaded = location_loaded;
          }
        };
        spyOn(set_location_loaded_callback_obj, 'callback').andCallThrough();
        _this.set_location_loaded_callback = set_location_loaded_callback_obj.callback;
        return _this.cur_location_loaded = function() {
          return _this.location_loaded(_this.nav.location.uid);
        };
      });
    });
    afterEach(function() {
      var _ref;
      if ((_ref = Backbone.history) != null) {
        _ref.stop();
      }
      return window.location.hash = '';
    });
    describe('@start(set_location_loaded_callback)', function() {
      var when_initial_hash_is;
      describe('when set_location_loaded_callback is an invalid value', function() {
        var invalid_location_loader, _i, _len, _ref, _results;
        _ref = ['string', 5, void 0, null];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          invalid_location_loader = _ref[_i];
          _results.push((function(invalid_location_loader) {
            return it("(" + (JSON.stringify(invalid_location_loader)) + ") throws exception", function() {
              var _this = this;
              return expect(function() {
                return _this.nav.start(invalid_location_loader);
              }).toThrow();
            });
          })(invalid_location_loader));
        }
        return _results;
      });
      when_initial_hash_is = function(initial_location_hash, cb) {
        return describe("when initial hash is '#" + initial_location_hash + "'", function() {
          beforeEach(function() {
            window.location.hash = initial_location_hash;
            return this.nav.start(this.set_location_loaded_callback);
          });
          cb();
          return {
            page: "DefaultTabPage",
            data: {},
            has_referrer: false
          };
        });
      };
      when_initial_hash_is('', function() {
        it_sets_location_to({
          tab: DEFAULT_TAB,
          page: 'DefaultTabPage'
        });
        it_generates_location_uid();
        return it_fires_change_location_with({
          previous_location: void 0,
          options: {
            is_back: false,
            is_switch_tab: true
          }
        });
      });
      when_initial_hash_is("tab/page?" + (encodeData({
        key1: 'val1'
      })), function() {
        it_sets_location_to({
          tab: 'tab',
          page: 'page',
          data: {
            key1: 'val1'
          },
          has_referrer: false
        });
        it_generates_location_uid();
        return it_fires_change_location_with({
          previous_location: void 0,
          options: {
            is_back: false,
            is_switch_tab: true
          }
        });
      });
      when_initial_hash_is("tab/page", function() {
        it_sets_location_to({
          tab: 'tab',
          page: 'page',
          data: {},
          has_referrer: false
        });
        it_generates_location_uid();
        return it_fires_change_location_with({
          previous_location: void 0,
          options: {
            is_back: false,
            is_switch_tab: true
          }
        });
      });
      when_initial_hash_is("tab/", function() {
        it_sets_location_to({
          tab: 'tab',
          page: 'tabPage',
          data: {},
          has_referrer: false
        });
        it_generates_location_uid();
        return it_fires_change_location_with({
          previous_location: void 0,
          options: {
            is_back: false,
            is_switch_tab: true
          }
        });
      });
      return describe('when initial hash has a uid...', function() {
        when_initial_hash_is("tab/1234/page?" + (encodeData({
          key1: 'val1'
        })), function() {
          it_sets_location_to({
            tab: 'tab',
            page: 'page',
            data: {
              key1: 'val1'
            },
            has_referrer: false
          });
          it_generates_location_uid({
            to_not_be: 1234
          });
          it_fires_change_location_with({
            previous_location: void 0,
            options: {
              is_back: false,
              is_switch_tab: true
            }
          });
          return describe("adds initial location to history", function() {
            beforeEach(function() {
              this.expecteduid = this.nav.location.uid;
              this.cur_location_loaded();
              this.nav.go_to({
                page: 'page2'
              });
              this.cur_location_loaded();
              return this.nav.go_to_referrer(this.nav.location.uid);
            });
            return it_sets_location_to({
              tab: 'tab',
              page: 'page',
              data: {
                key1: 'val1'
              },
              has_referrer: false,
              uid: function() {
                return this.expecteduid;
              }
            });
          });
        });
        return when_initial_hash_is("tab/1234", function() {
          it_sets_location_to({
            tab: 'tab',
            page: 'tabPage',
            data: {},
            has_referrer: false
          });
          it_generates_location_uid({
            to_not_be: 1234
          });
          return it_fires_change_location_with({
            previous_location: void 0,
            options: {
              is_back: false,
              is_switch_tab: true
            }
          });
        });
      });
    });
    describe('@switch_tab', function() {
      beforeEach(function() {
        this.nav.start(this.set_location_loaded_callback);
        return this.initial_location_uid = this.nav.location.uid;
      });
      describe('when loading another page, does nothing', function() {
        beforeEach(function() {
          return this.nav.switch_tab('wont_get_here');
        });
        it_sets_location_to({
          tab: DEFAULT_TAB,
          page: 'DefaultTabPage',
          data: {},
          has_referrer: false,
          uid: function() {
            return this.initial_location_uid;
          }
        });
        return it("doesn't modify history", function() {
          return expect(this.nav._tab_history('wont_get_here').length).toBe(0);
        });
      });
      return describe('when NOT loading another page', function() {
        beforeEach(function() {
          return this.cur_location_loaded();
        });
        describe('when given a tab previously visited', function() {
          beforeEach(function() {
            this.nav.go_to({
              page: 'page1'
            });
            this.cur_location_loaded();
            this.page1_uid = this.nav.location.uid;
            this.nav.switch_tab('tab2');
            this.cur_location_loaded();
            this.nav.on('change:location', this.on_change_location = jasmine.createSpy('on change:location'));
            this.nav.switch_tab(DEFAULT_TAB);
            return this.cur_location_loaded();
          });
          it_sets_location_to({
            tab: DEFAULT_TAB,
            page: 'page1',
            data: {},
            has_referrer: true,
            uid: function() {
              return this.page1_uid;
            }
          });
          return it_fires_change_location_with({
            previous_location: {
              tab: 'tab2',
              page: "tab2Page",
              data: {},
              has_referrer: false
            },
            options: {
              is_back: false,
              is_switch_tab: true
            }
          });
        });
        return describe('when given a tab NOT previously visited', function() {
          beforeEach(function() {
            this.nav.on('change:location', this.on_change_location = jasmine.createSpy('on change:location'));
            return this.nav.switch_tab('tab1');
          });
          it_sets_location_to({
            tab: 'tab1',
            page: 'tab1Page',
            data: {},
            has_referrer: false
          });
          it_generates_location_uid();
          return it_fires_change_location_with({
            previous_location: {
              tab: DEFAULT_TAB,
              page: "DefaultTabPage",
              data: {},
              has_referrer: false
            },
            options: {
              is_back: false,
              is_switch_tab: true
            }
          });
        });
      });
    });
    describe('@go_to_referrer', function() {
      beforeEach(function() {
        this.nav.start(this.set_location_loaded_callback);
        return this.cur_location_loaded();
      });
      describe('when uid has NO referrer', function() {
        beforeEach(function() {
          this.nav.on('change:location', this.on_change_location = jasmine.createSpy('on change:location'));
          return this.nav.go_to_referrer(this.nav.location.uid);
        });
        it_sets_location_to({
          tab: DEFAULT_TAB,
          page: 'DefaultTabPage',
          data: {},
          has_referrer: false
        });
        return it("it doesn't fire change:location", function() {
          return expect(this.on_change_location).not.toHaveBeenCalled();
        });
      });
      return describe('when uid has a referrer', function() {
        beforeEach(function() {
          this.nav.go_to({
            page: 'page1'
          });
          this.initial_location_uid = this.nav.location.uid;
          return this.nav.on('change:location', this.on_change_location = jasmine.createSpy('on change:location'));
        });
        describe('when loading another page, does nothing', function() {
          beforeEach(function() {
            return this.nav.go_to_referrer(this.nav.location.uid);
          });
          it_sets_location_to({
            tab: DEFAULT_TAB,
            page: 'page1',
            data: {},
            has_referrer: true,
            uid: function() {
              return this.initial_location_uid;
            }
          });
          return it("doesn't modify history", function() {
            return expect(this.nav._tab_history(DEFAULT_TAB).length).toBe(2);
          });
        });
        return describe('when NOT loading another page', function() {
          beforeEach(function() {
            this.cur_location_loaded();
            return this.nav.go_to_referrer(this.nav.location.uid);
          });
          it_sets_location_to({
            tab: DEFAULT_TAB,
            page: "" + DEFAULT_TAB + "Page",
            data: {},
            has_referrer: false
          });
          it_generates_location_uid();
          return it_fires_change_location_with({
            previous_location: {
              tab: DEFAULT_TAB,
              page: 'page1',
              data: {},
              has_referrer: true
            },
            options: {
              is_back: true,
              is_switch_tab: false
            }
          });
        });
      });
    });
    return describe('@go_to', function() {
      beforeEach(function() {
        this.nav.start(this.set_location_loaded_callback);
        this.cur_location_loaded();
        return this.nav.on('change:location', this.on_change_location = jasmine.createSpy('change:location handler'));
      });
      describe('when no page is specified', function() {
        return it('throws error', function() {
          var _this = this;
          return expect(function() {
            return _this.nav.go_to({});
          }).toThrow();
        });
      });
      describe('when tab specified is different then current tab', function() {
        return it('throws error', function() {
          var _this = this;
          return expect(function() {
            return _this.nav.go_to({
              tab: "" + DEFAULT_TAB + "MakeItDifferent"
            });
          }).toThrow();
        });
      });
      describe('when tab specified is the same', function() {
        beforeEach(function() {
          this.nav.go_to({
            tab: DEFAULT_TAB,
            page: "page1"
          });
          return this.cur_location_loaded();
        });
        it_sets_location_to({
          tab: DEFAULT_TAB,
          page: 'page1',
          data: {},
          has_referrer: true
        });
        it_generates_location_uid();
        return it_fires_change_location_with({
          previous_location: {
            tab: DEFAULT_TAB,
            page: "" + DEFAULT_TAB + "Page",
            data: {}
          },
          options: {
            is_back: false,
            is_switch_tab: false
          }
        });
      });
      describe('with no tab history', function() {
        beforeEach(function() {
          return this.nav.go_to({
            page: 'page1'
          });
        });
        it_sets_location_to({
          tab: DEFAULT_TAB,
          page: 'page1',
          data: {},
          has_referrer: true
        });
        it_generates_location_uid();
        return it_fires_change_location_with({
          previous_location: {
            tab: DEFAULT_TAB,
            page: "" + DEFAULT_TAB + "Page",
            data: {}
          },
          options: {
            is_back: false,
            is_switch_tab: false
          }
        });
      });
      return describe('with tab history', function() {
        beforeEach(function() {
          this.nav.go_to({
            page: 'page1'
          });
          this.cur_location_loaded();
          this.nav.on('change:location', this.on_change_location = jasmine.createSpy('change:location handler'));
          this.nav.go_to({
            page: 'page2'
          });
          return this.cur_location_loaded();
        });
        it_sets_location_to({
          tab: DEFAULT_TAB,
          page: 'page2',
          data: {},
          has_referrer: true
        });
        it_generates_location_uid();
        return it_fires_change_location_with({
          previous_location: {
            tab: DEFAULT_TAB,
            page: "page1",
            data: {},
            has_referrer: true
          },
          options: {
            is_back: false,
            is_switch_tab: false
          }
        });
      });
    });
  };
});
