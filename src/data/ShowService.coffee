define [
  'data/JSONP'
],({JSONPService})->
  new JSONPService 'shows',
    baseURL: 'api/shows/'
    methods:
      getDetails: (sid)-> "#{sid}"