describe 'Scavenger Hunts', ->
    beforeEach module 'teals.hunts.service'

    $httpBackend = null
    beforeEach inject (_$httpBackend_)->
        $httpBackend = _$httpBackend_
        $httpBackend.expectGET('/assets/scavengerhunt.json')
        $httpBackend.whenGET('/assets/scavengerhunt.json')
        .respond 200, JSON.stringify
            scripts: [
                name: "hello.py",
                description: "print \"Hello, TEALS UAG!\"",
                points: 4
            ,
                name: "count5.py",
                description: "Print 1 through 5.",
                points: 1
            ]

    afterEach ->
        $httpBackend.verifyNoOutstandingExpectation()
        $httpBackend.verifyNoOutstandingRequest()

    describe 'Service', ->
        it 'has an item list', inject (huntservice)->
            should.exist huntservice.items
            $httpBackend.flush()
            Object.keys(huntservice.items).length.should.equal 2

        it 'checks files', inject (huntservice)->
            $httpBackend.flush()
            huntservice.checkScriptName('hello.py').should.equal true
            huntservice.checkScriptName('sumALL.py').should.equal false

