winston = require('../logger').log
# db = require('../db')

Student = require('./model')
restify = require('express-restify-mongoose').serve

route = (app)->
    winston.silly 'Attaching students routes...'
    restify app, Student

module.exports = route
