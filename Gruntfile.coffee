Path = require 'path'
module.exports = (grunt)->
    require('grunt-recurse')(grunt, __dirname)

    grunt.expandFileArg = (prefix = '.', base = '**', postfix = 'test.coffee')->
        part = (v)->"#{prefix}/#{v}#{postfix}"
        files = grunt.option('files')
        return part(base) unless files
        files.split(',').map (v)-> part(v)

    # grunt-recurse magic.
    [
        ['.', 'src', 'features']
        ['.', 'src', 'server']
        ['.', 'src', 'client']
    ]
    .map((dir)->Path.join.apply null, dir)
    .map(grunt.grunt)

    grunt.Config =
        jshint:
            options:
                jshintrc: '.jshintrc'
            files:
                'src/**/*.js'

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

    grunt.registerTask 'test',
        'Run all non-component tests.',
        [ 'features' ]
    grunt.registerTask 'build',
        'Prepare distributable components.',
        [ 'client' ]

    grunt.registerTask 'linting',
        'Lint all files.',
        [ 'jshint', 'coffeelint' ]
    grunt.registerTask 'base',
        'Perform component specific prep and test steps.',
        [ 'clean:all', 'linting', 'build', 'server' ]
    grunt.registerTask 'default',
        'Perform all Prepare and Test tasks.',
        [ 'base', 'test' ]

    grunt.finalize()
