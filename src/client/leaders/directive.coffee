class LeadersService
    constructor: (@huntservice, $http)->
        @leaders = {}
        $http.get('/leaders').then (response)=>
            @parseLeaders response.data

    parseLeaders: (leadersList)->
        @huntservice.loaded.then =>
            for own leader, programs of leadersList
                @leaders[leader] =
                    programs: programs
                    points: @points(programs)

    points: (programs)->
        reduction = (points, program)=>
            points += @huntservice.items[program]?.points || 0
        programs.reduce reduction, 0

class LeadersCtrl
    constructor: (@leaderservice)->
        @leaders = @leaderservice.leaders

LeadersCtrl.$inject = [
    'leaderservice'
    'huntservice'
]

angular.module('teals.leaders.service', [])
.service 'leaderservice', (huntservice, $http)->
    new LeadersService huntservice, $http

angular.module('teals.leaders.directive', [
    'teals.leaders.service'
    'teals.hunts.service'
    'teals.templates'
])
.controller('LeadersCtrl', LeadersCtrl)
.directive 'leaders', ->
    restrict: 'EA'
    templateUrl: 'leaders'
    controller: 'LeadersCtrl'
    controllerAs: 'leaders'
