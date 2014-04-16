winston = require 'winston'
express = require 'express'

level = process.env.LOG_LEVEL || 'info'
colorize = yes
timestamp = yes
opts = {level, colorize, timestamp}

winston = winston
    .remove(winston.transports.Console)
    .add(winston.transports.Console, opts)

stream =
    write: (message, encoding)->
        winston.verbose message

logger = express.logger({stream})

module.exports = [winston, logger]
