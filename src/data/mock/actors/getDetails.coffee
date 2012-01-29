define [
  'data/mock/actors/allActors'
  'data/mock/getPathComponent'
], (actors,getPathComponent)->
  (path)-> actors[getPathComponent path]