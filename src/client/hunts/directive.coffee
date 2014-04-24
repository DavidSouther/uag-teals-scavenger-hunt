class HuntsCtrl
    constructor: (@huntservice)->
        @itemList = @huntservice.itemList

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
    templateUrl: 'hunts'
    controller: HuntsCtrl.name
    controllerAs: 'hunt'
