winston = require('../logger').log
Student = require('../students/model')
auth = require('./authenticate')

signout = (req, res, next)->
    email = req.cookies.email
    winston.info "#{email} signing out..."
    Student.findQ({email: req.cookies.email, token: req.cookies.token})
    .then (student)->
        student = new Student(student) # Rewrap in mongoose?
        student.token = ''
        student.saveQ()
        .then ->
            winston.info "#{email} token destroyed, eating cookies..."
            auth.authenticate res, {name: '',  email: '', token: ''}, true
    .fail (err)-> next(err)

route = (app)->
    app.get '/auth/signout', signout
    app.get '/auth/logout', signout

module.exports = route
