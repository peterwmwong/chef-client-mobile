define
  load: (name, req, load, config)->
    isFunc = (obj)-> Object::toString.call(obj) is '[object Function]'

    # Load Spec
    req ["#{name}.spec"], (Spec)-> load ->
      ctxPostfix = 0

      describe name, ->
        cur_ctx = undefined

        # Run Spec
        Spec loadModule: (cb_mocks,cb)->

          if not cb? and isFunc cb_mocks
            cb = cb_mocks
            cb_mocks = undefined

          throw "Could not load spec for #{name}" if not isFunc cb

          # Remove all modules loaded from context
          $("[data-requirecontext='#{cur_ctx.contextName}']").remove() if cur_ctx

          # Create a new require context for each spec describe/it
          specRequire = requirejs.config
            context: ctxName = "specs#{ctxPostfix++}"
            baseUrl: '/src/'

          cur_ctx = window.require.s.contexts[ctxName]

          if cb_mocks
            for mod_name, mod_obj of cb_mocks then do(mod_obj)->
              mod_map = cur_ctx.makeModuleMap mod_name, null, true
              (cur_ctx.registry[mod_name] = new cur_ctx.Module mod_map).init [],
                -> mod_obj
                undefined
                {enabled: true}

          module = undefined
          runs -> specRequire [name], (m)-> module = m
          waitsFor (-> module?), "'#{name}' Module to load", 1000
          runs -> cb module, specRequire
          
          