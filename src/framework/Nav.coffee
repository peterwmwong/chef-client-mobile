define [
  'AppConfig'
  'HashDelegate'
  './Model'
], (AppConfig, HashDelegate, Model)->

  hashRx =
    /// ^
     \# ([^!^?]+)    # #context
    (!  ([^?]+)   )? # !p/a/g/e
    (\? (.+)      )? # ?d=a&t=a
    ///

  _fixedHash = false

  Nav = new Model

    _toHash: _toHash = ({context,page,data})->
      ctx = (AppConfig.contexts[context] and context) or AppConfig.defaultContext
      "##{ctx}!#{page or AppConfig.contexts[ctx].defaultPagePath}#{data and "?#{encodeURIComponent JSON.stringify data}" or ''}"

    _parseHash: _parseHash = (hash)->
      result = hashRx.exec hash

      hash: hash
      context: context = ((ctxid = result?[1]) and AppConfig.contexts[ctxid] and ctxid) or AppConfig.defaultContext
      page: ((page = result?[3]) and (page.substr(-1) isnt '/') and page) or AppConfig.contexts[context].defaultPagePath
      data: (jsondata = result?[5]) and JSON.parse decodeURIComponent jsondata

    current: do->
      hash = _parseHash HashDelegate.get()
      if hash.hash isnt (finalHashString = _toHash hash)
        hash.hash = finalHashString
        _fixedHash = true
      new Model hash

    canBack: -> contextHists[Nav.current.context]?.length > 1
    goBack: -> HashDelegate.set h if h = contextHists[Nav.current.context][1]?.hash
    pageHash: (page,data)-> _toHash {context:Nav.current.context,page,data}
    switchContext: (ctxid)->
      if typeof ctxid is 'string' and (hist = contextHists[ctxid]) and Nav.current.context isnt ctxid
        # Use previous visit or create new
        HashDelegate.set _toHash hist[0] or {context: ctxid, page: AppConfig.contexts[ctxid].defaultPage}

  contextHists = {}
  contextHists[ctx] = [] for ctx of AppConfig.contexts
  contextHists[Nav.current.context].push Nav.current

  Nav.bind
    'change:current': (e)->
      event = {}
      event[k] = v for k,v of e
      event.type = "change:current[context=#{e.cur.context}]"
      Nav.trigger event

  HashDelegate.onChange ->
    if _fixedHash then _fixedHash = false
    else
      h = _parseHash HashDelegate.get()
      ctxHist = contextHists[h.context]

      # Context Switch
      if Nav.current.context isnt h.context
        Nav.set {
          current: 
            if ctxHist.length then ctxHist[0]
            else
              ctxHist.unshift h = new Model h
              h
        }, {isBack:false,isContextSwitch:true}

      # Back button (going back, not initiated by us)
      else if h.hash is ctxHist[1]?.hash
        h = ctxHist[1]
        ctxHist.shift()
        Nav.set {current: h}, {isBack:true,isContextSwitch:false}

      # First time or Going forward
      else if ctxHist.length is 0 or ctxHist[0].hash isnt h.hash
        ctxHist.unshift h = new Model h
        Nav.set {current:h}, {isBack:false,isContextSwitch:false}
    return

  HashDelegate.set Nav.current.hash if _fixedHash
  Nav