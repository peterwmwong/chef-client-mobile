define [
  'Services'
  'shared/DateHelper'
  'cell!shared/ListView'
  'framework/Nav'
], (S,DateHelper,ListView,Nav)->

  init: ->
    @model.set title: 'Watch'
    @model.bind 'activate': => @$('#ShowList').trigger 'resetActive'

  render: (_)->
    S.user.getShows new Date(), (shows)=>
      @$el.append _ ListView,
        id: 'ShowList'
        list:
          for i in [0..10] then {
            link: (@pageURI 'pages/showdetails/ShowDetails', id:i)
            text: "#{i}"
          }
      @model.trigger 'refreshScroller'
