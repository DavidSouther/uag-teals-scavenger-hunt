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
