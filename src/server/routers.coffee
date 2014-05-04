routers = (app)->
    [
        'auth'
        'students'
        'leaders'
        'hunts'
        'submissions'

        'api'
    ].forEach (api)->
        require("./#{api}/route")(app)

    app

module.exports = routers
