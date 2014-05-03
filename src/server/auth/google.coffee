passport = require('passport')
googleStrategy = require('passport-google-oauth').OAuth2Strategy
Student = require('../students/model')

winston = require('../logger').log

strategy =
    settings:
        clientID: process.env.GOOGLE_OAUTH_CLIENTID
        clientSecret: process.env.GOOGLE_OAUTH_SECRET
        callbackURL: 'http://local.souther.co:1035/auth/google/callback'
        scope: 'https://www.googleapis.com/auth/userinfo.email'

    callback: (accessToken, refreshToken, profile, done)->
        error = (err)-> done(err)
        finish = (student)->
            done(null, student)
        found = (student)->
            student.token = accessToken
            student.saveQ().then(finish, error)

        Student.findOneQ({email: profile._json.email}).then(found, error)

passport.use new googleStrategy strategy.settings, strategy.callback

handlers =
    signin: (req, res, next)->
        winston.silly 'Starting google sign in.'
        passport.authenticate(
            'google'
            {scope: strategy.scope}
            (err, user, info)->
        )(req,res,next)
    callback: (req, res, next)->
        authHandler = (err, user, info)->
            return next(err) if err
            return res.redirect('http://localhost:8000') unless user
            found = (student)->
                Location = "http://localhost:8000/?token=#{student.token}&user=#{student.email}"
                res.writeHead 302, {Location}
                res.end()
            Student.findOneQ({email: profile._json.email}).then(found, error)
        passport.authenticate('google', authHandler)(req,res,next)

route = (app)->
    winston.debug 'Attaching Google handlers to /auth/signin...'
    app.get '/auth/signin/google', handlers.signin
    app.get '/auth/callback/google', handlers.callback

module.exports = route
