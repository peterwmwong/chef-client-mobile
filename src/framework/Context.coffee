define [
  'require'
  './Model'
  './Nav'
  'cell!./Page'
], (require,Model,Nav,Page)->

  tag: -> "<div data-ctxid='#{@options.contextid}'>"

  afterRender: ->
    pageCache = {}
    curPage = null
    $el = @$el

    f = (bind = {})["change:current[context=#{@options.contextid}]"] = ({cur,prev,data:{isBack,isContextSwitch}})->
      if not isContextSwitch
        pageCell = pageCache[cur.hash]
        prevPageCell = prev and pageCache[prev.hash]

        # Hide previous Page
        if prevPageCell and isBack
          pageCache[prev.hash] = undefined
          prevPageCell.$el.bind 'webkitAnimationEnd', ->
            prevPageCell.$el.remove()

        # Load new Page
        if not pageCell
          pageCell = pageCache[cur.hash] = new Page {model: cur}
        pageCell.$el.prependTo $el

        pageInClass = 'Page'
        pageInClass += ' animate ' +
          if prev?.context is cur.context
            rev = isBack and '-reverse' or ''
            curPage?.$el.attr 'class', 'Page animate headingOut' + rev
            curPage?.model.trigger 'deactivate'
            'headingIn' + rev
          else
            'fadeIn'

        pageCell.$el.attr 'class', pageInClass
        (curPage = pageCell).model.trigger
          type: 'activate'
          isback: isBack

    Nav.bind bind
    f {
      cur: @options.initialHash
      data:
        isBack: false
    }
