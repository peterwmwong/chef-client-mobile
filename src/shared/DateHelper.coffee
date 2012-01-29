define ->
  today = new Date()
  offsetDayMap = ['Today','Yesterday'].concat (for i in [2...7] then "#{i} days ago"), "a week ago"

  getDisplayable: (o)->
    if today.getYear() is o.getYear() and today.getMonth() is o.getMonth()
      offsetDayMap[ today.getDate() - o.getDate() ]
    else
      o.toLocaleDateString()