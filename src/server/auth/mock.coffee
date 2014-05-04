if process.env.NODE_ENV isnt 'development'
    module.exports = (app)->app
    return

passport = require('passport')
winston = require('../logger').log
Student = require('../students/model')
auth = require('./authenticate')

mockStudent = "teals@uagateway.org"
mockAdmin = "davidsouther@gmail.com"

handlers =
    signin: (mockEmail)-> (req, res, next)->
        Student.findOneQ({email: mockEmail})
        .then (student)->
            if not student
                msg = "Mock Student `#{mockEmail}` not found!"
                throw new Error msg
            winston.info "#{student.email} logging in to mock..."
            student.token = 'mock'
            student.roles = { teacher: mockEmail is mockAdmin }
            student.saveQ()
            .then ([student])->
                winston.info "#{student.email} logged in as mock..."
                auth.authenticate res, student
        .fail (err)->
            next(err)

route = (app)->
    winston.debug 'Attaching Mock handlers to /auth/signin...'
    app.get '/auth/signin/mock', handlers.signin(mockStudent)
    app.get '/auth/signin/mock/admin', handlers.signin(mockAdmin)

module.exports = route
