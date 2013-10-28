module.exports = (grunt)->
    flatten = (a, b)-> a.concat b

    appFileOrdering = [
        # This array has the various file arguments in correct order.
        'src/client/main/main.coffee'
        'src/client/**/template.jade'
        'src/client/**/directive.coffee'
    ].reduce flatten, []

    jadeTemplateId = (filepath)->
        filepath
        .replace /^src\/client\/(.*)\/template.jade$/, '$1'

    grunt.Config =
        watch:
            client:
                files: [
                    'src/client/**/*.js'
                    'src/client/**/*.coffee'
                    'src/client/**/*.jade'
                    'src/client/**/*.styl'
                ]
                tasks: [
                    'client'
                ]
                options:
                    spawn: false

        jade:
            index:
                files: {
                    'build/client/index.html': ['src/client/index.jade']
                }
        ngjade:
            templates:
                files: [{
                    expand: false
                    src: ['src/client/**/template.jade']
                    dest: 'build/client/templates.js'
                }]
                options:
                    moduleName: 'angularBase'
                    processName: jadeTemplateId

        copy:
            client:
                files: [
                    expand: true
                    cwd: 'src/client'
                    src: ['index.html', 'assets/**/*']
                    dest: 'build/client'
                ]
            vendors:
                files: [
                    expand: true
                    cwd: 'bower_components'
                    src: [ 'angular/angular.min*' ]
                    dest: 'build/client/vendors'
                ]

        coffee:
            options:
                bare: false
            client:
                files:
                    'build/client/app.js': appFileOrdering
                        .filter (file)-> file.match(/\.coffee$/)

        stylus:
            client:
                files:
                    'build/client/styles.css': [
                        'src/client/**/*.styl'
                    ]

        karma:
            client:
                options:
                    browsers: [ 'PhantomJS' ]
                    frameworks: [ 'mocha', 'sinon-chai' ]
                    reporters: [ 'spec' ]
                    singleRun: true
                    preprocessors:
                        'src/client/**/*.coffee': 'coffee'
                        'src/client/**/*.jade': 'ng-html2js'
                    files: [
                        'bower_components/jquery/jquery.js'
                        'bower_components/angular/angular.js'
                        'bower_components/angular-mocks/angular-mocks.js'
                        'src/client/tools/**/*'
                        appFileOrdering
                        grunt.expandFileArg('src/client', '**/')
                    ].reduce(flatten, [])
                    ngHtml2JsPreprocessor:
                        jade: true
                        moduleName: 'angularApp'
                        cacheIdFromPath: jadeTemplateId

    grunt.registerTask 'testClient',
        'Run karma tests against the client.',
        [
            'karma:client'
        ]

    grunt.registerTask 'buildClient',
        'Prepare the build/ directory with static client files.',
        [
            'copy:client'
            'copy:vendors'
            'ngjade:templates'
            'jade:index'
            'coffee:client'
            'stylus:client'
        ]

    grunt.registerTask 'client',
        'Prepare and test the client.',
        [
            'testClient'
            'buildClient'
        ]
