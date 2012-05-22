define -> ({loadModule})->

  describe '#getSync', ->
    describe 'creates a sync function (to override Backbone.sync)', ->
      class MockModel
        constructor: ({@url})->
          @toJSON = sinon.stub().returns {}

      beforeEach ->
        loadModule {
          'mock-resource-loader/mock-resources':
            res1:
              create: @mock_res1_create =
                sinon.stub().returns @mock_res1_create_return = a:5
              read: @mock_res1_read = sinon.stub()
            res2:
              create: @mock_res2_create = sinon.stub().throws("Blah")
              update: @mock_res2_update = sinon.stub()
        }, (@mock_data_loader)=>
          @sync = @mock_data_loader.getSync()

      it 'should be a function', ->
        expect(typeof @sync).toBe 'function'

      it 'should be cache the function', ->
        expect(@sync).toBe @mock_data_loader.getSync()

      it 'when called, should choose the appropriate resource handler', ->
        runs => @sync 'create', new MockModel(url: '/res1'), {success: (->), error: (->)}
        waitsFor => @mock_res1_create.callCount is 1
        runs =>
          expect(@mock_res1_create.callCount).toBe 1
          expect(@mock_res1_read.callCount).toBe 0
          expect(@mock_res2_create.callCount).toBe 0
          expect(@mock_res2_update.callCount).toBe 0

        runs => @sync 'update', new MockModel(url: '/res2'), {success: (->), error: (->)}
        waitsFor => @mock_res2_update.callCount
        runs =>
          expect(@mock_res1_create.callCount).toBe 1
          expect(@mock_res1_read.callCount).toBe 0
          expect(@mock_res2_create.callCount).toBe 0
          expect(@mock_res2_update.callCount).toBe 1

      it 'when called, should pass the id, model.toJSON() and options', ->
        runs => @sync 'read', (@mockModel = new MockModel(url: '/res1/mock_id')), {success: (->), error: (->), data:(@mock_data = {key: 'value'})}
        waitsFor => @mock_res1_read.callCount
        runs =>
          expect(@mockModel.toJSON.callCount).toBe 1
          expect(@mock_res1_read.callCount).toBe 1
          expect(@mock_res1_read.calledWith 'mock_id', @mockModel.toJSON.getCall(0).returnValue, @mock_data).toBe true

      it 'when called, should pass the undefined (id not specified), model.toJSON() and options ', ->
        runs => @sync 'read', (@mockModel = new MockModel(url: '/res1')), {success: (->), error: (->), data:(@mock_data = {key: 'value'})}
        waitsFor => @mock_res1_read.callCount
        runs =>
          expect(@mockModel.toJSON.callCount).toBe 1
          expect(@mock_res1_read.callCount).toBe 1
          expect(@mock_res1_read.calledWith undefined, @mockModel.toJSON.getCall(0).returnValue, @mock_data).toBe true

      it 'when called, should call opts.success with resource handler result', ->
        runs => @sync 'create', (@mock_model = new MockModel(url: '/res1')), {success: @mock_success = sinon.stub(), error: @mock_error = sinon.stub()}
        waitsFor => @mock_success.calledOnce
        runs =>
          expect(@mock_error.called).toBe false
          expect(@mock_success.calledOnce).toBe true
          expect(@mock_success.getCall(0).args[0]).toEqual @mock_res1_create_return

      it "when called with a url that doesn't map to a resource handler, calls opts.error", ->
        runs => @sync 'create', (@mock_model = new MockModel(url: '/bogus_url')), {success: @mock_success = sinon.stub(), error: @mock_error = sinon.stub()}
        waitsFor => @mock_error.calledOnce
        runs =>
          expect(@mock_success.called).toBe false
          expect(@mock_error.calledOnce).toBe true
          expect(@mock_error.getCall(0).args[0]).toBe "Couldn't find mock resource handler"

      it "when called with a url maps to a resource handler, BUT handler can't handle method, calls opts.error", ->
        runs => @sync 'update', (mock_model = new MockModel(url: '/res1')), {success: @mock_success = sinon.stub(), error: @mock_error = sinon.stub()}
        waitsFor => @mock_error.calledOnce
        runs =>
          expect(@mock_success.called).toBe false
          expect(@mock_error.calledOnce).toBe true
          expect(@mock_error.getCall(0).args[0]).toBe "Couldn't find mock resource handler"

      it "when called and resource handler throws error, calls opts.error", ->
        runs => @sync 'create', (mock_model = new MockModel(url: '/res2')), {success: @mock_success = sinon.stub(), error: @mock_error = sinon.stub()}
        waitsFor => @mock_error.calledOnce
        runs =>
          expect(@mock_success.called).toBe false
          expect(@mock_error.calledOnce).toBe true


  describe '#_getResourceRoutes', ->

    beforeEach ->
      loadModule {
        'mock-resource-loader/mock-resources':
          res1: @mock_res1 =
            method1: ->
            method2: ->
          res2: @mock_res2 =
            method3: ->
            method4: ->
      }, (@mock_data_loader)=>
        @spy_getResourceRouteParser = sinon.spy @mock_data_loader, '_getResourceRouteParser'
        @routes = @mock_data_loader._getResourceRoutes()

    it 'generates correct url specs for resources from "mock-resource-loader/mock-resources"', ->
      expect(@spy_getResourceRouteParser.callCount).toEqual 2
      expect(@spy_getResourceRouteParser.getCall(0).calledWith 'res1').toBe true
      expect(@spy_getResourceRouteParser.getCall(1).calledWith 'res2').toBe true

    it 'returns array of [route method, resource handlers from "mock-resource-loader/mock-resources"]', ->
      expect(@routes).toEqual [
        [@spy_getResourceRouteParser.returnValues[0], @mock_res1]
        [@spy_getResourceRouteParser.returnValues[1], @mock_res2]
      ]

    it 'caches parsed routes', ->
      expect(@mock_data_loader._getResourceRoutes()).toBe @mock_data_loader._getResourceRoutes()
      expect(@spy_getResourceRouteParser.callCount).toEqual 2

  describe '#_getResourceRouteParser', ->
    _getResourceRouteParser = undefined
    validate = (res,inputExpects...)->
      for [input, exp] in inputExpects then do(input,exp)->
        it "Given '#{res}', '#{input}' -> #{JSON.stringify exp}", ->
          f = _getResourceRouteParser res
          expect(f input)[exp is undefined and 'toBe' or 'toEqual'] exp

    beforeEach ->
      loadModule 'mock-resource-loader/mock-resources': {}, (mock_data_loader)->
        _getResourceRouteParser = mock_data_loader._getResourceRouteParser

    validate 'abc',
      ['/abc', {}]
      ['/abc/', {}]
      ['/abc/myid', {id: 'myid'}]
