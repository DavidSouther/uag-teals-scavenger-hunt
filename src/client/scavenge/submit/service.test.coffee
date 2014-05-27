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

        it 'parses programs', inject (submissionsSvc)->
            program = "'''\ncomment\n'''\nprogram\nprogram"
            parsed = submissionsSvc.splitComment program

            parsed.length.should.equal 3
            parsed[1].should.equal 'comment'
            parsed[2].should.equal 'program\nprogram'

        it 'parses programs with several lines of commentary',
            inject (submissionsSvc)->
                program = """'''\nraw input\nhave colors\nmorelines\n'''
x = raw_input("what is your favorite colour?")"""
                parsed = submissionsSvc.splitComment program
                parsed.length.should.equal 3
                parsed[1].should.equal "raw input\nhave colors\nmorelines"
                parsed[2].should.equal(
                    'x = raw_input("what is your favorite colour?")'
                )
