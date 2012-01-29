define ['data/mock/shows/allShows'], (shows)->
  gqiu:
    name: "Grace Qiu"
    shows: for s in Object.keys(shows)[..5] then shows[s]

  pwong:
    name: "Peter Wong"
    shows: for s in Object.keys(shows)[5..] then shows[s]