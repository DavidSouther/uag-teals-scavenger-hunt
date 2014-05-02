should = require "should"
request = require('supertest')(require('./route')(require('express')()))

describe "Server DB", ->
    describe "students", ->
        it "returns a list of students", (done)->
            test = ->
                request.get('/api/students.json')
                .expect(200)
                .expect('content-type', /application\/json/)
                .end done
            setTimeout test, 100 # Ouch! Need to find way to mock
