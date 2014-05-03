passport = require('passport')
winston = require('../logger').log
googleStrategy = require('passport-google-oauth').OAuth2Strategy
Student = require('../students/model')

handlers =
    signin: (req, res, next)->next()
    callback: (req, res, next)->next()

route = (app)->
    winston.debug 'Attaching Mock handlers to /auth/signin...'
    app.get '/auth/signin/mock', handlers.signin
    app.get '/auth/callback/mock', handlers.callback

module.exports = route
