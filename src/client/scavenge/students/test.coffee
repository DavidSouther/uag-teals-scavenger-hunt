describe 'Students', ->
    beforeEach module 'teals.students.service'

    describe 'service', ->
        $httpBackend = null
        beforeEach inject (_$httpBackend_)->
            $httpBackend = _$httpBackend_
            $httpBackend.whenGET('/api/students.json')
            .respond 200, JSON.stringify
                students: [
                    {name: 'David Souther', email: 'davidsouther@gmail.com'}
                    {name: 'Thomas Bijesse', email: 'tbijesse@uagateway.com'}
                ]

        afterEach ->
            $httpBackend.verifyNoOutstandingExpectation()
            $httpBackend.verifyNoOutstandingRequest()

        it 'exposes students', inject (students)->
            $httpBackend.expectGET('/api/students.json')
            $httpBackend.flush()
            students.students.length.should.equal 2
