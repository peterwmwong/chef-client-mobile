resolve = require('path').resolve
connect = require 'connect'
http = require 'http'

if process.argv.length != 3 then console.log "[dir]"
else
  path = resolve process.argv[2]
  app = connect()
    .use(connect.favicon())
    .use(connect.compress())
    .use(connect.static path, maxAge: 1, hidden: true)
  http.createServer(app).listen(3000)
  