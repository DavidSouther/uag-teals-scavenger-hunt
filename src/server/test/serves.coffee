should = require "should"
server = require "../server"
request = require "request"

get = (path, d, cb)->
    request path, (e, r, b)->
        cb e, r, b
        d()

root = -> "http://localhost:#{process.env.PORT}/"
index = (d, cb)-> get "#{root()}index.html", d, cb
styles = (d, cb)-> get "#{root()}styles.css", d, cb

Callbacks =
    OK: (e, res)->
        res.statusCode.should.equal 200

describe "Server", ->

    before server.start
    after server.stop

    describe "index.html", (done)->
        it "returns an index", (done)->
            index done, Callbacks.OK

    describe "styles.css", ->
        it "returns a stylesheet", (done)->
            styles done, Callbacks.OK

        it "returns a css bundle", (done)->
            styles done, (e, res)->
                res.headers["content-type"]
                .indexOf("text/css")
                .should.be.greaterThan -1
