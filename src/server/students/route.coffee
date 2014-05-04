winston = require('../logger').log
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

    app.post '/api/students/save', (req, res, next)->
        unless req.student.roles.teacher
            res.send 401, {msg: "Not a teacher!"}
            return
        winston.debug 'Saving student data...'
        winston.data req.body
        Student.findQ({name: req.body.name})
        .then ([student])->
            unless student
                res.send 404, {msg: "#{req.body.name} not a student."}
                return
            student.email = req.body.email
            winston.info req.body
            if req.body.roles.teacher
                student.roles = {teacher: true}
            else
                student.roles = {}
            winston.debug 'Saving student data...'
            winston.data JSON.stringify student
            student.saveQ().then ([student])->
                winston.debug 'Student data saved!'
                winston.data JSON.stringify student
                res.send 200, JSON.stringify student
            .fail (err)->
                res.send 500, {msg: "Couldn't save student!", err}
        .fail (err)->
            res.send 500, {msg: "Couldn't find student!", err}
module.exports = route
