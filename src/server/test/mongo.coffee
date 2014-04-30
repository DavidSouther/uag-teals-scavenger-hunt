should = require "should"
server = require "../server"
process.env.LOG_LEVEL = 'WARN'
request = require("supertest")(server.express)

describe "Server DB", ->
    describe "students", ->
        it "returns a list of students", (done)->
            test = ->
                request.get('/api/students.json')
                .expect(200)
                .expect('content-type', /application\/json/)
                .end done
            setTimeout test, 100 # Ouch! Need to find way to mock
