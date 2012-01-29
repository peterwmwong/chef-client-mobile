var __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

define(['./Model'], function(Model) {
  var ContextModel;
  return ContextModel = (function(_super) {

    __extends(ContextModel, _super);

    function ContextModel(_arg) {
      var bind, currentPageModel, defaultPagePath, hashManager, id, initialHash, pageHistory,
        _this = this;
      id = _arg.id, initialHash = _arg.initialHash, hashManager = _arg.hashManager, defaultPagePath = _arg.defaultPagePath;
      ContextModel.__super__.constructor.call(this, {
        id: id,
        defaultPagePath: defaultPagePath,
        currentPageModel: currentPageModel = new Model(initialHash),
        pageHistory: pageHistory = [currentPageModel]
      });
      (bind = {})["change:current[context=" + id + "]"] = function(_arg2) {
        var cur, isContextSwitch, prev, _ref;
        cur = _arg2.cur, prev = _arg2.prev;
        if (!(isContextSwitch = cur.context !== (prev != null ? prev.context : void 0))) {
          if (((_ref = pageHistory[1]) != null ? _ref.hash : void 0) === cur.hash) {
            pageHistory.splice(0, 1);
          } else {
            pageHistory.unshift(new Model(cur));
          }
        }
        return _this.set({
          currentPageModel: pageHistory[0]
        }, {
          isContextSwitch: isContextSwitch
        });
      };
      hashManager.bind(bind);
    }

    return ContextModel;

  })(Model);
});
