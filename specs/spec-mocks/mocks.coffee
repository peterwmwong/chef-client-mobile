define ->
  _uid = Math.random()*10000>>0

  mock_location: ({uid,tab,page,data,has_referrer}={})->
    uid: uid? or _uid++
    tab: tab? or "MockTab"
    page: page? or "MockTab_Page"
    data: data? or {}
    has_referrer: has_referrer? or false
