define ['AppConfig','./Nav'], (AppConfig,Nav)->

  tag: '<ul>'

  render: (_)-> [
    for ctxid,{text} of AppConfig.contexts
      _ "<li data-ctxid='#{ctxid}'>", text or ctxid
  ]
    
  on:
    'click li': ({target})->
      $('li.active').removeClass 'active'
      Nav.switchContext $(target).addClass('active').data('ctxid')
