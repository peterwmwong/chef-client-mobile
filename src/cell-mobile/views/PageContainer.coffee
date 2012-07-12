define [
  'require'
  '__'
  'cell-mobile/Nav'
  './PageViewModel'
], (require, __, Nav, PageViewModel)->

  page_containers = {}
  get_page_container = (uid)-> page_containers[uid]
  setInterval (->
    get_page_container(Nav.location?.uid)?.refresh_scroller()
  ), 500

  Nav.on 'change:location', (cur,prev)->
    get_page_container(prev.uid)?.stop_scrolling() if prev

  initialize: ->
    @_prev_height = @_prev_container_height = -1
    page_containers[@options.location.uid] = this

  after_render: ->
    location = @options.location

    # Load page cell
    require ["cell!views/pages/#{location.page[0].toUpperCase()+location.page[1..]}"], (Page)=>
      @$el.append @$page = __.$ Page, ".page.active", model: PageViewModel.for_location location

      #TODO Move @scroller assignment to constructor
      @scroller = new iScroll @el

  stop_scrolling: ->
    @scroller?.scrollTo 0,0,0,true

  refresh_scroller: ->
    container_height = @$el.height()
    height = @$page?.height() or 0

    if container_height isnt @_prev_container_height or
        height isnt @_prev_height
      @_prev_container_height = container_height
      @_prev_height = height
      @scroller?.refresh()
