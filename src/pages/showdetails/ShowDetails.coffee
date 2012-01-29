define [
  'Services'
  'cell!shared/ListView'
  'framework/Nav'
], (S,ListView,Nav)->

  render: (_)-> [
    _ 'img'
    _ '.titleGroup',
      _ 'h2.title'
      _ 'h4.year'
      _ 'h4.network'
    _ 'p.description'
    _ '.castGroup',
      _ 'h4.castHeader', 'Cast'
      _ '#castListContainer', ''
  ]

  afterRender: ->
    @model.bind 'activate': => @$('#castListView').trigger 'resetActive'
    @model.bindAndCall 'change:data': ({cur:data})=>
      @model.set title: 'Loading...'
      S.show.getDetails data.id, (d)=>
        @model.set title: d.title
        @$('.title').html d.title
        @$('.year').html d.year
        @$('.description').html (d.description.length <= 125) and d.description or "#{d.description.slice 0,125}..."
        @$('.network').html d.network
        @$('#ListView').remove()
        @$('#castListContainer')
          .append cell::$R ListView,
            id: 'castListView'
            list: for {id,name} in d.cast then {
              link: (@pageURI 'pages/profiledetails/ProfileDetails', id:id, title:name)
              text: name
            }

        @model.trigger 'refreshScroller'
