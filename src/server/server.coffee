Path = require "path"

# Root is two up from server.
global.root = Path.join __dirname, "..", ".."
app_name = require('../../package').name

logging = require './logger'
winston = logging.log
express = require "express"

app = express()
.use(logging.middleware)

require('./routers')(app)

module.exports =
    server: null
    express: app
    start: (callback)->
        startingPort = process.env.NODE_PORT || 1024
        require('openport')
        .find {startingPort}, (err, port)->
            process.env.PORT = port
            @server = app.listen process.env.PORT
            winston.info "#{app_name} listening"
            winston.info "http://127.0.0.1:#{port}/"
            callback?()

    stop: ->
        @server?.close()
