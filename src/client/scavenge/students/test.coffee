describe 'Students', ->
    beforeEach module 'teals.students.service'

    describe 'service', ->
        $httpBackend = null
        beforeEach inject (_$httpBackend_)->
            $httpBackend = _$httpBackend_
            $httpBackend.whenGET('/assets/students.json')
            .respond 200, JSON.stringify
                students: [
                    'David Souther'
                    'Thomas Bijesse'
                ]

        afterEach ->
            $httpBackend.verifyNoOutstandingExpectation()
            $httpBackend.verifyNoOutstandingRequest()

        it 'exposes students', inject (students)->
            $httpBackend.expectGET('/assets/students.json')
            $httpBackend.flush()
            students.students.length.should.equal 2
