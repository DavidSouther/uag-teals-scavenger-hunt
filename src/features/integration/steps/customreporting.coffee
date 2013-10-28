Q = require 'q'
should = require 'should'
By = require("selenium-webdriver").By
module.exports = ->
    require('qcumber')(@)

    PORT = process.env.PORT || 80
    APP = process.env.APPLICATION || ''
    ROOT = process.env.APP_ROOT || "http://localhost:#{PORT}/#{APP}"
    process.env.APP_ROOT = ROOT

    require('qcumberbatch').steps.call(@)

    @Then /should see a control panel/, ->
        @world.exists('control-panel')

    @Then /should see a stage/, ->
        @world.exists('stage')

    @Then /should see several report templates/, ->
        @world.driver.findElements(By.css("#reports li"))
        .then (reports)->
            reports.length.should.be.greaterThan 2

    @Then /should see a params panel/, ->
        @world.exists('params')

    @Then /should see a components list/, ->
        @world.exists('components')

    @Then /stage should have several components/, ->
        @world.driver.findElements(By.css("#stage .component"))
        .then (components)->
            components.length.should.equal 3

    @Then /"([^"]+)" is on the left quarter of the page/, (elem)->
        @world.coords(elem)
        .then (coords)->
            # To be in the left quarter of the page,
            # the ratio of the right side to the window width must be
            # less than 1 to 4.
            el = coords.element
            right = el.left + el.width
            expected = 4 * right
            expected.should.be.lessThan coords.window.width
