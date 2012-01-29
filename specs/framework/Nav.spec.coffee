define [
  'SpecHelpers'
  '/src/framework/Model.js'
], ({spyOnAll},Model)->
  encodeJSONForURI = (data)-> encodeURIComponent JSON.stringify data

  ({mockModules,loadModule,getRequire})->
        
    describe "When the hash is initially ''", ->
      mHashDelegate = null
      mAppConfig =
        defaultContext: 'ctx1'
        contexts:
          ctx1: 
            defaultPagePath:'path1'
          ctx2: 
            defaultPagePath:'path2'
      Nav = null
      NavOnChange = null
      currentHash = undefined
      triggerOnChange = undefined

      beforeEach ->
        triggerOnChange = undefined
        currentHash = ''

        mockModules
          'framework/Model': Model
          AppConfig: mAppConfig
          HashDelegate:
            spyOnAll mHashDelegate =
              get: -> currentHash
              onChange: (cb)-> NavOnChange = cb
              set: (newHash)->
                triggerOnChange = ->
                  NavOnChange currentHash = newHash
        loadModule (module)-> Nav = module
      
      it 'Nav.current set to defaultContext, defaultPagePath (of defaultContext), and undefined for data', ->
        expect(Nav.current).toEqual new Model
          hash: "##{mAppConfig.defaultContext}!#{mAppConfig.contexts[mAppConfig.defaultContext].defaultPagePath}"
          context: mAppConfig.defaultContext
          page: mAppConfig.contexts[mAppConfig.defaultContext].defaultPagePath

      it 'HashDelegate.set() called with "##{defaultContext}!#{defaultPagePath}"', ->
        expect(mHashDelegate.set).toHaveBeenCalledWith "##{mAppConfig.defaultContext}!#{mAppConfig.contexts[mAppConfig.defaultContext].defaultPagePath}"

      describe 'and then HashDelegate.onChange() is called in response to setting the default hash',  ->
        binds = undefined

        beforeEach ->
          Nav.bind spyOnAll binds =
            'change:current': ->
            'change:current[context=ctx1]': ->
          currentHash = Nav.current
          triggerOnChange()

        it 'does NOT call any bindings', ->
          expect(binds['change:current']).wasNotCalled()
          expect(binds['change:current[context=ctx1]']).wasNotCalled()
    
    describe "When the hash is initially #{mInitialHash = '#ctx1!a/b-c/d_ef/_gh/-ijk?'+encodeJSONForURI w:'val',x:0,y:'Krusty the Clown',z:'Sam I Am'}", do(mInitialHash)-> ->
      mHashDelegate = null
      mAppConfig =
        defaultContext: 'ctx1'
        contexts:
          ctx1: 
            defaultPagePath:'path1'
          ctx2: 
            defaultPagePath:'path2'
      Nav = null
      NavOnChange = null
      currentHash = undefined

      beforeEach ->
        currentHash = mInitialHash
        mockModules
          'framework/Model': Model
          AppConfig: mAppConfig
          HashDelegate:
            spyOnAll mHashDelegate =
              get: -> currentHash
              onChange: (cb)-> NavOnChange = cb
              set: (newHash)->
                NavOnChange currentHash = newHash
        loadModule (module)->
          Nav = module
        
      it 'is an instanceof Model', ->
        expect(Nav instanceof Model).toBe true

      #----------------------------------------------------------------------
      describe 'Nav.canBack()', ->

        it 'returns true when current context history is <= 1', ->
          mHashDelegate.set Nav.pageHash 'test1'
          expect(Nav.canBack()).toBe true

        it 'returns true when current context history is > 1', ->
          expect(Nav.canBack()).toBe false
          mHashDelegate.set Nav.pageHash 'test1'
          expect(Nav.canBack()).toBe true
          Nav.goBack()
          expect(Nav.canBack()).toBe false


      it 'registers a callback function with HashDelegate.onChange', ->
        expect(typeof NavOnChange is 'function').toBe true

      it 'Nav.current set to parsed initial hash (HashDelegate.get())', ->
        expect(Nav.current).toEqual new Model
          hash: mInitialHash
          context: 'ctx1'
          page: 'a/b-c/d_ef/_gh/-ijk'
          data:
            w: 'val'
            x: 0
            y: 'Krusty the Clown'
            z: 'Sam I Am'
      

      #----------------------------------------------------------------------
      describe 'Nav.goBack()', ->

        it 'does not call HashDelegate.set() if context history is empty', ->
          Nav.goBack()
          expect(mHashDelegate.set.argsForCall.length).toBe 0

        it 'calls HashDelegate.set() with previous hash for context', ->
          mHashDelegate.set Nav.pageHash 'test'
          expect(mHashDelegate.get()).toBe '#ctx1!test'
          
          mHashDelegate.set Nav.pageHash 'test2'
          expect(mHashDelegate.get()).toBe '#ctx1!test2'

          Nav.goBack()
          expect(mHashDelegate.get()).toBe '#ctx1!test'

          Nav.goBack()
          expect(mHashDelegate.get()).toBe mInitialHash

          mHashDelegate.set.reset()
          Nav.goBack()
          expect(mHashDelegate.get()).toBe mInitialHash
          expect(mHashDelegate.set).not.toHaveBeenCalled()


      #----------------------------------------------------------------------
      describe 'Nav.pageHash(page:string,data:object)', ->
        it 'When page not specified, "##{Nav.current.context}!#{defaultPagePath}', ->
          expect(Nav.pageHash()).toBe "##{ctx = Nav.current.context}!#{mAppConfig.contexts[ctx].defaultPagePath}"

        it '"#{Nav.current.context}!#{page}?#{encodeURIComponent JSON.stringify data}"', ->
          expect(Nav.pageHash 'a/b/c', d:'e', f:'g').toBe "##{Nav.current.context}!a/b/c?#{encodeJSONForURI d:'e', f:'g'}"

      #----------------------------------------------------------------------
      describe 'Nav._parseHash(hash:string)', ->

        itParses = (hashes, expected)->
          for h in hashes then do(h)->
            e = {}
            for k,v of expected
              e[k] = v
            e.hash ?= h
            it "parses '#{h}' to #{JSON.stringify e}", -> expect(Nav._parseHash h).toEqual e

        itParses [
          ''
          '#'
          '#!'
          '#?'
          '#!?'
          '#!/'
          '#!/?'
          '#!ignore/me?because=no&context=specified'
        ],
          context: 'ctx1'
          page: 'path1'


        itParses [
          '#/'
          '#/!/'
          '#/!ignore-me-cause-Im-a-directory/'
        ], 
          context: 'ctx1'
          page: 'path1'


        itParses [
          "#ctx1"
          '#ctx1!'
          '#ctx1!/?'
          '#badContextThatWillBeDefaulted!/?'
        ],
          context: 'ctx1'
          page: 'path1'


        itParses [
          '#ctx2!a/b-c/d_ef/_gh/-ijk'
          '#ctx2!a/b-c/d_ef/_gh/-ijk?'
        ],
          context: 'ctx2'
          page: 'a/b-c/d_ef/_gh/-ijk'


        itParses ["#ctx1!a/b-c/d_ef/_gh/-ijk?#{encodeJSONForURI w:'val', x:0, y:'Krusty the Clown', z:'Sam I Am'}"],
          context: 'ctx1'
          page: 'a/b-c/d_ef/_gh/-ijk'
          data:
            w: 'val'
            x: 0
            y: 'Krusty the Clown'
            z: 'Sam I Am'
    
      
      #----------------------------------------------------------------------
      describe 'Nav._toHash({context,page,data})', ->

        it '"##{AppConfig.defaultContext}!#{defaultPagePath}, when passed unknown OR no context', ->
          expect(Nav._toHash {}).toBe "##{ctx = mAppConfig.defaultContext}!#{mAppConfig.contexts[ctx].defaultPagePath}"

        it 'uses AppConfig.contexts[context].defaultPagePath when given unknown OR no page', ->
          expect(Nav._toHash {context: 'ctx1'}).toBe "#ctx1!#{mAppConfig.contexts.ctx1.defaultPagePath}"
          expect(Nav._toHash {context: 'ctx1', data: {a:'b'}}).toBe "#ctx1!#{mAppConfig.contexts.ctx1.defaultPagePath}?#{encodeJSONForURI a:'b'}"

        it 'context!page?data', ->
          input =
            context: 'ctx2'
            page: 'a/b/c'
            data: data =
              d:'e'
              f:'g'
          expect(Nav._toHash input).toBe "#ctx2!a/b/c?#{encodeJSONForURI data}"


      #----------------------------------------------------------------------
      describe 'HashDelegate.onChange handler', ->
        hash = '#ctx1!testpage?'+encodeJSONForURI a:'b', c:'d'
        binds = null

        beforeEach ->
          currentHash = hash
          Nav.bind spyOnAll binds =
            'change:current': ->
            'change:current[context=ctx1]': ->

        it "When the hash is the same, doesn't update or trigger 'change:current'/'change:current[context=ctx1]' events", ->
          NavOnChange()
          expect(binds['change:current'].argsForCall.length).toBe 1

          NavOnChange() # No Change in Hash
          expect(binds['change:current'].argsForCall.length).toBe 1
          expect(binds['change:current[context=ctx1]'].argsForCall.length).toBe 1


        #----------------------------------------------------------------------
        describe '[Back button] When the hash changes to the previous hash in the context history', ->

          prevHash = undefined

          beforeEach ->
            prevHash = Nav.current
            currentHash = hash
            NavOnChange() # Go somewhere
            currentHash = mInitialHash
            NavOnChange() # Go back

          it 'updates Nav.current', ->
            expect(Nav.current).toBe prevHash

          it 'removes hash from context history', ->
            expect(Nav.canBack()).toBe false

          it 'triggers "change:current" event, with {data:{isBack:true}}', ->
            call = binds['change:current']
            expect(call).toHaveBeenCalledWith
              cur: prevHash
              prev: new Model
                hash: hash
                context: 'ctx1'
                page: 'testpage'
                data:
                  a: 'b'
                  c: 'd'
              model: Nav
              property: 'current'
              type: 'change:current'
              data:
                isBack: true
                isContextSwitch: false

          it 'triggers "change:current[context=ctx1]" event, with {data:{isBack:true}}', ->
            expect(binds['change:current[context=ctx1]']).toHaveBeenCalledWith
              cur: prevHash
              prev: new Model
                hash: hash
                context: 'ctx1'
                page: 'testpage'
                data:
                  a:'b'
                  c:'d'
              model: Nav
              property: 'current'
              type: 'change:current[context=ctx1]'
              data:
                isBack: true
                isContextSwitch: false


        #----------------------------------------------------------------------
        describe 'When the hash changes', ->

          beforeEach ->
            NavOnChange()

          it 'updates Nav.current', ->
            expect(Nav.current).toEqual new Model
                hash: hash
                context: 'ctx1'
                page: 'testpage'
                data:
                  a:'b'
                  c:'d'
          
          it 'triggers "change:current" event', ->
            expect(binds['change:current'].argsForCall[0][0]).toEqual
              cur: new Model
                hash: hash
                context: 'ctx1'
                page: 'testpage'
                data:
                  a:'b'
                  c:'d'
              prev: new Model
                hash: mInitialHash
                context: 'ctx1'
                page: 'a/b-c/d_ef/_gh/-ijk'
                data:
                  w: 'val'
                  x: 0
                  y: 'Krusty the Clown'
                  z: 'Sam I Am'
              model: Nav
              property: 'current'
              type: 'change:current'
              data:
                isBack: false
                isContextSwitch: false
          
          it 'triggers "change:current[context=ctx1]" event', ->
            expect(binds['change:current[context=ctx1]']).toHaveBeenCalledWith
              cur: new Model
                hash: hash
                context: 'ctx1'
                page: 'testpage'
                data:
                  a:'b'
                  c:'d'
              prev: new Model
                hash: mInitialHash
                context: 'ctx1'
                page: 'a/b-c/d_ef/_gh/-ijk'
                data:
                  w: 'val'
                  x: 0
                  y: 'Krusty the Clown'
                  z: 'Sam I Am'
              model: Nav
              property: 'current'
              type: 'change:current[context=ctx1]'
              data:
                isBack: false
                isContextSwitch: false


      #----------------------------------------------------------------------
      describe 'Nav.switchContext(contextId:string)', ->
        binds = null

        beforeEach ->
          Nav.bind spyOnAll binds =
            'change:current': ->
            'change:current[context=ctx1]': ->
            'change:current[context=ctx2]': ->

        it 'does nothing when contextId is not valid context (not part of AppConfig.contexts)', ->
          Nav.switchContext 'bogus context'
          expect(mHashDelegate.set).not.toHaveBeenCalled()
          expect(binds['change:current']).not.toHaveBeenCalled()
          expect(binds['change:current[context=ctx1]']).not.toHaveBeenCalled()

        it 'does nothing when contextId is not a string, undefined, or null', ->
          Nav.switchContext undefined
          Nav.switchContext null
          Nav.switchContext 5
          Nav.switchContext {}
          expect(mHashDelegate.set).not.toHaveBeenCalled()
          expect(binds['change:current']).not.toHaveBeenCalled()
          expect(binds['change:current[context=ctx1]']).not.toHaveBeenCalled()
        

        #----------------------------------------------------------------------
        describe 'When switching to a new context (ctx2)', ->

          beforeEach ->
            Nav.switchContext 'ctx2'

          it 'updates Nav.current with proper hash to defaultPagePath for context', ->
            expect(Nav.current).toEqual new Model
                hash: '#ctx2!path2'
                context: 'ctx2'
                page: 'path2'

          it 'adds hash to defaultPagePath for context to context history', ->
            prevHash = Nav.current
            mHashDelegate.set Nav.pageHash 'somewhereElse'
            Nav.goBack()
            expect(Nav.current).toBe prevHash
          
          it 'does NOT trigger "change:current[context=ctx1]" event', ->
            expect(binds['change:current[context=ctx1]']).not.toHaveBeenCalled()

          it 'triggers "change:current" event', ->
            expect(binds['change:current']).toHaveBeenCalledWith
              cur: new Model
                hash: '#ctx2!path2'
                context: 'ctx2'
                page: 'path2'
              prev: new Model
                hash: mInitialHash
                context: 'ctx1'
                page: 'a/b-c/d_ef/_gh/-ijk'
                data:
                  w: 'val'
                  x: 0
                  y: 'Krusty the Clown'
                  z: 'Sam I Am'
              model: Nav
              property: 'current'
              type: 'change:current'
              data:
                isBack: false
                isContextSwitch: true

          it 'triggers "change:current[context=ctx2]" event', ->
            expect(binds['change:current[context=ctx2]']).toHaveBeenCalledWith
              cur: new Model
                hash: '#ctx2!path2'
                context: 'ctx2'
                page: 'path2'
              prev: new Model
                hash: mInitialHash
                context: 'ctx1'
                page: 'a/b-c/d_ef/_gh/-ijk'
                data:
                  w: 'val'
                  x: 0
                  y: 'Krusty the Clown'
                  z: 'Sam I Am'
              model: Nav
              property: 'current'
              type: 'change:current[context=ctx2]'
              data:
                isBack: false
                isContextSwitch: true


        #----------------------------------------------------------------------
        describe 'When switching to a previously context (ctx1)', ->

          lastCtx1Hash = undefined
          lastCtx2Hash = undefined

          beforeEach ->
            mHashDelegate.set Nav.pageHash 'goSomewhere'
            lastCtx1Hash = Nav.current
            Nav.switchContext 'ctx2'
            lastCtx2Hash = Nav.current
            binds['change:current[context=ctx1]'].reset()
            binds['change:current[context=ctx2]'].reset()
            Nav.switchContext 'ctx1'

          it 'updates Nav.current with last hash of the previously visited context', ->
            expect(Nav.current).toBe lastCtx1Hash

          it 'does trigger "change:current[context=ctx1]" event', ->
            expect(binds['change:current[context=ctx1]']).toHaveBeenCalledWith
              cur: new Model lastCtx1Hash
              prev: new Model lastCtx2Hash
              model: Nav
              property: 'current'
              type: 'change:current[context=ctx1]'
              data:
                isBack: false
                isContextSwitch: true

          it 'does NOT trigger "change:current[context=ctx2]" event', ->
            expect(binds['change:current[context=ctx2]']).not.toHaveBeenCalled()