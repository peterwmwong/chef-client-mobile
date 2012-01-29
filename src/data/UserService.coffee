define [
  'data/JSONP'
],({JSONPService})->

  userid = 'pwong'

  new JSONPService 'users',
    baseURL: 'api/users/'
    methods:
      getWatchedShows: -> "#{userid}/watched-shows"
      getShows: (date)-> "#{userid}/schedule/#{date.getYear()+1900}-#{date.getMonth()}-#{date.getDate()}"
