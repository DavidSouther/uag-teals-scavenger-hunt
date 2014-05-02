db = require('../db')
Student = require('./model')

route = (app)->
    app.get '/api/students*', (req, res, next)->
        res.set 'Content-Type', 'application/json'
        unless db.connection._hasOpened
            res.send 500, JSON.stringify {error: "DB Connection Unavailable."}
            return
        success = (response)-> res.send 200, response
        failure = (error)-> res.send 500, JSON.stringify {error: msg}

        Student.findAll().then(success, failure)

module.exports = route
