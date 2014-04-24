class LeadersCtrl
    constructor: ($http)->
        @leaders = {}
        $http.get('/leaders').then (leaders)=>
            @leaders = leaders.data

angular.module('teals.scavenger.leaders', [
    'teals.templates'
])
.controller('LeadersCtrl', LeadersCtrl)
.directive 'leaders', ->
    restrict: 'E'
    templateUrl: 'leaders'
    controller: 'LeadersCtrl'
    controllerAs: 'leaders'
