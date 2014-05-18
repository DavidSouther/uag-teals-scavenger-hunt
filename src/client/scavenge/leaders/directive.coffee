class LeadersService
    constructor: (@huntservice, @submissionSvc)->
        @leaders = []
        $http.get('/api/leaders').then (response)=>
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
            points += @huntservice.findScript(program)?.points || 0
        programs.reduce reduction, 0

    tickets: (points)->
        Math.ceil(points / 10)

ExpandFilter = (name)->
    return "" unless name
    [name, first, last] = name.match /([A-Z][a-z]+)([a-zA-Z\s]+)/
    "#{first} #{last}"

class LeadersCtrl
    constructor: ($scope, @huntsvc, @submissionsvc, @studentsvc)->
        $scope.$watch @submissionsvc.submissions, =>
            @buildLeaderSet().then => @buildLeaderList()

    buildLeaderSet: ->
        @leaderSet = {}
        @submissionsvc.submissions.$promise.then (submissions)=>
            submissions.forEach (submission)=>
                (
                    @leaderSet[submission.studentEmail] =
                        @leaderSet[submission.studentEmail] || []
                ).push submission

    buildLeaderList: ->
        @leaders = []
        for e, p of @leaderSet
            do (email = e, programs = p)=>
                name = @studentsvc.byEmail(email).name
                programs = programs
                    # .filter((p)->p.accepted)
                    .map((p)=> @huntsvc.findScript(p.script))
                    .filter((p)->p?)
                points = @points(programs)
                tickets = @tickets(points)
                @leaders.push {name, programs, points, tickets}

    points: (programs)->
        reduction = (points, program)=>
            points += @huntsvc.findScript(program.name)?.points || 0
        programs.reduce reduction, 0

    tickets: (points)->
        Math.ceil(points / 10)

LeadersCtrl.$inject = [
    '$scope'
    'huntservice'
    'submissionsSvc'
    'students'
]

angular.module('teals.leaders.service', [])
.service 'leaderservice', (huntservice, $http)->
    new LeadersService huntservice, $http

angular.module('teals.leaders.directive', [
    'teals.students.service'
    'teals.hunts.service'
    'teals.submissions.service'
    'teals.templates'
    'th.sort'
])
.filter('expandName', ->ExpandFilter)
.controller('LeadersCtrl', LeadersCtrl)
.directive 'leaders', ->
    restrict: 'EA'
    templateUrl: 'scavenge/leaders'
    controller: 'LeadersCtrl'
    controllerAs: 'leaders'
