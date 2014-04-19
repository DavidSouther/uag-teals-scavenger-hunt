describe 'Scavenger', ->
    it 'defines an Angular module', ->
        angular.module('scavengerSubmissions').should.have.property 'controller'

    angular.module('ui.bootstrap', [])
    angular.module('ui.codemirror', [])

    localStorage = {}
    countScript = 'for i in range(1, 6):\n\tprint i\n'
    mockFileReader = ->
        readAsText: (file, scope)->
            promise = null
            inject ($q, $timeout)->
                defer = $q.defer()
                $timeout ->
                    defer.resolve countScript
                promise = defer.promise
            promise

    angular.module('scavengerSubmissions')
    .factory('$window', -> {localStorage})
    .factory('fileReader', mockFileReader)

    prepRequets = ($httpBackend)->
        $httpBackend.whenGET('/assets/students.json')
        .respond 200, JSON.stringify
            students: [
                'David Souther'
                'Thomas Bijesse'
            ]
        $httpBackend.whenGET('/assets/scavengerhunt.json')
        .respond 200, JSON.stringify
            scripts: [{
                name: "hello.py",
                description: "print \"Hello, TEALS UAG!\"",
                points: 4
            },{
                name: "count5.py",
                description: "Print 1 through 5.",
                points: 1
            }]
        $httpBackend.whenPOST('/submissions').respond 200, '{"status": "Success"}'

    getController = do ->
        _ctrl = _http = _scope = undefined
        (scope = _scope, $controller = _ctrl, $httpBackend = _http)->
            _ctrl = $controller
            _http = $httpBackend
            _scope = scope
            $httpBackend.expectGET('/assets/students.json')
            $httpBackend.expectGET('/assets/scavengerhunt.json')
            ctrl = $controller('ScavengerCtrl', {$scope: scope})
            $httpBackend.flush()
            ctrl

    describe 'controller', ->
        ctrl = scope = $timeout = undefined;
        $httpBackend = {}
        beforeEach module 'scavengerSubmissions'
        beforeEach inject ($injector)->
            $timeout = $injector.get('$timeout');
            $httpBackend = $injector.get('$httpBackend')
            prepRequets $httpBackend
            $rootScope = $injector.get('$rootScope')
            scope = $rootScope.$new()
            ctrl = getController(scope, $injector.get('$controller'), $httpBackend)

        afterEach ->
            $httpBackend.verifyNoOutstandingExpectation()
            $httpBackend.verifyNoOutstandingRequest()

        it 'instantiates', ->
            should.exist ctrl

        it 'loads', ->
            ctrl.students.length.should.equal 2
            ctrl.invalid.should.equal false
            ['student', 'script', 'prompt', 'comments'].forEach (field)->
                ctrl[field].should.equal ''

        it 'rejects unknown files', ->
            ctrl.file = {name: 'unknown.py'}
            ctrl.loadScript()
            ctrl.invalid.should.equal true

        it 'loads good files', ->
            ctrl.file = {name: 'count5.py'}
            ctrl.loadScript()
            $timeout.flush()
            ctrl.invalid.should.equal false
            ctrl.script.should.equal countScript

        it 'submits files', ->
            ctrl.file = {name: 'count5.py'}
            ctrl.loadScript()
            $timeout.flush()
            ctrl.submit()
            $httpBackend.flush()
            ctrl.uploadSuccess.should.equal true
            $timeout.flush()
            should.not.exist ctrl.uploadSuccess

        it 'saves current student', ->
            scope.$apply ->
                ctrl.student = ctrl.students[0]
            ctrl.student.should.equal 'David Souther'
            localStorage.student.should.equal 'David Souther'
            ctrl = getController()
            ctrl.student.should.equal 'David Souther'
