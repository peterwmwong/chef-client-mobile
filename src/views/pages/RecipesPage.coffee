define ['__','Nav'], (__,Nav)->

  initialize: ->
    @model.set 'title', 'Recipes'

  render_el: ->
    for i in [0..100]
      __ '.recipe', "Recipe #{i}"
