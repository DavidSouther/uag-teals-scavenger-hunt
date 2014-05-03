winston = require('../logger').log

handler = (req, res, next)->
    winston.debug '404ing bad API endpoint.'
    res.send 404, {msg: "Endpoint #{req.path} not found."}
rexp = new RegExp('/api.*')

route = (app)->
    winston.silly 'Attaching /api* 404 endpoint.'
    app.get rexp, handler
    app.post rexp, handler

module.exports = route
