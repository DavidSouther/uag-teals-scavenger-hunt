winston = require('./logger').log
mongoose = require('mongoose-q')(require('mongoose'))
mongod = "mongodb://localhost:#{process.env.MONGO_PORT || 27017}/scavenge"
mongoose.connect mongod

mongoose.connection.on 'error', (err)-> winston.error 'connection error:', err

module.exports = mongoose