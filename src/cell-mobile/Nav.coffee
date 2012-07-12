define ['Config'], (Config)->
  uid_salt = 0
  gen_uid = -> Date.now()*100 + (uid_salt++ % 100)
  default_tab_page = (tab)-> "#{tab}Page"

  _.extend (Nav = ->).prototype, Backbone.Events,
    _uid_to_location: {}
    _tab_histories: {}
    _isnt_first: false
    _loading_uid: undefined

    _tab_history: (tab)-> @_tab_histories[tab] or= []

    _set_location: (new_location,options)->
      if not @_loading_uid
        @_isnt_first = true
        @_loading_uid = new_location.uid
        prev_location = @location
        @trigger 'change:location',
          @location = new_location
          prev_location
          options
        @_syncLocation()

    _syncLocation: ->
      {tab,uid,page,data} = @location
      Backbone.history.navigate "##{tab}/#{uid}/#{page}?#{encodeURIComponent JSON.stringify data}"

    _go_back_to: (uid)->
      if not @_loading_uid and
          @_isnt_first and
          (tab = @_uid_to_location[uid]?.tab)

        for location, i in (tab_history = @_tab_history tab) when location.uid is uid
          # remove location uids
          for removed_location in tab_history.splice(i+1)
            @_uid_to_location[removed_location.uid] = undefined
          @_set_location location,
            is_back: true
            is_switch_tab: location.tab isnt @location.tab
          return true

      false

    go_to_referrer: (location_uid)->
      if @_uid_to_location[ referrer_uid = @_uid_to_location[location_uid]?._referrer_uid ]
        @_go_back_to referrer_uid

    switch_tab: (tab)->
      if not @_loading_uid
        tab_history = @_tab_history tab
        el = undefined
        if i = tab_history.length
          el = tab_history[i-1]
        else
          tab_history.push el =
            uid:  gen_uid()
            tab:  tab
            page: default_tab_page tab
            data: {}
            has_referrer: false
          @_uid_to_location[el.uid] = el
        @_set_location el, {is_back:false,is_switch_tab:true}
      return

    go_to: ({tab,page,data})->
      if not @_loading_uid
        throw "no page specified" if not page?
        isnt_first = @_isnt_first

        tab or= @location.tab
        if isnt_first and tab isnt @location.tab
          throw "Trying to go to another tab.  Use switch_tab instead."
        tab_history = @_tab_history tab

        tab_history.push el =
          uid:  gen_uid()
          tab:  tab
          page: page
          data: data or {}
          has_referrer: @location?
          _referrer_uid: @location?.uid
        @_uid_to_location[el.uid] = el

        if el
          @_set_location el,
            is_back:false
            is_switch_tab: not isnt_first
        return

    start: (set_location_loaded_callback)->
      set_location_loaded_callback (uid)=>
        @_loading_uid = undefined if uid? and @_loading_uid is uid

      model = this
      new (
        Backbone.Router.extend
          initialize: ->            
            @route  /.*/, '404', -> model.switch_tab Config.default_tab
            @route  ///
                    (\w+)     # tab
                    (/(\d+))? # uid
                    (/(\w+))? # page
                    (\?(.*))? # data
                    ///, 'tab_salt_page_pagedata',  (tab,_0,uid,_2,page,_3,data)->
              if not (uid and model._go_back_to Number uid)
                model.go_to
                  tab: tab
                  page: page or default_tab_page tab
                  data: data and (JSON.parse decodeURIComponent data)
            return
      )

      Backbone.history.start()
      return

  new Nav
