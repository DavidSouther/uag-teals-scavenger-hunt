fs = require('fs')
path = require('path')
rawBody = require('raw-body')
winston = require('../logger').log
runner = require './runner/runner'

Student = require('./model')
restify = require('express-restify-mongoose').serve

do ->
    submissions = 'submissions'
    try
        fs.mkdirSync submissions
    catch e
        winston.info "Skipping ./submissions creation"

putFile = (script, cb)->
    directory = script.name.replace(' ', '')
    directory = path.join submissions, directory
    fs.mkdir directory, (err)->
        return cb(err) if err.code isnt 'EEXIST'
        filename = path.join(directory, script.file)
        opts = {mode: 0o774}
        fs.writeFile filename, script.script, opts, (err)->
            return cb(err) if err
            runner filename, (code, log)->
                cb null, code, log

route = (app)->
    winston.silly 'Attaching students routes...'
    restify app, Student

module.exports = route
