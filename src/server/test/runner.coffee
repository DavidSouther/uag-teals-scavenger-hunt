should = require 'should'
runner = require '../runner'
fs = require 'fs'
temp = require  'temp'

goodFile = """
for i in range(1, 467):
    print i
"""

uglyFile = """
for novar in range(0, 8)
    stuff
"""

badFile = """
while True:
    print 'loop'
"""

describe 'runner', ->
    it.skip 'handles good files', (done)->
        info = temp.openSync()
        fs.writeSync info.fd, goodFile
        fs.closeSync info.fd
        runner info.path, (err, log)->
            should.not.exist err
            done()

    it.skip 'handles ugly files', (done)->
        info = temp.openSync()
        fs.writeSync info.fd, uglyFile
        fs.closeSync info.fd
        runner info.path, (err, log)->
            err.should.equal 1
            done()

    it.skip 'handles bad files', (done)->
        info = temp.openSync()
        fs.writeSync info.fd, badFile
        fs.closeSync info.fd
        runner info.path, (err, log)->
            err.should.equal 9 # SIGKILL
            done()

