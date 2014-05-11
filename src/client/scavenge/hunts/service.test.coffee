describe 'Scavenger Hunts', ->
    beforeEach module 'teals.hunts.service'

    $httpBackend = null
    beforeEach inject (_$httpBackend_)->
        $httpBackend = _$httpBackend_
        $httpBackend.expectGET('/api/v1/hunts')
        $httpBackend.whenGET('/api/v1/hunts')
        .respond 200, JSON.stringify [
            name: 'Intro'
            scripts: [
                name: "hello.py",
                description: "print \"Hello, TEALS UAG!\"",
                points: 4
            ,
                name: "count5.py",
                description: "Print 1 through 5.",
                points: 1
            ]
        ]

    afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

    describe 'Service', ->
        it 'has an item list', inject (huntservice)->
            should.exist huntservice.hunts
            $httpBackend.flush()
            Object.keys(huntservice.hunts[0])
            .should.deep.equal ['name', 'scripts', '_map']
            huntservice.hunts[0].scripts[1].idx.should.equal 2, 'idx'

        it 'checks files', inject (huntservice)->
            $httpBackend.flush()
            huntservice.checkScriptName('hello.py').should.equal true
            huntservice.checkScriptName('sumALL.py').should.equal false
