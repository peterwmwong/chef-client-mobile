define
  load: (name, req, load, config)->
    
    # Load Spec
    req ["#{name}.spec"], (Spec)-> load ->
      ctxPostfix = 0

      describe name, ->
        specRequire = null
        ctx = undefined

        # Run Spec
        Spec do->

          loadModule: (cb_mocks,cb)->
            # Remove all modules loaded from context
            $("[data-requirecontext='#{ctx.contextName}']").remove() if ctx

            # Create a new require context for each spec describe/it
            specRequire = require.config
              context: ctxName = "specs#{ctxPostfix++}"
              baseUrl: '/src/'
            ctx = window.require.s.contexts[ctxName]
            
            if typeof cb is 'function' and cb_mocks
              for k,v of cb_mocks
                ctx.defined[k] = v
                ctx.specified[k] = ctx.loaded[k] = true

            cb = cb_mocks if typeof cb_mocks is 'function'

            module = undefined
            runs -> specRequire [name], (mod)-> module = mod
            waitsFor (-> module isnt undefined), "'#{name}' Module to load", 1000
            runs -> cb module, specRequire
            