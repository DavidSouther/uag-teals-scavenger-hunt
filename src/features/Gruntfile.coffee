module.exports = (grunt)->
    features = grunt.expandFileArg 'src/features/integration/users', '**/', '*'

    grunt.Config =
        cucumberjs:
            integration:
                files:
                    src: features
            current:
                files:
                    src: features
                options:
                    tags: '@current'
            options:
                steps: 'src/features/integration/steps'

    grunt.registerTask 'featuresCurrent',
        'Run CucumberJS features tagged @current',
        [
            'selenium-launch'
            'client-server-launch'
            'cucumberjs:current'
        ]

    grunt.registerTask 'features',
        'Run all CucumberJS feature tests.',
        [
            'selenium-launch'
            'client-server-launch'
            'cucumberjs:current'
            'cucumberjs:integration'
        ]
