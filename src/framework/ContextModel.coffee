define ['./Model'], (Model)->
  class ContextModel extends Model
    constructor: ({id,initialHash,hashManager,defaultPagePath})->
      super
        id: id
        defaultPagePath: defaultPagePath
        currentPageModel: currentPageModel = new Model initialHash
        pageHistory: pageHistory = [currentPageModel]

      (bind = {})["change:current[context=#{id}]"] = ({cur,prev})=>
        if not (isContextSwitch = (cur.context isnt prev?.context))
          if pageHistory[1]?.hash is cur.hash
            pageHistory.splice 0, 1
          else
            pageHistory.unshift new Model cur
        
        @set {currentPageModel: pageHistory[0]}, {isContextSwitch}
      hashManager.bind bind