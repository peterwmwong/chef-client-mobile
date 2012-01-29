define ->
	PathHelper =
	  getPathComponent: (path,i)-> (s = PathHelper.getPathComponents(path))[ do->
	    if i? then i
	    else s.length - 1
	  ]
	  getPathComponents: (path)-> path.split '/'