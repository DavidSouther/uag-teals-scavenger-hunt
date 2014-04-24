fs = require('fs')
path = require('path')
[winston, logger] = require './logger'

handler = (req, res, next)->
    return next() unless req.path is '/leaders'
    fs.readdir 'submissions', (err, dir)->
        return next(err) if err
        fail = false
        count = dir.length
        accum = {}
        dir.map (student)->
            dirPath = path.join('submissions', student)
            fs.readdir dirPath, (err, files)->
                return if fail
                if err
                    fail = true
                    return next(err)
                accum[student] = files
                if --count is 0
                    res.json accum

module.exports = handler
