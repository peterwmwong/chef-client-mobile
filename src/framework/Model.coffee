define ->
  changeEventRx = /^change:(.*)/
  unshiftIfNotPresent = (ls, handler)->
    for l in ls when l is handler then return
    ls.unshift handler

  class Model
    @pathObj: pathObj = (o,pathArray)->
      if o
        len = pathArray.length
        i=0
        while i<len and (o = o[pathArray[i++]])? then
        o

    @parsePropChange: parsePropChange = (type)-> changeEventRx.exec(type)?[1]?.split '.'
      
    constructor: (attrs)->
      @_ls = {}
      @[k]=v for k,v of attrs
      return

    set: (kvMap, eventData)->
      for k,v of kvMap when @[k] isnt v
        prev = @[k]
        try
          @trigger
            cur: (@[k] = v)
            prev: prev
            property: k
            type: "change:#{k}"
            data: eventData
      return

    trigger: (evOrType,data)->
      event = 
        if typeof evOrType is 'string'
          type: evOrType
          data: data
        else
          evOrType
      event.model = this

      if ls = @_ls[event.type]
        for l in ls
          try l event
      return
    
    bindAndCall: (binds)->
      self = this
      for type,handler of binds then do(handler)->

        if props = parsePropChange type
          lastPropIndex = props.length - 1
          targetProp = props[lastPropIndex]
          parentProps = props.slice 0, lastPropIndex

          rebind = (i, obj)->
            unshiftIfNotPresent (obj._ls["change:#{props[i]}"] ?= []), rebinders[i]

          obj = self
          rebinders = []
          for p,i in props then do(i)->
            rebinders[i] = (pev)->
              `for( var j=i, obj=pev.cur, pobj=pev.prev, parentObj = pev.model;
                     j++<lastPropIndex;
                     obj = (parentObj = obj) && obj[props[j]], pobj = pobj && pobj[props[j]] ){
                if( obj instanceof Model ){
                  rebind(j,obj);
                }
              }`

              ev =
                cur: obj
                prev: pobj
                property: targetProp
                type: "change:#{targetProp}"
                model: parentObj
                data: pev.data
              if i isnt lastPropIndex
                ev.parentEvent = pev

              handler ev

            if obj instanceof Model 
              rebind i, obj
              obj = obj[p]

          try
            handler
              cur: obj
              property: targetProp
              type: type
              model: pathObj(self, parentProps)
          catch e
            console.error e?.stack or e

        else
          unshiftIfNotPresent (self._ls[type] ?= []), handler
          try handler type: type, model: self
      return

    bind: (binds)->
      for type,handler of binds
        if props = parsePropChange type
          obj = this
          for p in props.slice(0,-1) when (v = obj[p]) instanceof Model
            bind = {}
            bind["change:#{p}"] = ({cur,prev})->
            v.bind bind
        unshiftIfNotPresent (@_ls[type] ?= []), handler
      return

    unbind: (binds)->
      for type,handler of binds
        if ls = @_ls[type]
          for l,i in ls when l is handler
            delete ls[i]
      return