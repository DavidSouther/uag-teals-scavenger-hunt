routers = (app)->
    [
        'auth'
        'students'
        'leaders'
        'submissions'

        'api'

        'static' # Always last
    ].forEach (api)->
        require("./#{api}/route")(app)

    app

module.exports = routers
