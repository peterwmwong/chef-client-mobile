# Prevent app from being dragged beyond bounds
document.addEventListener 'touchmove', (e)-> e.preventDefault()

# Hide that pesky address bar on start and whenever the orientation changes
hideAddressBar = ->
  doScroll = 0
  setTimeout (hideIOSAddressBar = =>
    if ++doScroll is 1
      window.scrollTo 0,1
  ), 500
  $(window).bind 'resize', ->
    doScroll = 0
    hideIOSAddressBar()

$('body').attr 'class',
  if (ua = navigator.userAgent).match(/iPhone/i) or ua.match(/iPod/i) or ua.match(/iPad/i)
    if window.navigator.standalone
      'IOSFullScreen'
    else
      hideAddressBar()
      'IOS'
  else
    hideAddressBar()
    'ANDROID'


define [
  './Nav'
  './Model'
  './ContextModel'
  'cell!./Context'
  'cell!./ContextNavBar'
  'cell!./TitleBar'
], (Nav,Model,ContextModel,Context,ContextNavBar,TitleBar)->
  
  # Cache of all previously loaded pages
  ctxCache = {}

  render: (_)-> [
    _ TitleBar
    _ '#content'
    _ ContextNavBar
  ]

  afterRender: ->

    # Cache content jQuery object, for appending Contexts to
    $content = @$ '#content'

    Nav.bindAndCall 'change:current': ({cur,prev,data})=>
      isContextSwitch =
        if not data
          true
        else
          data?.isContextSwitch

      if isContextSwitch
        if not (ctxCell = ctxCache[cur.context])
          ctxCell = ctxCache[cur.context] = new Context
            contextid: cur.context
            initialHash: cur
          $content.append ctxCell.$el

        ctxCell.$el.toggle true
        if prevCtxId = prev?.context
          ctxCache[prevCtxId]?.$el.toggle false
        
        if ctxCell
          @$('#content > .activeTab').removeClass 'activeTab'
          ctxCell.$el.toggle(true).toggleClass('activeTab', true)
        else
          console?.log? "Could not switch to context = '#{cur.context}'"
      return

  on:
    "click [data-navto]": ({target})->
      location.hash = $(target).closest('[data-navto]').data('navto')