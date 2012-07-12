define [
  '__'
  'cell-mobile/Nav'
  'cell!./PageContainer'
], ( __, Nav, PageContainer)->

  after_render: ->
    Nav.on 'change:location', (cur_location, prev_location, {is_back, is_switch_tab})=>
      # Tab change?
      if is_switch_tab
        # Just show new tab
        @$tab(prev_location.tab).removeClass 'active' if prev_location
        @$tab(cur_location.tab).addClass 'active'

        @$page(cur_location)
          .addClass('active')
          .removeClass('page-slide-out page-slide-out-reverse page-slide-in page-slide-in-reverse')

        @options.location_uid_loaded cur_location.uid

      else
        # Fade out current PageContainer
        if prev_location
          ($prev_page = @$page(prev_location))
            .removeClass('active page-slide-in page-slide-in-reverse')
            .addClass("page-slide-out#{is_back and '-reverse' or ''}")

        # Fade in new PageContainer
        @$page(cur_location)
          .removeClass('page-slide-out page-slide-out-reverse')
          .addClass("active page-slide-in#{is_back and '-reverse' or ''}")

  $page: (location)->
    $page =
      @$el
        .children(".tab[data-tab='#{location.tab}']")
        .children(".PageContainer[data-location-uid='#{location.uid}']")

    if $page[0]
      $page
    else
      __.$(PageContainer, location: location)
        .attr('data-location-uid', location.uid)
        .appendTo @$tab(location.tab)

  $tab: (tab)->
    if ($tab = @$el.children(".tab[data-tab='#{tab}']"))[0]
      $tab
    else
      __.$('.tab', 'data-tab':tab).appendTo @$el

  events: 
    'webkitAnimationEnd .tab > .PageContainer.active': ({target})->
      @options.location_uid_loaded Number $(target).data('location-uid')

    'webkitAnimationEnd .tab > .PageContainer.page-slide-out,.PageContainer.page-slide-out-reverse': ({target})->
      $(target).removeClass('page-slide-out page-slide-out-reverse')

    'webkitAnimationEnd .tab > .PageContainer.page-slide-out-reverse': ({target})->
      $(target).remove()



