[winston, logger] = require '../logger'
mongo = require('mongodb').MongoClient
db = null
mongod = "mongodb://localhost:#{process.env.MONGO_PORT || 27017}/scavenge"

mongo.connect "#{mongod}", (err, _db_)->
    if err
        winston.err 'DB Connection err', mongod, err
        return
    db = _db_

findAllStudents = (cb)->
    db.collection('students').find().toArray (err, students)->
        if err
            msg = "Student Listing Unavailable."
            winson.err msg, err
            cb {error: msg}
            return
        response = students: students.map (_)->_.name
        cb null, response

router = (req, res, next)->
    return next() unless req.path is '/api/students.json'
    res.set 'Content-Type', 'application/json'
    unless db
        res.send 500, JSON.stringify {error: "DB Connection Unavailable."}
        return
    findAllStudents (err, response)->
        if err
            res.send 500, JSON.stringify {error: msg}
        else
            res.send 200, response

module.exports = router
