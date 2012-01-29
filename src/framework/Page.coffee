define [
  'require'
  './Nav'
], (require,Nav)->

  tag: -> "<div data-cellpath='#{@model.page}'>"

  render: (_)->
    require ["cell!#{@model.page}"], (page)=>
      page::pageURI = Nav.pageHash
      @$el.append _ page, model: @model
      @pageRendered()

  pageRendered: ->
    # This shit is to compensate for Android not supporting
    # CSS3 animation-fill-mode: forwards
    active = true

    @model.bind 'deactivate': => active = false

    @model.bind 'activate': =>
      active = true
      @$el.css 'visibility', 'visible'

    @$el.bind 'webkitAnimationEnd', =>
      @$el.css 'visibility', 'hidden' if not active

    scroller = new iScroll @el
    @model.bindAndCall 'refreshScroller': -> scroller.refresh()
