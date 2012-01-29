define [
  'data/mock/shows/allShows'
  'data/mock/getPathComponent'
], (shows,getPathComponent)->
  (path)-> shows[getPathComponent path]