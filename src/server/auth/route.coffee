route = (app)->
    if process.env.NODE_ENV is 'development'
        require('./mock')(app)
    require('./google')(app)

module.exports = route
