should = require "should"
app = require('express')()
require('./route')(app)
request = require('supertest')(app)

describe "Server DB", ->
    describe "hunts", ->
        it "returns a scavenger hunt", (done)->
            test = ->
                request.get('/api/hunts.json')
                .expect(200)
                .expect('Content-Type', /application\/json/)
                .end done
            setTimeout test, 50 # Ouch! Need to find way to mock
