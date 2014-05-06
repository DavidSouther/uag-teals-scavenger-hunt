class HuntEditCtrl
    constructor: ($scope, @huntservice)->
        @hunt = new @huntservice.Hunts({name: "Intro", scripts: []})
        @content = JSON.stringify(@hunt.scripts, null, '\t')
        @parses = true

        reparse = (o, n)=> @parse() unless o in [undefined, n]
        $scope.$watch (=>@name), reparse
        $scope.$watch (=>@content), reparse

    parse: ->
        try
            throw new Error unless @hunt.name.length > 0
            scripts = JSON.parse @content
            throw new Error unless scripts instanceof Array
            @hunt.scripts = scripts
            @parses = true
        catch e
            @parses = false

    save: ->
        return unless @parses
        @saved = {success: false, failure: false}
        @hunt.$save()
        .then (=>@saved.success = true), (=> @saved.failure = true)

HuntEditCtrl.$inject = [
    '$scope'
    'huntservice'
]

ScriptsControl = ->
    require: 'ngModel'
    link: (scope, elem, attrs, control)->
        control.$parsers.unshift (viewVal)->
            valid = yes
            try
                scripts = JSON.parse viewVal
                control.$setValidity 'json', yes
                unless scripts instanceof Array
                    control.$setValidity 'isArray', no
                    valid = no
                else
                    control.$setValidity 'isArray', yes
            catch e
                control.$setValidity 'json', no
                valid = no
            if valid
                viewVal
            else
                undefined

angular.module('teals.hunts.editor.directive', [
]).controller('HuntEditCtrl', HuntEditCtrl)
.directive('scriptsValidator', ScriptsControl)
.directive 'huntEditor', ->
    replace: false
    restrict: 'AE'
    controller: 'HuntEditCtrl'
    controllerAs: 'hunteditor'
    templateUrl: 'scavenge/hunts/edit'
