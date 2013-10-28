server = require('../server')

describe 'Server', ->
    after -> server.stop()

    it 'informs the caller when it has finished', (done)->
        server.start done
