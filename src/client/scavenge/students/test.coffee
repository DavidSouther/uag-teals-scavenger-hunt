describe 'Students', ->

    describe 'service', ->
        beforeEach module 'teals.students.service'

        $httpBackend = null
        beforeEach inject (_$httpBackend_)->
            $httpBackend = _$httpBackend_
            $httpBackend.whenGET('/api/students.json')
            .respond 200, JSON.stringify
                students: [
                    {
                        name: 'David Souther'
                        email: 'davidsouther@gmail.com'
                        roles: {teacher: true}
                    },
                    {
                        name: 'Thomas Bijesse'
                        email: 'tbijesse@uagateway.com',
                        roles: {}
                    }
                ]

        afterEach ->
            $httpBackend.verifyNoOutstandingExpectation()
            $httpBackend.verifyNoOutstandingRequest()

        it 'exposes students', inject (students)->
            $httpBackend.expectGET('/api/students.json')
            $httpBackend.flush()
            students.students.length.should.equal 2

    describe 'controller', ->
        beforeEach module 'teals.students.directive'

