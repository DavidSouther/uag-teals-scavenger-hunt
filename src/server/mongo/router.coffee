[winston, logger] = require '../logger'
mongoose = require('mongoose-q')(require('mongoose'))
mongod = "mongodb://localhost:#{process.env.MONGO_PORT || 27017}/scavenge"
mongoose.connect mongod

db = mongoose.connection
dbOpen = false
db.on 'error', (err...)-> winston.err 'connection error:', err
db.once 'open', -> dbOpen = true

studentSchema = mongoose.Schema({name: String, email: String})
Student = mongoose.model 'student', studentSchema

findAllStudents = ->
    Student.findQ().then (students)->
        { students: students.map (_)-> {name: _.name, email: _.email } }

router = (req, res, next)->
    return next() unless req.path.indexOf('/api/students') is 0
    res.set 'Content-Type', 'application/json'
    unless dbOpen
        res.send 500, JSON.stringify {error: "DB Connection Unavailable."}
        return
    success = (response)-> res.send 200, response
    failure = (error)-> res.send 500, JSON.stringify {error: msg}

    findAllStudents().then(success, failure)

module.exports = router
