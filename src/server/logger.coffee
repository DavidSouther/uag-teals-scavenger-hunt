winston = require 'winston'
express = require 'express'

level = process.env.LOG_LEVEL || 'info'
opts = {level, colorize: yes, timestamp: yes}

winston = winston
    .remove(winston.transports.Console)
    .add(winston.transports.Console, opts)

stream =
    write: (message, encoding)->
        winston.verbose message

logger = express.logger({stream})
module.exports = {log: winston, middleware: logger}
