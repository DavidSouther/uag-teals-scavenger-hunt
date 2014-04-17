fs = require('fs')
path = require('path')
rawBody = require('raw-body')

putFile = (script, cb)->
    directory = script.name.replace(' ', '')
    fs.mkdir directory, (err)->
        return cb(err) if err.code isnt 'EEXIST'
        filename = path.join(directory, script.file)
        opts = {mode: 0o774}
        fs.writeFile filename, script.script, opts, (err)->
            return cb(err) if err
            cb()

handler = (req, res, next)->
    return next() unless req.path is '/submissions'
    rawBody req, {}, (err, string)->
        return next(err) if err
        try
            req.body = JSON.parse(string)
        catch err
            return next(err)
        putFile req.body, (err)->
            return next(err) if err
            res.send(200, '{"status": "Success"}')

module.exports = handler
