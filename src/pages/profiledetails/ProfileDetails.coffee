define [
  'Services'
  'cell!shared/ListView'
], (S,ListView)->

  render: (_)-> [
    _ 'img'
    _ '.nameGroup',
      _ 'h2.name'
      _ 'h4.bornInfo'
    _ '.knownForGroup',
      _ 'h4.knownForHeader', 'Known For'
      _ '#knownForList'
  ]

  afterRender: ->
    @model.bind 'activate': => @$('#knownForList > .ListView').trigger 'resetActive'
    @model.bindAndCall 'change:data': ({cur:{id,title}})=> 
      @model.set title: title or 'Loading...'
      S.actor.getDetails id, ({name,born,knownFor})=>
        @model.set title: name
        @$('.name').html name
        @$('.bornInfo').html born.year
        @$('#knownForList > .ListView').remove()
        @$('#knownForList').append cell::$R ListView,
          list:
            for {id,role,title} in knownFor then {
              link: (@pageURI "pages/showdetails/ShowDetails", {id,title})
              text: title
            }
        @model.trigger 'refreshScroller'
