define ->
  getPathComponent = (path,i)-> (s = path.split '/')[ do->
    if i? then i
    else s.length - 1
  ]