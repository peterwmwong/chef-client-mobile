define ['data/mock/shows/allShows'], (allShows)->
  _ = (o)->o
  for id,s of allShows
    result = id: id
    for k,v of s
      result[k] = v
    result
