define [
  '__'
  'cell-mobile/Nav'
  './PageViewModel'
], (__, Nav, PageViewModel)->

  render_el: -> [
    if @options.location.has_referrer
      __ '.backbutton',
        'Back'
        __ '.actual', 'Back'
    @$title = __.$ '.title'
  ]

  after_render: ->
    PageViewModel
      .for_location(@options.location)
      .on 'change:title', (title)=> @$title.html title

  events:
    'tap .backbutton': ->
      Nav.go_to_referrer @options.location.uid
