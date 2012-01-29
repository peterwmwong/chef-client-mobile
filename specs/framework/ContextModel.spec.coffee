define [
  'SpecHelpers'
  '/src/framework/Model.js'
], ({spyOnAll},Model)->

  ({mockModules,loadModule,getRequire})->

    hashHandler = null
    ctx = null
    mInput =
      id: 'id'
      initialHash: {hash:'initial hash', k1:1, k2:2}
      hashManager: {bind:->}
      defaultPagePath: 'defaultPagePath'

    beforeEach ->
      mockModules 'framework/Model': Model
      loadModule (ContextModel)->
        spy = spyOn mInput.hashManager, 'bind'
        ctx = new ContextModel mInput
        hashHandler = spy.argsForCall[0][0]["change:current[context=id]"]

    describe 'new ContextModel({id,initialHash,hashManager,defaultPagePath})', ->

      it 'is a Model', ->
        expect(ctx instanceof Model).toBe true

      it '@id == id', ->
        expect( ctx.id ).toBe mInput.id

      it '@currentPageModel == new Model initialHash', ->
        expect( ctx.currentPageModel ).toEqual new Model mInput.initialHash
      
      it '@pageHistory == [.currentPageModel]', ->
        expect( ctx.pageHistory ).toEqual [ctx.currentPageModel]

      it '@defaultPagePath == defaultPagePath', ->
        expect( ctx.defaultPagePath )

      it 'calls hashManager.bind("change:current[context=#{id}]") with callback function', ->
        expect( typeof mInput.hashManager.bind.argsForCall[0][0]["change:current[context=#{mInput.id}]"] ).toBe "function"

    describe 'hashManager.bind "change:current[context=#{id}]" Handler', ->

      it 'unshifts new entries onto @pageHistory', ->
        hashHandler cur: cur = {hash: 'testhash', k3:3}
        expect( ctx.pageHistory ).toEqual [
          new Model cur
          new Model mInput.initialHash
        ]

        hashHandler cur: cur2 = {hash: 'testhash2', k4:4}
        expect( ctx.pageHistory ).toEqual [
          new Model cur2
          new Model cur
          new Model mInput.initialHash
        ]

      it 'detects back when @pageHistory[1] (last page) == new hash', ->
        hashHandler cur: cur = {hash: 'testhash', k3:3}
        hashHandler cur: cur = {hash: 'initial hash'}
        expect( ctx.pageHistory ).toEqual [new Model mInput.initialHash]



