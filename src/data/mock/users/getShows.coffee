define [
  'data/mock/users/allUsers'
  'data/mock/PathHelper'
], (allUsers,{getPathComponents})->
  (path)->
    [api,user,userid,schedule,date] = getPathComponents path
    allUsers[userid].shows