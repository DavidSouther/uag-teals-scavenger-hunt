fs = require('fs')
path = require('path')

route = (app)->
    app.get '/api/leaders', (req, res, next)->
        fs.readdir 'submissions', (err, dir)->
            return next(err) if err
            fail = false
            count = dir.length
            accum = {}
            dir.map (student)->
                dirPath = path.join('submissions', student)
                fs.readdir dirPath, (err, files)->
                    # Don't send more errors if one has failed
                    return if fail
                    if err
                        fail = true # Mark the map as failed
                        return next(err)
                    accum[student] = files
                    if --count is 0 # Last one
                        res.json accum

module.exports = route
