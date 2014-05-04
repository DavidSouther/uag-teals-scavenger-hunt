class HuntEditCtrl
    constructor: (@$http, $scope)->
        @parsedContent = {name: "Intro", scripts: []}
        @content = JSON.stringify(@parsedContent, null, '\t')
        @name = @parsedContent.name
        @parses = true

        # $scope.$watch @name, =>@parse()
        $scope.$watch (=>@content), (ov, nv)=>
            @parse() unless ov is undefined or ov is nv

    parse: ->
        try
            # throw new Error unless @name.length > 0
            @parsedContent = JSON.parse @content
            throw new Error unless @parsedContent.scripts instanceof Array
            @parsedContent.name = @name
            @parses = true
        catch e
            @parses = false

    save: ->
        return unless @parses and @name.length > 0
        @saved = {success: false, failure: false}
        @$http.post('/api/hunts/save', @parsedContent)
        .then (=>@saved.success = true), (=> @saved.failure = true)

HuntEditCtrl.$inject = [
    '$http'
    '$scope'
]

angular.module('teals.hunts.editor.directive', [
]).controller('HuntEditCtrl', HuntEditCtrl)
.directive 'huntEditor', ->
    replace: false
    restrict: 'AE'
    controller: 'HuntEditCtrl'
    controllerAs: 'hunteditor'
    templateUrl: 'scavenge/hunts/edit'
