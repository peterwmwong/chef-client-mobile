define ['__','cell-mobile/Nav'], (__,Nav)->

  initialize: ->
    @model.set_title "Recipe #{@model.location.data.id}"

  render_el: ->
    'Recipe Page'
