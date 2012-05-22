define [
  '__'
  'Nav'
  'cell!views/TitleBar'
  'cell!views/Content'
  'cell!views/TabBar'
], (__, Nav, TitleBar, Content, TabBar)->

  render_el: -> [
    __ TitleBar
    __ Content
    __ TabBar
  ]

  after_render: ->
    Nav.start()