define ->

  ({loadModule})->
    encodeData = (data)-> encodeURIComponent JSON.stringify data

    it_generates_salt = ({not_be} = {})->
      it "Generates nav.attribute._salt", ->
        salt = @nav.attributes._salt

        expect(typeof salt is 'number').toBe true
        expect(salt).toBeGreaterThan 0

        if not_be?
          expect(salt).not.toBe not_be

    it_goes_to = (nav_attrs,add_its)->
      {tab,page,data,_salt} = nav_attrs

      data =
        if not data? then ''
        else "\\?#{encodeData data}"

      _salt or= '\\d+'

      location_hash_rx = new RegExp "##{tab}/#{_salt}/#{page}#{data}"

      it "Sets window.location.hash to match #{location_hash_rx}",->
        expect(window.location.hash).toMatch location_hash_rx

      it "Sets nav attributes to #{JSON.stringify nav_attrs}", ->
        for k,v in nav_attrs
          expect(@nav.attributes[k]).toEqual v

      add_its?()


    beforeEach ->
      loadModule
        'Config': (@mock_config = default_tab: 'DefaultTab')
        (@nav)=>
          Backbone.history?.stop()
          window.location.hash = ""

    afterEach ->
      Backbone.history?.stop()
      window.location.hash = ""

    describe '@can_go_back', ->
      beforeEach -> @nav.start()

      describe 'when no tab history', ->
        it 'is false', ->
          expect(@nav.can_go_back()).toBe false

      describe 'when tab history', ->
        beforeEach ->
          @nav.go tab: @mock_config.default_tab, page: 'page1'

        it 'is true', -> 
          expect(@nav.can_go_back()).toBe true

    describe '@go_back', ->
      beforeEach ->
        @nav.start()

      describe 'when no tab history', ->
        beforeEach ->
          @nav.go_back()

        it_goes_to
          tab: 'DefaultTab'
          page: 'DefaultTabPage'
          data: {}

      describe 'when tab history', ->
        beforeEach ->
          @nav.go tab: @mock_config.default_tab, page: 'page1'
          @nav.go_back()

        it_goes_to
          tab: 'DefaultTab'
          page: 'DefaultTabPage'
          data: {}


    describe '@start', ->

      describe_start = (initial_location_hash, cb)->
        describe "when location.hash is '##{initial_location_hash}'", ->
          beforeEach ->
            window.location.hash = initial_location_hash
            @nav.start()
          cb()

      describe_start '', ->
        it_goes_to
          tab: 'DefaultTab'
          page: "DefaultTabPage"
          data: {}
          -> it_generates_salt()

      describe_start "tab/page?#{encodeData key1:'val1'}", ->
        it_goes_to
          tab: 'tab'
          page: 'page'
          data: {key1: 'val1'}
          -> it_generates_salt()

      describe_start "tab/page", ->
        it_goes_to
          tab: 'tab'
          page: 'page'
          data: {}
          -> it_generates_salt()

      describe_start "tab/", ->
        it_goes_to
          tab: 'tab'
          page: 'tabPage'
          data: {}
          -> it_generates_salt()

      describe 'has a salt', ->

        describe_start "tab/1234/page?#{encodeData key1:'val1'}", ->
          it_goes_to
            tab: 'DefaultTab'
            page: 'DefaultTabPage'
            data: {}
            -> it_generates_salt not_be: 1234

        describe_start "tab/1234", ->
          it_goes_to
            tab: 'DefaultTab'
            page: 'DefaultTabPage'
            data: {}
            -> it_generates_salt not_be: 1234


    describe '@go', ->

      beforeEach ->
        window.location.hash = ''
        @_nav_events = []
        @nav.on 'change', (args...)=> @_nav_events.push args
        @nav.start()

      it_emits_is_back_change_event = ->
        it "emits is_back change event", ->
          expect(_.any @_nav_events, ([evt,{is_back}])-> is_back).toBe true

      describe 'throws error on a bad argument', ->
        it 'no tab or page', ->
          expect(=> @nav.go arg).toThrow()

      describe 'with no tab history', ->
        # TODO

      describe 'with tab history', ->

        beforeEach ->
          @_history =
            tab1: []
            tab2: []

          @nav.go
            tab: 'tab1'
            page: 'page11'
            data: {key11: 'val11'}
          @_history[@nav.attributes.tab].push _.clone @nav.attributes

          @nav.go 
            tab: 'tab2'
            page: 'page21'
            data: {key21: 'val21'}
          @_history[@nav.attributes.tab].push _.clone @nav.attributes

          @nav.go
            tab: 'tab2'
            page: 'page22'
            data: {key22: 'val22'}
          @_history[@nav.attributes.tab].push _.clone @nav.attributes

          @nav.go
            tab: 'tab2'
            page: 'page23'
            data: {key23: 'val23'}
          @_history[@nav.attributes.tab].push _.clone @nav.attributes

          @nav.go
            tab: 'tab1'
            page: 'page12'
            data: {key12: 'val12'}
          @_history[@nav.attributes.tab].push _.clone @nav.attributes


        describe 'when tab specified', ->

          describe "with previous _salt in tab's history", ->
            beforeEach ->
              @nav.go
                tab: 'tab2'
                _salt: @_history.tab2[0]._salt

            it_goes_to
              tab: 'tab2'
              page: 'page21'
              data: {key21: 'val21'}
              ->
                it_generates_salt()
                it_emits_is_back_change_event()


          describe "with bogus _salt (not in tab's history), goes nowhere", ->
            beforeEach ->
              @nav.go
                tab: 'tab2'
                _salt: 777777777 # bogus _salt

            it_goes_to 
              tab: 'tab1'
              page: 'page12'
              data: {key12: 'val12'}
              -> it 'has salt from history', ->
                expect(@nav.attributes._salt).toBe @_history.tab1[1]._salt

          
          describe "with nothing else specified, goes to last page in tab's history", ->
            beforeEach ->
              debugger
              @nav.go tab: 'tab2'

            it_goes_to 
              tab: 'tab2'
              page: 'page23'
              data: {key23: 'val23'}
              -> it 'has correct salt', ->
                expect(@nav.attributes._salt).toBe @_history.tab2[@_history.tab2.length-1]._salt


          describe "goes to page in tab", ->
            beforeEach ->
              @nav.go
                tab: 'tab2'
                page: 'page24'
                data: {key24: 'val24'}

            it_goes_to
              tab: 'tab2'
              page: 'page24'
              data: {key24: 'val24'}
              -> it_generates_salt()

        describe 'when no tab specified', ->

          describe "go to previous _salt in current tab's history", ->
            beforeEach ->
              @nav.go _salt: @_history.tab1[0]._salt

            it_goes_to
              tab: 'tab1'
              page: 'page11'
              data: {key11: 'val11'}
              ->
                it_generates_salt()
                it_emits_is_back_change_event()

          describe "goes nowhere when no matching _salt in current tab's history", ->
            beforeEach ->
              @nav.go _salt: 777777777 # bogus _salt

            it_goes_to 
              tab: 'tab1'
              page: 'page12'
              data: {key12: 'val12'}
              -> it 'has salt from history', ->
                expect(@nav.attributes._salt).toBe @_history.tab1[1]._salt 

          describe "goes to page in current tab", ->
            beforeEach ->
              @nav.go page: 'page13', data: {key13: 'val13'}

            it_goes_to
              tab: 'tab1'
              page: 'page13'
              data: {key13: 'val13'}
              -> it_generates_salt()
