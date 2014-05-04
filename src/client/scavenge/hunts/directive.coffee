class HuntsCtrl
    constructor: (@huntservice)->
        @hunts = @huntservice.hunts

HuntsCtrl.$inject = [
    'huntservice'
]

angular.module('teals.hunts.directive', [
    'teals.hunts.service'
    'teals.templates'
])
.controller(HuntsCtrl.name, HuntsCtrl)
.directive 'huntlist', ->
    restrict: 'EA'
    templateUrl: 'scavenge/hunts'
    controller: HuntsCtrl.name
    controllerAs: 'hunts'
