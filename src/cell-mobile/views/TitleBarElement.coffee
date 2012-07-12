define ['__','Nav'], (__,Nav)->

  render_title_bar: (_salt)->
    __ '.titlebar', 'data-_salt': _salt,
      __ ''


  render_el: -> [
    @$cur = __.$ '.current',
      @$cur_backbutton = __.$ '.backbutton',
        'Back'
        __ '.actual', 'Back'
      @$cur_title = __.$ '.title'
    @$prev = __.$ '.previous',
      @$prev_backbutton = __.$ '.backbutton',
        'Back'
        __ '.actual', 'Back'
      @$prev_title = __.$ '.title'
  ]

  after_render: ->
    animating = false
    cur_salt = Nav.attributes._salt

    @$cur.on 'webkitAnimationEnd', =>
      animating = false
      @$cur.toggleClass 'slide-in-fade slide-in-fade-reverse', false
      @$prev.toggleClass 'slide-out-fade slide-out-fade-reverse', false
      false

    Nav.on 'change:title', =>
      if cur_salt is Nav.attributes._salt
        @$cur_title.html Nav.attributes.title or 'Loading...'

    Nav.on 'change:_salt', (model,_salt,{changes, is_back})=>
      cur_salt = _salt
      prev_title = @$cur_title.html()
      prev_backbutton_display = @$cur_backbutton.css('display') is 'block'

      @$prev_backbutton.toggle prev_backbutton_display
      @$cur_backbutton.toggle Nav.can_go_back()

      if not animating and not changes.tab?
        animating = true
        @$cur.toggleClass("slide-in-fade#{is_back and '-reverse' or ''}", true)
        
        if prev_title
          @$prev.toggleClass("slide-out-fade#{is_back and '-reverse' or ''}", true)
          @$prev_title.html prev_title

      @$cur_title.html Nav.attributes.title or 'Loading...'

  events:
    'click .backbutton': -> Nav.go_back()

