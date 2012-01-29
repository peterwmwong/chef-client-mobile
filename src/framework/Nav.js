
define(['AppConfig', 'HashDelegate', './Model'], function(AppConfig, HashDelegate, Model) {
  var Nav, contextHists, ctx, hashRx, _fixedHash, _parseHash, _toHash;
  hashRx = /^\#([^!^?]+)(!([^?]+))?(\?(.+))?/;
  _fixedHash = false;
  Nav = new Model({
    _toHash: _toHash = function(_arg) {
      var context, ctx, data, page;
      context = _arg.context, page = _arg.page, data = _arg.data;
      ctx = (AppConfig.contexts[context] && context) || AppConfig.defaultContext;
      return "#" + ctx + "!" + (page || AppConfig.contexts[ctx].defaultPagePath) + (data && ("?" + (encodeURIComponent(JSON.stringify(data)))) || '');
    },
    _parseHash: _parseHash = function(hash) {
      var context, ctxid, jsondata, page, result;
      result = hashRx.exec(hash);
      return {
        hash: hash,
        context: context = ((ctxid = result != null ? result[1] : void 0) && AppConfig.contexts[ctxid] && ctxid) || AppConfig.defaultContext,
        page: ((page = result != null ? result[3] : void 0) && (page.substr(-1) !== '/') && page) || AppConfig.contexts[context].defaultPagePath,
        data: (jsondata = result != null ? result[5] : void 0) && JSON.parse(decodeURIComponent(jsondata))
      };
    },
    current: (function() {
      var finalHashString, hash;
      hash = _parseHash(HashDelegate.get());
      if (hash.hash !== (finalHashString = _toHash(hash))) {
        hash.hash = finalHashString;
        _fixedHash = true;
      }
      return new Model(hash);
    })(),
    canBack: function() {
      var _ref;
      return ((_ref = contextHists[Nav.current.context]) != null ? _ref.length : void 0) > 1;
    },
    goBack: function() {
      var h, _ref;
      if (h = (_ref = contextHists[Nav.current.context][1]) != null ? _ref.hash : void 0) {
        return HashDelegate.set(h);
      }
    },
    pageHash: function(page, data) {
      return _toHash({
        context: Nav.current.context,
        page: page,
        data: data
      });
    },
    switchContext: function(ctxid) {
      var hist;
      if (typeof ctxid === 'string' && (hist = contextHists[ctxid]) && Nav.current.context !== ctxid) {
        return HashDelegate.set(_toHash(hist[0] || {
          context: ctxid,
          page: AppConfig.contexts[ctxid].defaultPage
        }));
      }
    }
  });
  contextHists = {};
  for (ctx in AppConfig.contexts) {
    contextHists[ctx] = [];
  }
  contextHists[Nav.current.context].push(Nav.current);
  Nav.bind({
    'change:current': function(e) {
      var event, k, v;
      event = {};
      for (k in e) {
        v = e[k];
        event[k] = v;
      }
      event.type = "change:current[context=" + e.cur.context + "]";
      return Nav.trigger(event);
    }
  });
  HashDelegate.onChange(function() {
    var ctxHist, h, _ref;
    if (_fixedHash) {
      _fixedHash = false;
    } else {
      h = _parseHash(HashDelegate.get());
      ctxHist = contextHists[h.context];
      if (Nav.current.context !== h.context) {
        Nav.set({
          current: ctxHist.length ? ctxHist[0] : (ctxHist.unshift(h = new Model(h)), h)
        }, {
          isBack: false,
          isContextSwitch: true
        });
      } else if (h.hash === ((_ref = ctxHist[1]) != null ? _ref.hash : void 0)) {
        h = ctxHist[1];
        ctxHist.shift();
        Nav.set({
          current: h
        }, {
          isBack: true,
          isContextSwitch: false
        });
      } else if (ctxHist.length === 0 || ctxHist[0].hash !== h.hash) {
        ctxHist.unshift(h = new Model(h));
        Nav.set({
          current: h
        }, {
          isBack: false,
          isContextSwitch: false
        });
      }
    }
  });
  if (_fixedHash) HashDelegate.set(Nav.current.hash);
  return Nav;
});
