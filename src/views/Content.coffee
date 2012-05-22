define [
  'require'
  '__'
  'Nav'
], (require, __, Nav)->

  PageModel = Backbone.Model.extend()

  render_el: ->
    @$container = __.$ '.container'

  after_render: ->
    scroller = new iScroll @el
    prev_height = prev_container_height = -1

    setInterval (=>
      container_height = @$container.height()
      height = @$el.height()

      if container_height isnt prev_container_height or
          height isnt prev_height
        prev_container_height = container_height
        prev_height = height
        scroller.refresh()
    ), 500
    
    Nav.on 'change:page', (model,page,opts)=>
      require ["cell!views/pages/#{page[0].toUpperCase()+page[1..]}"], (PageCell)=>
        (model = new PageModel).on 'change:title', (model,title)=>
          Nav.set 'title', title if page is Nav.get 'page'

        @$container
          .empty()
          .append(__ PageCell, {model})