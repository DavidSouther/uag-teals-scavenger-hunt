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
