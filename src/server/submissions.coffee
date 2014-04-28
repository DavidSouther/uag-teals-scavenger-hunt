fs = require('fs')
path = require('path')
rawBody = require('raw-body')
[winston, logger] = require './logger'
runner = require './runner'

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

handler = (req, res, next)->
    return next() unless req.path is '/submissions'
    rawBody req, {}, (err, string)->
        return next(err) if err
        try
            req.body = JSON.parse(string)
        catch err
            return next(err)
        putFile req.body, (err, code, log)->
            return next(err) if err
            status =
                if code is 1
                    'failure'
                else
                    'success'
            response = {code, status, log}
            res.send(200, JSON.stringify response)

module.exports = handler
