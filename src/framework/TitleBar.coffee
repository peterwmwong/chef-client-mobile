define ['framework/Nav'], (Nav)->

  render: (_)-> [
    _ '#backbutton', _ 'span', 'Back'
    _ '#titles',
      _ '#title'
      _ '#prevtitle'
    _ '#gobutton', _ 'span', 'Do It'
  ]

  afterRender: ->
    
    # Cache Title and Previous Title (for title "slide out" animation)
    animating = false
    $backbutton = @$ '#backbutton'
    $backbuttonText = @$ '#backbutton > span'
    $title = @$ '#title'
    $prevtitle = @$ '#prevtitle'
    pageHistoryLengthMap = {}

    $title.bind 'webkitAnimationEnd', ->
      $title.attr 'class', ''
      $prevtitle.attr 'class', ''
      animating = false

    Nav.bindAndCall 'change:current.title': ({cur,prev,data})=>
      isBack = data?.isBack
      prevTitle = prev
      $title.html cur or ''

      if not animating

        # true implement has history
        $backbutton.css 'visibility', Nav.canBack() and 'visible' or 'hidden'
        rev = isBack and '-reverse' or ''

        if prevTitle
          $prevtitle
            .html(prevTitle)
            .attr('class', 'animate headingOut'+rev)

        $title.attr 'class', 'animate headingIn'+rev
        animating = true

  on:
    'click #backbutton': -> Nav.goBack()