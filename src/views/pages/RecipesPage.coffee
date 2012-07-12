define ['__','cell-mobile/Nav'], (__,Nav)->

  initialize: ->
    @model.set_title 'Recipes'

  render_el: ->
    for i in [0..100]
      __ 'a.recipe', 'data-recipeid': i,
        "Recipe ##{i}"

  events:
    'tap a.recipe': ({target})->
      if (id = $(target).closest('a.recipe').data('recipeid'))?
        Nav.go_to
          page: "RecipePage"
          data: {id}
