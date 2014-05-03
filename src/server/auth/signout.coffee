winston = require('../logger').log
Student = require('../students/model')

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
            cookieSettings = { maxAge: 0 } # secure: true ## soon
            res.cookie 'li', '0', cookieSettings
            res.cookie 'token', '', cookieSettings
            res.redirect('/login')
    .fail (err)-> next(err)

route = (app)->
    app.get '/auth/signout', signout
    app.get '/auth/logout', signout

module.exports = route
