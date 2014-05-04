winston = require('../logger').log

Hunts = require('./model')

route = (app)->
    winston.silly 'Attaching hunts routes...'
    app.get '/api/hunts', (req, res, next)->
        res.set 'Content-Type', 'application/json'
        unless db.connection._hasOpened
            res.send 500, JSON.stringify {error: "DB Connection Unavailable."}
            return
        success = (response)-> res.send 200, response
        failure = (error)-> res.send 500, JSON.stringify {error: msg}

        Hunts.findQ().then(success, failure)

    app.post '/api/hunts/save', (req, res, next)->
        unless req.student.roles?.teacher
            res.send 404, {msg: 'Only teachers can upload hunts.'}
            return
        winston.debug 'Saving new Hunt...'
        winston.data req.body
        hunt = new Hunts req.body
        hunt.saveQ()
        .then ([hunts])->
            res.send 200, {msg: 'Hunts saved!'}
        .fail (err)->
            next(err)

module.exports = route
