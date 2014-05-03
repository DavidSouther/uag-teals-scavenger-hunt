should = require "should"
app = require('express')()
require('./route')(app)
request = require('supertest')(app)

describe "Server DB", ->
    describe "students", ->
        it "returns a list of students", (done)->
            test = ->
                request.get('/api/students.json')
                .expect(200)
                .expect('Content-Type', /application\/json/)
                .end done
            setTimeout test, 100 # Ouch! Need to find way to mock
