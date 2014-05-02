path = require "path"
root = path.join __dirname, "..", ".."
client = path.join root, 'build', 'client'
app_name = require('../../package').name

[winston, logger] = require './logger'
express = require "express"

app = express()
.use(logger)
.use(require('./submissions'))
.use(require('./leaders'))
.use(require('./mongo/router'))
.use (req, res, next)->
    if req.path.match /\.(html|css|js|map|png|svg|json|gif|ttf)$/
        # Statically serve .{asset} files
        next()
    else
        # Serve the index
        res.sendfile path.join client, 'index.html'
.use(require('st')(client))

server = null

module.exports =
    express: app
    start: (callback)->
        startingPort = process.env.NODE_PORT || 1024
        require('openport')
        .find {startingPort}, (err, port)->
            process.env.PORT = port
            server = app.listen process.env.PORT
            winston.info "#{app_name} listening"
            winston.info "http://127.0.0.1:#{port}/"
            callback?()

    stop: ->
        server?.close()
