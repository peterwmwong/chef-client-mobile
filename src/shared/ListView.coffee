define
  tag: '<ul>'
  
  render: (_)->
    if list = @options.list
      for {text,link,dividerText} in list when text or dividerText
        if text
          _ "<li data-navto='#{link}'>",
            _ 'div'
            text
        else # dividerText
          _ "li.divider", dividerText
  
  on:
    'resetActive': -> @$('li.active').removeClass('active').addClass('deactive')

    # TODO - Shouldn't css animation forword mode handle this?
    'webkitAnimationEnd li > div': -> @$('li.deactive').removeClass 'deactive'

    'click li': ({target})->
      @$('li.active').removeClass 'active'
      $(target)
        .closest('li')
        .addClass('active')
      