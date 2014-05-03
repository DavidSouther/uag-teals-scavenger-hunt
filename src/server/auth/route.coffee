route = (app)->
    app.use(require('express').cookieParser())
    if process.env.NODE_ENV is 'development'
        require('./mock')(app)
    require('./google')(app)
    require('./signout')(app)

module.exports = route
