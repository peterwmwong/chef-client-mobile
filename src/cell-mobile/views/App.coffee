# Prevent app from being dragged beyond bounds
document.addEventListener 'touchmove', (e)-> e.preventDefault()

# Hide that pesky address bar on start and whenever the orientation changes
hideAddressBar = ->
  doit = => window.scrollTo 0,1
  setTimeout doit, 500
  $(window).bind 'resize', doit

$(document.body).toggleClass (
  if navigator.userAgent.match /iP(od|ad|hone)/i
    if window.navigator.standalone
      'IOSFullScreen'
    else
      hideAddressBar()
      'IOS'
  else
    hideAddressBar()
    'ANDROID'
), true

define [
  '__'
  'cell-mobile/Nav'
  'cell!./TitleBar'
  'cell!./Content'
  'cell!./TabBar'
  'Preloads'
], (__, Nav, TitleBar, Content, TabBar)->

  render_el: -> [
    __ TitleBar
    __ Content, location_uid_loaded: (location_uid)=> @_done_loading_location_uid location_uid
    __ TabBar
  ]

  after_render: -> Nav.start (@_done_loading_location_uid)=>