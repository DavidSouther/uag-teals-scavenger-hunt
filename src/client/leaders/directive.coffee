class LeadersService
    constructor: (@huntservice, $http)->
        @leaders = []
        $http.get('/leaders').then (response)=>
            @parseLeaders response.data

    parseLeaders: (leadersList)->
        @huntservice.loaded.then =>
            for own leader, programs of leadersList
                @leaders.push @buildLeader(leader, programs)

    buildLeader: (name, programs)->
        points = @points(programs)
        tickets = @tickets(points)

        {name, programs, points, tickets, finished: programs.length}

    points: (programs)->
        reduction = (points, program)=>
            points += @huntservice.items[program]?.points || 0
        programs.reduce reduction, 0

    tickets: (points)->
        Math.ceil(points / 10)

ExpandFilter = (name)->
    return "" unless name
    [name, first, last] = name.match /([A-Z][a-z]+)([a-zA-Z\s]+)/
    "#{first} #{last}"

class LeadersCtrl
    constructor: (@leaderservice)->
        @leaders = @leaderservice.leaders

LeadersCtrl.$inject = [
    'leaderservice'
    'huntservice'
]

angular.module('teals.leaders.service', [])
.filter('expandName', ->ExpandFilter)
.service 'leaderservice', (huntservice, $http)->
    new LeadersService huntservice, $http


angular.module('teals.leaders.directive', [
    'teals.leaders.service'
    'teals.hunts.service'
    'teals.templates'
    'th.sort'
])
.controller('LeadersCtrl', LeadersCtrl)
.directive 'leaders', ->
    restrict: 'EA'
    templateUrl: 'leaders'
    controller: 'LeadersCtrl'
    controllerAs: 'leaders'
