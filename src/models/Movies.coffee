define ->
  
  Movie = Backbone.Model.extend
    initialize: ->
      @url = "/movies/#{@id}"

  Backbone.Collection.extend
    model: Movie
    url: "/movies"
