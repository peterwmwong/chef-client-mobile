define ->

  _registry = {}

  PageViewModel = ({@location})->
    @title = 'Loading...' # Default page title

  PageViewModel.for_location = (location)->
    if location?.uid?
      _registry[location.uid] or= new PageViewModel {location}

  _.extend PageViewModel.prototype, Backbone.Events,
    set_title: (new_title)->
      if @title isnt new_title
        old_title = @title
        @title = new_title
        @trigger 'change:title', @title, old_title

  PageViewModel