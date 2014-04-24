Q = require('q')
should = require('should')
protractor = require('protractor')
By = require('selenium-webdriver').By
_ = require('underscore')

mappings = require('../mappings')

module.exports = ->
    require('qcumber')(@)
    require('qcumberbatch').steps.call(@)

    @protractor = protractor.wrapDriver @world.driver

    PORT = process.env.PORT || 80
    APP = process.env.APPLICATION || ''
    ROOT = process.env.APP_ROOT || "http://localhost:#{PORT}/#{APP}"
    process.env.APP_ROOT = ROOT

    @Given /on the site/, =>
        @world.visit(ROOT)
        .then => @protractor.waitForAngular()

    @When /type "([^"]*)" into the "([^"]*)"/, (text, field)=>
        selector = mappings[field]
        @world.driver.findElement(By.css(selector))
        .sendKeys(text)
        .then => @protractor.waitForAngular()

    @Then /should see "([^"]+)" in the "([^"]*)"/, (text, field)=>
        selector = mappings[field]
        @world.driver.findElement(By.css(selector))
        .getText (element)->
            element.should.equal text

    @Then /"([^"]*)" should have several rows/, (table)=>
        selector = mappings[table] + ' tr'
        @world.findAll(selector)
        .then (elements)->
            elements.length.should.be.greaterThan 1
