module.exports = (grunt)->
    flatten = (a, b)-> a.concat b

    module = 'teals.scavenger'
    appFileOrdering = [
        '**/template.jade'
        '**/main.coffee'
        '**/service.coffee'
        '**/directive.coffee'
    ].map((a)->"src/client/#{a}").reduce flatten, []

    jadeTemplateId = (filepath)->
        r_template = /^src\/client\/(.*)\/template.(html|jade)$/
        path = filepath.replace r_template, '$1'
    jadeTemplateModule = (filepath)->
        r_template = /^src\/client\/(.*)\/template.(html|jade)$/
        path = filepath.replace r_template, 'teals.$1.template'
    jadeOpts =
        moduleName: 'teals.templates'
        processName: jadeTemplateId
        newModule: true

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
                options: jadeOpts
        stylus:
            options:
                paths: [
                    'src/client/stylus/definitions'
                ]
                import: [
                    'mixins'
                    'variables'
                    'nib'
                ]
            all:
                files:
                    'build/client/all.css': "src/client/**/all.styl"
            print:
                files:
                    'build/client/print.css': "src/client/**/print.styl"
            screen:
                files:
                    'build/client/screen.css': "src/client/**/screen.styl"

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
                    src: [
                        'angular/angular.*'
                        'angular-route/angular*'
                        'angular-cookies/angular*'
                        'angular-resource/angular*'
                        # 'angular-ui/build/**/*'
                        'bootstrap/dist/**/*'
                        'angular-bootstrap/**/*'
                        'angular-ui-codemirror/**/*'
                        'codemirror/**/*'
                        'css-social-buttons/css/*'
                    ]
                    dest: 'build/client/vendors'
                ]

        coffee:
            options:
                bare: false
            client:
                files:
                    'build/client/app.js': appFileOrdering
                        .filter (file)-> file.match(/\.coffee$/)

    # butt - Browser Under Test Tools
    butt = []
    unless process.env['DEBUG']
        if process.env['BAMBOO']
            butt = ['PhantomJS']
        else
            butt = ['Chrome']

    preprocessors =
        'src/client/**/*test.coffee': [ 'coffee' ]
        'src/client/tools/*.coffee': [ 'coffee' ]
        'src/client/**/*.jade': [ 'jade', 'ng-html2js' ]

    cover = if process.env.DEBUG then 'coffee' else 'coverage'
    for type in appFileOrdering
        if type.indexOf('.coffee') > -1
            preprocessors[type] = [cover]

    grunt.Config =
        karma:
            client:
                options:
                    browsers: butt
                    frameworks: [ 'mocha', 'sinon-chai' ]
                    reporters: [ 'spec', 'junit', 'coverage' ]
                    singleRun: true,
                    logLevel: 'INFO'
                    preprocessors: preprocessors
                    files: [
                        # 'bower_components/jquery/jquery.js'
                        'bower_components/angular/angular.js'
                        'bower_components/angular-route/angular-route.js'
                        'bower_components/angular-resource/angular-resource.js'
                        # 'bower_components/angular-animate/angular-animate.js'
                        'bower_components/angular-cookies/angular-cookies.js'
                        'bower_components/angular-mocks/angular-mocks.js'
                        'src/client/tools/**/*'
                        appFileOrdering
                        grunt.expandFileArg('src/client', '**/')
                    ].reduce(flatten, [])
                    ngHtml2JsPreprocessor:
                        cacheIdFromPath: jadeTemplateId
                        moduleName: 'teals.templates'
                    junitReporter:
                        outputFile: 'build/reports/karma.xml'
                    coverageReporter:
                        type: 'lcov'
                        dir: 'build/coverage/'

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
            'stylus'
        ]

    grunt.registerTask 'client',
        'Prepare and test the client.',
        [
            'testClient'
            'buildClient'
        ]
