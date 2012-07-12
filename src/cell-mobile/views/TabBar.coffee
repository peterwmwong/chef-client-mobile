define ['__','cell-mobile/Nav'], (__, Nav)->
  tabs =
    recipes: 'Recipes'
    calendar: 'Calendar'
    pantry: 'Pantry'
    groceries: 'Groceries'

  tagName: 'ul'
  
  render_el: ->
    for tab, label of tabs
      __ 'li.tab', 'data-tab':tab,
        __ '.tab-label', label

  after_render: ->
    Nav.on 'change:location', (location,prev_location,{is_switch_tab})=>
      if is_switch_tab
        @$('li.active').removeClass 'active'
        @$("li[data-tab=#{location.tab}]").addClass 'active'

  events:
    'tap li.tab': ({target})->
      Nav.switch_tab $(target).closest('li.tab').data 'tab'
