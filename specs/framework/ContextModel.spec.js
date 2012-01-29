
define(['SpecHelpers', '/src/framework/Model.js'], function(_arg, Model) {
  var spyOnAll;
  spyOnAll = _arg.spyOnAll;
  return function(_arg2) {
    var ctx, getRequire, hashHandler, loadModule, mInput, mockModules;
    mockModules = _arg2.mockModules, loadModule = _arg2.loadModule, getRequire = _arg2.getRequire;
    hashHandler = null;
    ctx = null;
    mInput = {
      id: 'id',
      initialHash: {
        hash: 'initial hash',
        k1: 1,
        k2: 2
      },
      hashManager: {
        bind: function() {}
      },
      defaultPagePath: 'defaultPagePath'
    };
    beforeEach(function() {
      mockModules({
        'framework/Model': Model
      });
      return loadModule(function(ContextModel) {
        var spy;
        spy = spyOn(mInput.hashManager, 'bind');
        ctx = new ContextModel(mInput);
        return hashHandler = spy.argsForCall[0][0]["change:current[context=id]"];
      });
    });
    describe('new ContextModel({id,initialHash,hashManager,defaultPagePath})', function() {
      it('is a Model', function() {
        return expect(ctx instanceof Model).toBe(true);
      });
      it('@id == id', function() {
        return expect(ctx.id).toBe(mInput.id);
      });
      it('@currentPageModel == new Model initialHash', function() {
        return expect(ctx.currentPageModel).toEqual(new Model(mInput.initialHash));
      });
      it('@pageHistory == [.currentPageModel]', function() {
        return expect(ctx.pageHistory).toEqual([ctx.currentPageModel]);
      });
      it('@defaultPagePath == defaultPagePath', function() {
        return expect(ctx.defaultPagePath);
      });
      return it('calls hashManager.bind("change:current[context=#{id}]") with callback function', function() {
        return expect(typeof mInput.hashManager.bind.argsForCall[0][0]["change:current[context=" + mInput.id + "]"]).toBe("function");
      });
    });
    return describe('hashManager.bind "change:current[context=#{id}]" Handler', function() {
      it('unshifts new entries onto @pageHistory', function() {
        var cur, cur2;
        hashHandler({
          cur: cur = {
            hash: 'testhash',
            k3: 3
          }
        });
        expect(ctx.pageHistory).toEqual([new Model(cur), new Model(mInput.initialHash)]);
        hashHandler({
          cur: cur2 = {
            hash: 'testhash2',
            k4: 4
          }
        });
        return expect(ctx.pageHistory).toEqual([new Model(cur2), new Model(cur), new Model(mInput.initialHash)]);
      });
      return it('detects back when @pageHistory[1] (last page) == new hash', function() {
        var cur;
        hashHandler({
          cur: cur = {
            hash: 'testhash',
            k3: 3
          }
        });
        hashHandler({
          cur: cur = {
            hash: 'initial hash'
          }
        });
        return expect(ctx.pageHistory).toEqual([new Model(mInput.initialHash)]);
      });
    });
  };
});
