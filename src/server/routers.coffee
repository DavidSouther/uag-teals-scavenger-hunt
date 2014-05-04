routers = (app)->
    [
        'auth'
        'students'
        'leaders'
        'hunts'
        'submissions'

        'api'

        'static' # Always last
    ].forEach (api)->
        require("./#{api}/route")(app)

    app

module.exports = routers
