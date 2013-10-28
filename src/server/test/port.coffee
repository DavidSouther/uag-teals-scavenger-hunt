should = require "should"
request = require "request"
server = require "../server"

get = (path, d, cb)->
    request path, (e, r, b)->
        cb e, r, b
        d()

index  = (d, cb)-> get "http://localhost:#{process.env.PORT}/", d, cb
Callbacks =
    OK: (e, res)->
        res.statusCode.should.equal 200

describe "Server", ->
    before server.start
    after server.stop

    describe "/", ->
        it "exports PORT on the env", ->
            process.env.PORT.should.be.greaterThan 1023

        it "binds on a known port", (done)->
            index done, (err, response)->
                should.not.exist err, "Error when GETting (#{err})"
