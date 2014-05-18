describe 'Submissions', ->
    beforeEach module 'teals.submissions.service'

    $httpBackend = null
    beforeEach inject (_$httpBackend_)->
        $httpBackend = _$httpBackend_
        global.SUBMISSION_MOCK.wire $httpBackend

    describe 'Service', ->
        it 'loads all submissions', inject (submissionsSvc)->
            $httpBackend.expectGET('/api/v1/submissions')
            $httpBackend.flush()
            submissionsSvc.submissions.length.should.equal 2

        it 'saves submissions', inject (submissionsSvc)->
            submission =
                studentEmail: 'davidsouther@gmail.com'
                hunt: "Intro"
                script: "hello.py"
                content: "print 'hello'"
            submissionsSvc.submit(submission)
            $httpBackend.flush()
            submissionsSvc.submissions.length.should.equal 3
