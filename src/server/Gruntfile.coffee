process.env.LOG_LEVEL = 'error'
module.exports = (grunt)->
    grunt.Config =
        mochaTest:
            server:
                options:
                    reporter: 'spec'
                src: grunt.expandFileArg 'src/server/test', '*', '.coffee'

    grunt.registerTask 'client-server-launch', ->
        done = @async()
        require('./server').start(done)

    grunt.registerTask 'testServer', 'Test the server.', ['mochaTest:server']

    grunt.registerTask 'server', 'Prepare the server.', ['testServer']
