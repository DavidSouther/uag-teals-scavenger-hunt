describe 'Submissions', ->
    getController = do ->
        _ctrl = _scope = undefined
        (scope = _scope, $controller = _ctrl)->
            _ctrl = $controller
            _scope = scope
            ctrl = $controller('SubmissionsCtrl', {$scope: scope})
            scope.$digest()
            ctrl

    countScript = 'for i in range(1, 6):\n\tprint i\n'
    mockFileReader =
        readAsText: (file, scope)->
            promise = null
            inject ($q, $timeout)->
                defer = $q.defer()
                $timeout ->
                    defer.resolve countScript
                promise = defer.promise
            promise

    testOverride = ($provide)->
        $provide.value 'fileReader', mockFileReader
        $provide.value 'students',
            students: ['David Souther', 'Thomas Bijesse']
        $provide.value 'huntservice', global.HUNT_SERVICE
        undefined

    beforeEach module(
        'teals.submissions.controller'
        testOverride
    )

    $httpBackend = null
    beforeEach inject (_$httpBackend_)->
        $httpBackend = _$httpBackend_
        global.SUBMISSION_MOCK.wire $httpBackend

    localStorage = null
    beforeEach inject ($window)->
        localStorage = $window.localStorage
        $window.localStorage.clear()

    describe 'controller', ->
        ctrl = scope = $httpBackend = $timeout = undefined

        beforeEach inject ($injector)->
            $timeout = $injector.get('$timeout')

            $rootScope = $injector.get('$rootScope')
            scope = $rootScope.$new()
            $controller = $injector.get('$controller')
            ctrl = getController(scope, $controller)

        it 'instantiates', ->
            should.exist ctrl

        it 'loads', ->
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
            $httpBackend.expectPOST('/api/v1/submissions')
            ctrl.file = {name: 'count5.py'}
            ctrl.loadScript()
            $timeout.flush()
            ctrl.submit()
            $httpBackend.flush()
            ctrl.uploadSuccess.should.equal true

        it 'saves current student', inject (students)->
            scope.$apply -> ctrl.student = students.students[0]
            ctrl.student.should.equal 'David Souther'
            localStorage.student.should.equal 'David Souther'
            ctrl = getController()
            ctrl.student.should.equal 'David Souther'

        it 'locks student name from cookies', inject ($cookies)->
            $cookies.li = '1'
            $cookies.name = 'David Souther'
            after ->
                delete $cookies.li
                delete $cookies.name
            ctrl = getController()
            ctrl.locked.should.equal true
            ctrl.student.should.equal 'David Souther'
