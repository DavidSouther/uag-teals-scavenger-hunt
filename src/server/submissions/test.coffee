should = require "should"
app = require('express')()
require('./route')(app)
request = require('supertest')(app)

describe "Server DB", ->
    describe "submissions", ->
        it "has a sane model", ->
            Ctor = require('./model')
            inst = new Ctor()

        it "returns a list of submissions", (done)->
            test = ->
                request.get('/api/v1/submissions')
                .expect(200)
                .expect('Content-Type', /application\/json/)
                .end done
            setTimeout test, 20 # Ouch! Need to find way to mock
