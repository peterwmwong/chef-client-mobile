define ['Config'], (Config)->

  encodeData = (data = {})-> "?#{encodeURIComponent JSON.stringify data}"
  salt_salt = 0
  gen_salt = -> Date.now()*10 + (salt_salt++ % 10)

  Nav = Backbone.Model.extend

    initialize: ->
      _tab_histories = {}
      @_tab_history = (tab = @attributes.tab)-> _tab_histories[tab] or= []

    _getLocationHash: ->
      {tab,_salt,page,data} = @attributes
      "##{tab}/#{_salt}/#{page}#{encodeData data}"

    can_go_back: -> @_tab_history().length > 1

    go_back: ->
      tab_history = @_tab_history()
      if tab_history.length > 1
        tab_history.splice -1
        @set tab_history.slice(-1)[0]
        Backbone.history.navigate @_getLocationHash()

    go: ({tab,_salt,page,data})->
      is_first = not @_is_first_go?
      @_is_first_go = true

      tab_history = @_tab_history tab or= @attributes.tab

      el = undefined
      is_back = false
      if _salt?
        if is_first
          el =
            tab: Config.default_tab
            page: "#{Config.default_tab}Page"
            data: {}
            _salt: gen_salt()
        else
          # Find previous entry
          for hel,i in tab_history when hel._salt is _salt
            tab_history.splice i+1
            el = hel
            is_back = true
            break

      else if page?
        tab_history.push el = {tab,data,page,_salt:gen_salt()}
      else if el = tab_history[tab_history.length-1]
      else
        tab_history.push el = {tab,data,page:"#{tab}Page",_salt:gen_salt()}

      @set el, {is_back} if el
      Backbone.history.navigate @_getLocationHash()
      return

    start: ->
      model = this
      new do-> Backbone.Router.extend
        initialize: ->            
          @route  /.*/, '404', ->
            model.go
              tab: Config.default_tab
              page: "#{Config.default_tab}Page"
              data: {}

          @route  ///
                  (\w+)     # tab
                  (/(\d+))? # _salt
                  (/(\w+))? # page
                  (\?(.*))? # data
                  ///, 'tab_salt_page_pagedata',  (tab,_0,_salt,_2,page,_3,data)->
            model.go
              _salt: _salt and Number _salt
              tab: tab
              page: page
              data:(data and JSON.parse decodeURIComponent data)
          return

      Backbone.history.start()
      return

  new Nav
