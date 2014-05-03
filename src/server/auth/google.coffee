# Not running in a full environment.
if not process.env.GOOGLE_OAUTH_CLIENTID
    module.exports = (app)->app
    return

winston = require('../logger').log
passport = require('passport')
googleStrategy = require('passport-google-oauth').OAuth2Strategy
Student = require('../students/model')

winston.debug "Google Auth: Callback Server is #{process.env.SERVER}"

strategy =
    settings:
        clientID: process.env.GOOGLE_OAUTH_CLIENTID
        clientSecret: process.env.GOOGLE_OAUTH_SECRET
        callbackURL: "#{process.env.SERVER}/auth/callback/google"
        scope: 'https://www.googleapis.com/auth/userinfo.email'

    ###
    This callback is handled by
    ###
    callback: (accessToken, refreshToken, profile, done)->
        error = (err)-> done(err)
        finish = ([student])->
            winston.info "Google OAuth token saved for #{student.email}."
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
                if err then winston.warn 'Issue with Google OAuth', err
        )(req, res, next)
    callback: (req, res, next)->
        winston.silly 'At google callback step.'
        authHandler = (err, student, info)->
            return next(err) if err
            console.log
            winston.info "#{student.email} logged in with Google."
            if student
                cookieSettings = { maxAge: 90000 } # secure: true ## soon
                res.cookie 'li', '1', cookieSettings
                for f in ['name', 'email', 'token']
                    res.cookie f, student[f], cookieSettings
            res.redirect '/'
        passport.authenticate('google', authHandler)(req, res, next)

route = (app)->
    winston.debug 'Attaching Google handlers to /auth/signin...'
    app.get '/auth/signin/google', handlers.signin
    app.get '/auth/callback/google', handlers.callback

module.exports = route
