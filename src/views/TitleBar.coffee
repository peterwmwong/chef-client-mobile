define ['__','Nav'], (__,Nav)->

  render_el: -> [
    @$backbutton = __.$ '#backbutton',
      __.$ 'span', 'Back'
    __ '#titles',
      @$title = __.$ '#title'
      @$prevTitle = __.$ '#prevtitle'
    __ '#gobutton',
      __ 'span', 'Do It'
  ]

  after_render: ->
    # Cache Title and Previous Title (for title "slide out" animation)
    animating = false

    @$title.bind 'webkitAnimationEnd', ->
      @$title.attr 'class', ''
      @$prevTitle.attr 'class', ''
      animating = false

    Nav.on 'change:title', (model,title,opts)=>
      @$title.html title

    Nav.on 'change', (model,opts)=>
      isBack = opts.isBack
      prevTitle = model.previous 'title'
      @$title.html model.attributes.title or 'Loading...'

      if not animating
        @$backbutton.css 'visibility', Nav.can_go_back() and 'visible' or 'hidden'
        rev = isBack and '-reverse' or ''

        if prevTitle
          @$prevTitle
            .html(prevTitle)
            .attr 'class', "animate headingOut#{rev}"

        @$title.attr 'class', "animate headingIn#{rev}"
        animating = true

  events:
    'click #backbutton': -> Nav.go_back()