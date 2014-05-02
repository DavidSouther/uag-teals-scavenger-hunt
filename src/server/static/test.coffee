should = require "should"
global.root = require('path').join('.')
request = require('supertest')(require('./route')(require('express')()))

describe "Server", ->
    describe "index.html", ->
        it "returns an index", (done)->
            request.get('/index.html')
            .expect(200)
            .end done

    describe "styles: all", ->
        it "returns a stylesheet", (done)->
            request.get('/all.css')
            .expect(200)
            .expect('content-type', /text\/css/)
            .end done

    describe "styles: print", ->
        it "returns a stylesheet", (done)->
            request.get('/print.css')
            .expect(200)
            .expect('content-type', /text\/css/)
            .end done

    describe "styles: screen", ->
        it "returns a stylesheet", (done)->
            request.get('/screen.css')
            .expect(200)
            .expect('content-type', /text\/css/)
            .end done

    describe "html5", ->
        it "returns index on any request to non-asset.", (done)->
            request.get('/deep/link')
            .expect(200)
            .expect('content-type', /text\/html/)
            .end done