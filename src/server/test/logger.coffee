describe 'logger', ->
    it 'returns a winston logger', ->
        [winston, logger] = require '../logger'
        winston.should.have.property 'info'
        logger.should.be.defined
