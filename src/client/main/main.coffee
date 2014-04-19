angular.module('scavengerSubmissions', ['ui.bootstrap', 'ui.codemirror'])

class ScavengerCtrl
    constructor: (@fileReader, @$scope, @$http, @$timeout, @$window)->
        @reset(false)
        @students = []
        @items = {}
        @$http.get('/assets/students.json').then (_)=> @students = _.data.students
        @$http.get('/assets/scavengerhunt.json').then (_)=>
            @items = _.data.scripts
            @itemList = @items.reduce ((a, b)->a[b.name] = b; a), {}

        @$scope.$watch (=>@student), (o, n)=>
            @$window.localStorage.student = @student unless o is n

    loadScript: ->
        if not @checkScriptName(@file.name)
            @$scope.$broadcast "Invalid Script Name: #{@file.name}"
            @invalid = true
            return
        @fileReader.readAsText(@file, @$scope)
        .then (result)=> @handleScript(result)

    handleScript: (result)->
        @invalid = false
        @script = result
        program = @itemList[@file.name]
        @prompt = program.description
        @points = program.points

    checkScriptName: (name)->
        @itemList[name]?

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
            (_)=> @success(_)
            (_)=> @failure(_)
        )

    success: (confirm)->
        @$scope.$emit 'Upload Success'
        @uploadSuccess = true
        @uploaded = @file.name
        fadeOut = =>
            @$scope.$apply =>
                @uploadSuccess = undefined
                @uploaded = ''
        @$timeout fadeOut, 2000
        @reset()

    failure: (err)->
        @$scope.$emit "Upload Failed"

ScavengerCtrl.$inject = ['fileReader', '$scope', '$http', '$timeout', '$window']


angular.module('scavengerSubmissions')
.controller ScavengerCtrl.name, ScavengerCtrl
