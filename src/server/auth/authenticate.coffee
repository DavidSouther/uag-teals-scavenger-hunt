winston = require('../logger').log
mongoose = require('../db')
Student = require('../students/model')

authenticate = (res, student, logout = false)->
    maxAge = if logout then 0 else 900000
    li = if logout then '0' else '1'
    cookieSettings = { maxAge } # secure: true ## soon
    res.cookie 'li', li, cookieSettings
    for f in ['name', 'email', 'token', 'roles']
        res.cookie f, student[f], cookieSettings
    winston.info "#{student.email} authenticated and cookies set."
    winston.data res.get('Set-Cookie')
    res.redirect('/')

userHandler = (req, res, next)->
    query = {email: req.cookies.email, token: req.cookies.token}
    winston.debug 'Querying mongo for Student...'
    winston.data query
    Student.findQ(query)
    .then ([student])->
        winston.debug 'Found Student...'
        winston.data JSON.stringify student
        req.student = new Student student
        next()
    .fail (err)->
        next(err)

module.exports = {authenticate, userHandler}
