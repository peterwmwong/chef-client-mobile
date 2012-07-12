define ->

  ({loadModule})->
    encodeData = (data)-> encodeURIComponent JSON.stringify data

    it_generates_location_uid = ({to_not_be} = {})->
      post_message =
        if to_not_be?
          'NOT equal to' +
            if typeof to_not_be in ['number', 'string']
              to_not_be_val = to_not_be
              to_not_be = -> to_not_be_val
              " #{to_not_be_val}"
            else
              '...'
        else ''

      it "Generates Nav.location.uid #{post_message}", ->
        uid = @nav.location.uid
        expect(typeof uid is 'number').toBe true
        expect(uid).toBeGreaterThan 0
        if to_not_be?
          expect(uid).not.toBe to_not_be.call this

    it_fires_change_location_with = ({previous_location, options})->

      describe "fires 'change:location' event", ->

        it "fires event once", ->
          expect(@on_change_location.calls.length).toBe 1

        it "with current location (argument 1)", ->
          expect(@on_change_location.calls[0].args[0]).toBe @nav.location

        if previous_location?
          for k,v of previous_location then do(k,v)->
            it "with previous location (argument 2) .#{k} === #{JSON.stringify v}", ->
              expect(@on_change_location.calls[0].args[1][k]).toEqual v
        else
          it "with previous location (argument 2) === undefined", ->
            expect(@on_change_location.calls[0].args[1]).toBe undefined

        it "with options (argument 3)", ->
          expect(@on_change_location.calls[0].args[2]).toEqual options

    it_sets_location_to = (location_attrs)->
      {tab,page,data,uid,has_referrer} = location_attrs
      data = data? and "\\?#{encodeData data}" or ''

      uid_regex =
        if uid? and typeof uid isnt 'function'
          uid
        else
          "\\d+"

      location_hash_rx = new RegExp "##{tab}/#{uid_regex}/#{page}#{data}"

      it "Sets window.location.hash to match #{location_hash_rx}",->
        expect(window.location.hash).toMatch location_hash_rx

      it "Sets Nav.location to #{JSON.stringify location_attrs}", ->
        for k,v of location_attrs when k isnt 'uid'
          expect(@nav.location[k]).toEqual v

        if uid?
          expected_uid_val = (typeof uid is 'function') and uid.call(this) or uid
          expect(@nav.location.uid).toEqual expected_uid_val

    mock_config = default_tab: DEFAULT_TAB = 'DefaultTab'

    beforeEach ->
      loadModule
        'Config': mock_config
        (@nav)=>
          Backbone.history?.stop()
          window.location.hash = ''
          @nav.on 'change:location', @on_change_location = jasmine.createSpy 'change:location handler'

          set_location_loaded_callback_obj = callback: (@location_loaded)=>
          spyOn(set_location_loaded_callback_obj, 'callback').andCallThrough()
          @set_location_loaded_callback = set_location_loaded_callback_obj.callback
          @cur_location_loaded = => @location_loaded @nav.location.uid

    afterEach ->
      Backbone.history?.stop()
      window.location.hash = ''

    describe '@start(set_location_loaded_callback)', ->

      describe 'when set_location_loaded_callback is an invalid value', ->

        for invalid_location_loader in ['string', 5, undefined, null] then do(invalid_location_loader)->
          it "(#{JSON.stringify invalid_location_loader}) throws exception", ->
            expect( => @nav.start invalid_location_loader).toThrow()


      when_initial_hash_is = (initial_location_hash, cb)->
        describe "when initial hash is '##{initial_location_hash}'", ->
          beforeEach ->
            window.location.hash = initial_location_hash
            @nav.start @set_location_loaded_callback
          cb()
          page: "DefaultTabPage"
          data: {}
          has_referrer: false

      when_initial_hash_is '', ->

        it_sets_location_to
          tab: DEFAULT_TAB
          page: 'DefaultTabPage'
        
        it_generates_location_uid()

        it_fires_change_location_with
          previous_location: undefined
          options:
            is_back: false
            is_switch_tab: true

      when_initial_hash_is "tab/page?#{encodeData key1:'val1'}", ->
        it_sets_location_to
          tab: 'tab'
          page: 'page'
          data: {key1: 'val1'}
          has_referrer: false

        it_generates_location_uid()

        it_fires_change_location_with
          previous_location: undefined
          options:
            is_back: false
            is_switch_tab: true

      when_initial_hash_is "tab/page", ->
        it_sets_location_to
          tab: 'tab'
          page: 'page'
          data: {}
          has_referrer: false

        it_generates_location_uid()

        it_fires_change_location_with
          previous_location: undefined
          options:
            is_back: false
            is_switch_tab: true

      when_initial_hash_is "tab/", ->
        it_sets_location_to
          tab: 'tab'
          page: 'tabPage'
          data: {}
          has_referrer: false
        
        it_generates_location_uid()

        it_fires_change_location_with
          previous_location: undefined
          options:
            is_back: false
            is_switch_tab: true

      describe 'when initial hash has a uid...', ->

        when_initial_hash_is "tab/1234/page?#{encodeData key1:'val1'}", ->
          it_sets_location_to
            tab: 'tab'
            page: 'page'
            data: {key1:'val1'}
            has_referrer: false
           
          it_generates_location_uid to_not_be: 1234

          it_fires_change_location_with
            previous_location: undefined
            options:
              is_back: false
              is_switch_tab: true

          describe "adds initial location to history", ->

            beforeEach ->
              @expecteduid = @nav.location.uid
              @cur_location_loaded()

              @nav.go_to page: 'page2'
              @cur_location_loaded()

              @nav.go_to_referrer @nav.location.uid

            it_sets_location_to
              tab: 'tab'
              page: 'page'
              data: {key1:'val1'}
              has_referrer: false
              uid: -> @expecteduid
            
        when_initial_hash_is "tab/1234", ->
          it_sets_location_to
            tab: 'tab'
            page: 'tabPage'
            data: {}
            has_referrer: false
          
          it_generates_location_uid to_not_be: 1234

          it_fires_change_location_with
            previous_location: undefined
            options:
              is_back: false
              is_switch_tab: true


    describe '@switch_tab', ->

      beforeEach ->
        @nav.start @set_location_loaded_callback
        @initial_location_uid = @nav.location.uid

      describe 'when loading another page, does nothing', ->

        beforeEach ->
          @nav.switch_tab 'wont_get_here'

        it_sets_location_to
          tab: DEFAULT_TAB
          page: 'DefaultTabPage'
          data: {}
          has_referrer: false
          uid: -> @initial_location_uid

        it "doesn't modify history", ->
          expect(@nav._tab_history('wont_get_here').length).toBe 0

      describe 'when NOT loading another page', ->

        beforeEach ->
          @cur_location_loaded()

        # describe "Don't go anywhere if set_location_loaded not called", ->
        #   @initial_location_uid = @nav.location.uid

        describe 'when given a tab previously visited', ->
          beforeEach ->
            @nav.go_to page: 'page1'
            @cur_location_loaded()
            @page1_uid = @nav.location.uid

            @nav.switch_tab 'tab2'
            @cur_location_loaded()

            @nav.on 'change:location', @on_change_location = jasmine.createSpy 'on change:location'
            @nav.switch_tab DEFAULT_TAB
            @cur_location_loaded()

          it_sets_location_to
            tab: DEFAULT_TAB
            page: 'page1'
            data: {}
            has_referrer: true
            uid: ->
              @page1_uid

          it_fires_change_location_with
            previous_location:
              tab: 'tab2'
              page: "tab2Page"
              data: {}
              has_referrer: false
            options:
              is_back: false
              is_switch_tab: true

        describe 'when given a tab NOT previously visited', ->
          beforeEach ->
            @nav.on 'change:location', @on_change_location = jasmine.createSpy 'on change:location'
            @nav.switch_tab 'tab1'

          it_sets_location_to
            tab: 'tab1'
            page: 'tab1Page'
            data: {}
            has_referrer: false
          
          it_generates_location_uid()

          it_fires_change_location_with
            previous_location:
              tab: DEFAULT_TAB
              page: "DefaultTabPage"
              data: {}
              has_referrer: false
            options:
              is_back: false
              is_switch_tab: true

    describe '@go_to_referrer', ->

      beforeEach ->
        @nav.start(@set_location_loaded_callback)
        @cur_location_loaded()

      describe 'when uid has NO referrer', ->
        beforeEach ->
          @nav.on 'change:location', @on_change_location = jasmine.createSpy 'on change:location'
          @nav.go_to_referrer(@nav.location.uid)

        it_sets_location_to
          tab: DEFAULT_TAB
          page: 'DefaultTabPage'
          data: {}
          has_referrer: false

        it "it doesn't fire change:location", ->
          expect(@on_change_location).not.toHaveBeenCalled()

      describe 'when uid has a referrer', ->

        beforeEach ->
          @nav.go_to page: 'page1'
          @initial_location_uid = @nav.location.uid
          @nav.on 'change:location', @on_change_location = jasmine.createSpy 'on change:location'

        describe 'when loading another page, does nothing', ->

          beforeEach ->
            @nav.go_to_referrer(@nav.location.uid)

          it_sets_location_to
            tab: DEFAULT_TAB
            page: 'page1'
            data: {}
            has_referrer: true
            uid: -> @initial_location_uid

          it "doesn't modify history", ->
            expect(@nav._tab_history(DEFAULT_TAB).length).toBe 2

        describe 'when NOT loading another page', ->

          beforeEach ->
            @cur_location_loaded()
            @nav.go_to_referrer(@nav.location.uid)

          it_sets_location_to
            tab: DEFAULT_TAB
            page: "#{DEFAULT_TAB}Page"
            data: {}
            has_referrer: false
          
          it_generates_location_uid()

          it_fires_change_location_with
            previous_location:
              tab: DEFAULT_TAB
              page: 'page1'
              data: {}
              has_referrer: true
            options:
              is_back: true
              is_switch_tab: false


    describe '@go_to', ->

      beforeEach ->
        @nav.start(@set_location_loaded_callback)
        @cur_location_loaded()
        @nav.on 'change:location', @on_change_location = jasmine.createSpy 'change:location handler'

      describe 'when no page is specified', ->
        it 'throws error', ->
          expect(=> @nav.go_to {}).toThrow()

      describe 'when tab specified is different then current tab', ->
        it 'throws error', ->
          expect(=> @nav.go_to tab: "#{DEFAULT_TAB}MakeItDifferent").toThrow()

      describe 'when tab specified is the same', ->
        beforeEach ->
          @nav.go_to tab: DEFAULT_TAB, page: "page1"
          @cur_location_loaded()

        it_sets_location_to
          tab: DEFAULT_TAB
          page: 'page1'
          data: {}
          has_referrer: true

        it_generates_location_uid()

        it_fires_change_location_with
          previous_location:
            tab: DEFAULT_TAB
            page: "#{DEFAULT_TAB}Page"
            data: {}
          options:
            is_back: false
            is_switch_tab: false
          

      describe 'with no tab history', ->
        beforeEach -> @nav.go_to page: 'page1'

        it_sets_location_to
          tab: DEFAULT_TAB
          page: 'page1'
          data: {}
          has_referrer: true

        it_generates_location_uid()

        it_fires_change_location_with
          previous_location:
            tab: DEFAULT_TAB
            page: "#{DEFAULT_TAB}Page"
            data: {}
          options:
            is_back: false
            is_switch_tab: false
        

      describe 'with tab history', ->
        beforeEach ->
          @nav.go_to page: 'page1'
          @cur_location_loaded()
          @nav.on 'change:location', @on_change_location = jasmine.createSpy 'change:location handler'
          @nav.go_to page: 'page2'
          @cur_location_loaded()

        it_sets_location_to
          tab: DEFAULT_TAB
          page: 'page2'
          data: {}
          has_referrer: true

        it_generates_location_uid()

        it_fires_change_location_with
          previous_location:
            tab: DEFAULT_TAB
            page: "page1"
            data: {}
            has_referrer: true
          options:
            is_back: false
            is_switch_tab: false
        
