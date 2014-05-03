if process.env.NODE_ENV isnt 'development'
    module.exports = (app)->app
    return

passport = require('passport')
winston = require('../logger').log
Student = require('../students/model')

handlers =
    signin: (req, res, next)->
        mockStudent = "davidsouther@gmail.com"
        cookieSettings = { maxAge: 90000 }
        Student.findOneQ({email: mockStudent})
        .then (student)->
            if not student
                msg = "Mock Student `#{mockStudent}` not found!"
                throw new Error msg
            winston.info "#{student.email} logging in to mock..."
            student.token = 'mock'
            student.saveQ()
            .then ([student])->
                winston.info "#{student.email} logged in as mock..."
                res.cookie 'li', '1', cookieSettings
                for f in ['name', 'email', 'token']
                    res.cookie f, student[f], cookieSettings
                res.redirect('/')
        .fail (err)->
            next(err)

route = (app)->
    winston.debug 'Attaching Mock handlers to /auth/signin...'
    app.get '/auth/signin/mock', handlers.signin

module.exports = route
