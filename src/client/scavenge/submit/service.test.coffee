describe 'Submissions', ->
    beforeEach module 'teals.submissions.service'

    $httpBackend = null
    beforeEach inject (_$httpBackend_)->
        $httpBackend = _$httpBackend_
        $httpBackend.whenGET('/api/v1/submissions')
        .respond 200, global.SUBMISSION_MOCK_JSON

    describe 'Service', ->
        it 'loads all submissions', inject (submissionsSvc)->
            $httpBackend.flush()
            submissionsSvc.submissions.length.should.equal 2
