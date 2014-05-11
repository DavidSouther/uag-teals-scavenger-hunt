describe 'Students', ->

    describe 'service', ->
        beforeEach module 'teals.students.service'

        $httpBackend = null
        beforeEach inject (_$httpBackend_)->
            $httpBackend = _$httpBackend_
            $httpBackend.whenGET('/api/v1/students')
            .respond 200, JSON.stringify [
                name: 'David Souther'
                email: 'davidsouther@gmail.com'
                roles: {teacher: true}
            ,
                name: 'Thomas Bijesse'
                email: 'tbijesse@uagateway.com',
                roles: {}
            ]

        afterEach ->
            $httpBackend.verifyNoOutstandingExpectation()
            $httpBackend.verifyNoOutstandingRequest()

        it 'exposes students', inject (_students_)->
            studentsvc = _students_
            $httpBackend.expectGET('/api/v1/students')
            $httpBackend.flush()
            studentsvc.students.length.should.equal 2, '2 students'

    describe 'controller', ->
        beforeEach module 'teals.students.directive'
