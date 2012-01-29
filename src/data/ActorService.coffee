define [
  'data/JSONP'
],({JSONPService})->
    
  new JSONPService 'actors',
    baseURL: 'api/actors/'
    methods:
      getDetails: (sid)-> "#{sid}"
