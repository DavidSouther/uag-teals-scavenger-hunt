describe 'Leaders', ->
    mockLeaders =
        "DavidSouther": [
            "count5.py",
            "sumAll.py"
        ]

    describe 'Service', ->
        beforeEach module 'teals.leaders.service', 'teals.hunts.service.mock'
        $httpBackend = null
        beforeEach inject (_$httpBackend_)->
            $httpBackend = _$httpBackend_
            $httpBackend.whenGET('/leaders')
            .respond 200, JSON.stringify mockLeaders

            $httpBackend.expectGET('/leaders')

        afterEach ->
            $httpBackend.verifyNoOutstandingExpectation()
            $httpBackend.verifyNoOutstandingRequest()

        it 'loads the leaderboard', inject (leaderservice)->
            should.exist leaderservice.leaders
            $httpBackend.flush()
            leader = leaderservice.leaders[0]
            leader.name.should.equal 'DavidSouther'
            leader.programs.length.should.equal 2

        it 'calculates points in the leaderboard', inject (leaderservice)->
            $httpBackend.flush()
            leaderservice.leaders[0].points.should.equal 1
            leaderservice.leaders[0].tickets.should.equal 1

    describe 'filter', ->
        beforeEach module 'teals.leaders.service'

        it 'expands names correctly', inject ($filter)->
            $filter('expandName')('DavidSouther')
            .should.equal 'David Souther'

            $filter('expandName')('KylanBarrajanos Powe')
            .should.equal 'Kylan Barrajanos Powe'

    describe.skip 'Controller', ->
        beforeEach 'teals.leaders.directive', ($provide)->
            $provide.value 'leaderservice', mockLeaders

    describe 'Directive', ->
        beforeEach module 'teals.leaders.directive', 'teals.hunts.service.mock',
            ($provide)->
                $provide.value 'leaderservice', {leaders: mockLeaders}
                undefined

        it 'shows the leader board', ->
            $element = render 'leaders'
            should.exist $element
            $element.find('td').length.should.be.greaterThan 1
