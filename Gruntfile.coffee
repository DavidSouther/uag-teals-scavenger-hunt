Path = require 'path'
module.exports = (grunt)->
    require('grunt-recurse')(grunt, __dirname)

    grunt.expandFileArg = (
        prefix = '.',
        base = '**',
        postfix = '*test.coffee'
    )->
        part = (v)->"#{prefix}/#{v}#{postfix}"
        files = grunt.option('files')
        return part(base) unless files
        files.split(',').map (v)-> part(v)

    # grunt-recurse magic.
    [
        ['.', 'src', 'features']
        ['.', 'src', 'server']
        ['.', 'src', 'client']
        ['.', 'src', 'deploy']
    ]
    .map((dir)->Path.join.apply null, dir)
    .map(grunt.grunt)

    grunt.Config =
        jshint:
            options:
                jshintrc: '.jshintrc'
            files: [
                'src/**/*.js'
                '!src/client/assets/**'
            ]

        coffeelint:
            options:
                grunt.file.readJSON '.coffeelintrc'

            files: [
                'src/**/*.coffee'
                'Gruntfile.coffee'
            ]

        clean:
            all:
                [ 'build/' ]

        watch:
            deploy:
                # Need all files in the deploy tasks
                # 'buildClient' and 'copy:vendors'
                files: [
                    grunt.Config.copy.vendors.files[0].src.map (f)->
                        grunt.Config.copy.vendors.files[0].cwd + '/' + f
                    grunt.Config.watch.client.files
                ].reduce(((a, b)->a.concat(b)), [])
                tasks: [ 'deploy' ]
                options:
                    livereload: true

    grunt.registerTask 'test',
        'Run all non-component tests.',
        [ 'testClient', 'testServer', 'features' ]

    grunt.registerTask 'build',
        'Prepare distributable components.',
        [ 'client' ]

    grunt.registerTask 'linting',
        'Lint all files.',
        [ 'jshint', 'coffeelint' ]

    grunt.registerTask 'base',
        'Perform component specific prep and test steps.',
        [ 'clean:all', 'linting', 'client', 'server', 'deploy', 'features' ]

    grunt.registerTask 'default',
        'Perform all Prepare and Test tasks.',
        [ 'base' ]

    grunt.finalize()
