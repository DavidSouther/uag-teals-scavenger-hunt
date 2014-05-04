winston = require('../logger').log

Hunts = require('./model')
restify = require('express-restify-mongoose').serve

route = (app)->
    winston.silly 'Attaching hunts routes...'
    restify app, Hunts

module.exports = route
