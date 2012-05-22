define ['__','Nav'], (__, Nav)->
  tabs =
    recipes: 'Recipes'
    calendar: 'Calendar'
    pantry: 'Pantry'
    groceries: 'Groceries'

  tagName: 'ul'
  
  render_el: ->
    for tab, label of tabs
      __ 'li.tab', 'data-tab':tab,
        __ 'div', label

  after_render: ->
    Nav.on 'change:tab', (model,newTab)=>
      @$('li.active').removeClass 'active'
      @$("li[data-tab=#{newTab}]").addClass 'active'

  events:
    'click li.tab': ({target})->
      Nav.go tab: $(target).closest('.tab').data 'tab'
