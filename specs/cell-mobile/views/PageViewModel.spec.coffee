define ['spec-mocks/mocks'], ({mock_location})->
  DEFAULT_TITLE = 'Loading...'

  ({loadModule})->
    beforeEach -> loadModule (@PageViewModel)=>

    describe 'constructor', ->
      beforeEach -> @page_model = new @PageViewModel location: @mock_location = {}

      it 'stores {location} argument', ->
        expect(@page_model.location).toBe @mock_location

      it 'sets default title', ->
        expect(@page_model.title).toBe DEFAULT_TITLE

    describe '@set_title', ->
      beforeEach ->
        @page_model = new @PageViewModel location: @mock_location = {}
        @page_model.on 'change:title', @on_change_title =
          jasmine.createSpy 'change:title handler'
        @page_model.set_title 'new title'

      describe 'fires change:title event', ->
        it 'fires once', ->
          expect(@on_change_title.calls.length).toBe 1

        it 'passes correct arguments', ->
          expect(@on_change_title).toHaveBeenCalledWith 'new title', DEFAULT_TITLE

      it 'sets title', ->
        expect(@page_model.title).toBe 'new title'

    describe '#for_location', ->

      it 'when given no uid, returns undefined', ->
        expect(@PageViewModel.for_location()).toBe undefined

      describe 'when given a new location', ->

        beforeEach ->
          @location = mock_location()
          @page_model = @PageViewModel.for_location @location

        it 'creates new PageViewModel', ->
          expect(@page_model instanceof @PageViewModel).toBe true

        it "sets PageViewModel's location", ->
          expect(@page_model.location).toBe @location

      describe 'when given an already visited location', ->

        beforeEach ->
          @location = mock_location()
          @page_model1 = @PageViewModel.for_location @location
          @page_model2 = @PageViewModel.for_location @location

        it "doesn't create a new PageViewModel", ->
          expect(@page_model1).toBe @page_model2

