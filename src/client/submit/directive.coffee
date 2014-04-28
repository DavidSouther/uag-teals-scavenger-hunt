class SubmissionsCtrl
    constructor: (
        @fileReader
        @$scope
        @students
        @huntservice
        @$http
        @$timeout
        @$window
    )->
        @reset(false)

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
        program = @huntservice.items[@file.name]
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
        @$http.post('/submissions', {
            name: @student
            file: @file.name
            script: "'''\n#{@comments}\n'''\n#{@script}"
        }).then(
            (_)=>
                if _.data.status is 'success'
                    @success(_.data)
                else
                    @failure(_.data)
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
    '$http'
    '$timeout'
    '$window'
]

angular.module('teals.submissions.directive', [
    'teals.templates'
    'teals.students.service'
    'teals.hunts.service'
    'teals.scavenger.fileInput'
    'teals.scavenger.fileReader'
])
.controller(SubmissionsCtrl.name, SubmissionsCtrl)
.directive 'submissions', ->
    restrict: 'EA'
    templateUrl: 'submit'
    controller: SubmissionsCtrl.name
    controllerAs: 'hunt'
