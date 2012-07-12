define [
  '__'
  'cell-mobile/Nav'
  'cell!./PageTitleBar'
], (__, Nav, PageTitleBar)->

  after_render: ->
    Nav.on 'change:location', (cur_location,prev_location,{is_back,is_switch_tab})=>
      # Tab change?
      if is_switch_tab
        # Just show new tab
        @$tab(prev_location.tab).removeClass 'active' if prev_location
        @$tab(cur_location.tab).addClass 'active'

        @$page_title_bar(cur_location)
          .addClass('active')
          .removeClass('slide-out-fade slide-out-fade-reverse slide-in-fade slide-in-fade-reverse')

      else
        # Fade out current PageTitleBar
        if prev_location
          ($prev_page_title_bar = @$page_title_bar prev_location)
            .removeClass('active slide-in-fade slide-in-fade-reverse')
            .addClass("slide-out-fade#{is_back and '-reverse' or ''}")

        # Fade in new PageTitleBar
        @$page_title_bar(cur_location)
          .removeClass('slide-out-fade slide-out-fade-reverse')
          .addClass("active slide-in-fade#{is_back and '-reverse' or ''}")
          
  $page_title_bar: (location)->
    $page_title_bar =
      @$el
        .children(".tab[data-tab='#{location.tab}']")
        .children(".PageTitleBar[data-location-uid='#{location.uid}']")

    if $page_title_bar[0]
      $page_title_bar
    else
      __.$(PageTitleBar, location: location)
        .attr('data-location-uid', location.uid)
        .appendTo @$tab(location.tab)

  $tab: (tab)->
    if ($tab = @$el.children ".tab[data-tab='#{tab}']")[0]
      $tab
    else
      __.$('.tab', 'data-tab': tab).appendTo @$el

  events: 
    'webkitAnimationEnd .tab > .PageTitleBar.slide-out-fade,.PageTitleBar.slide-out-fade-reverse': ({target})->
      $(target).removeClass('slide-out-fade slide-out-fade-reverse')

    'webkitAnimationEnd .tab > .PageTitleBar.slide-out-fade-reverse': ({target})->
      $(target).remove()

