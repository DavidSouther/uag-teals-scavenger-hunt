class SubmissionsCtrl
    constructor: (
        @fileReader
        @$scope
        @students
        @huntservice
        @submissions
        @$timeout
        @$window
        $cookies
    )->
        @reset(false)

        if $cookies.li is '1'
            @locked = true
            @student = $cookies.name
            @email = $cookies.email

        @$scope.$watch (=>@student), (o, n)=>
            @$window.localStorage.student = @student unless o is n

    loadScript: ->
        if not @huntservice.checkScriptName(@file.name)
            @$scope.$broadcast "Invalid Script Name: #{@file.name}"
            @invalid = true
            return
        @fileReader.readAsText(@file, @$scope)
        .then (result)=> @handleScript(result)

    handleScript: (result)->
        @invalid = false
        @script = result
        program = @huntservice.findScript @file.name
        @prompt = program.description
        @points = program.points

    reset: (soft = true)->
        @invalid = false
        @file = undefined
        @script = ''
        @prompt = ''
        @comments = ''
        @student = @$window.localStorage.student || '' unless soft

    submit: ->
        @submissions.submit({
            studentEmail: @email
            hunt: @huntservice.findHunt(@file.name).name
            script: @file.name
            content: "'''\n#{@comments}\n'''\n#{@script}"
        }).then(
            (_)=>
                if _._id.match /[0-9a-f]{24}/
                    # Got a sane ID
                    @success(_)
                else
                    @failure(_)
            (_)=> @error(_)
        )

    success: ->
        @$scope.$emit 'Upload Success'
        @uploadSuccess = true
        @uploaded = @file.name
        @reset()

    failure: ({code, log})->
        @uploadError = true
        @uploaded = @file.name
        @errorLog = log
        @reset

    error: (err)->
        @$scope.$emit "Upload Error"

    clearAlerts: ->
        @uploadSuccess = false
        @uploadError = false
        @uploaded = ''
        @errorLog = ''

SubmissionsCtrl.$inject = [
    'fileReader'
    '$scope'
    'students'
    'huntservice'
    'submissionsSvc'
    '$timeout'
    '$window'
    '$cookies'
]

angular.module('teals.submissions.controller', [
    'teals.students.service'
    'teals.hunts.service'
    'teals.submissions.service'
    'ngCookies'
])
.controller(SubmissionsCtrl.name, SubmissionsCtrl)
