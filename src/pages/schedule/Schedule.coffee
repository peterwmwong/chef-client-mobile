define [
  'require'
  'Services'
  'shared/DateHelper'
  'cell!shared/ListView'
], (require,S,DateHelper,ListView)->

  ShowDetailsPage = 'pages/showdetails/ShowDetails'

  init: ->
    @model.bind 'activate': =>
      @model.set title: DateHelper.getDisplayable new Date()
      @$('#ShowList').trigger 'resetActive'

  render: (_)->
    S.user.getShows new Date(), (shows)=>
      @$el.append _ ListView,
        id: 'ShowList'
        list: for s in shows then {
          link: (@pageURI ShowDetailsPage, id:s.id, title:s.title)
          text: s.title
        }
      @model.trigger 'refreshScroller'
      
      # Pre-emptive/Deferred Loading
      require [ShowDetailsPage], ->
