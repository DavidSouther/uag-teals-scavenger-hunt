describe 'Submissions', ->
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

    getController = do ->
        _ctrl = _scope = undefined
        (scope = _scope, $controller = _ctrl)->
            _ctrl = $controller
            _scope = scope
            ctrl = $controller('SubmissionsCtrl', {$scope: scope})
            scope.$digest()
            ctrl

    angular.module('teals.fileInput.directive.override', [])
    .directive 'fileInput', ->
        restrict: 'EA'
        template: '<span></span>'
        replace: true
        terminal: true
        priority: 10000
    .directive 'input', ->
        restrict: 'E'
        template: '<span></span>'
        replace: true
        terminal: true
        priority: 10000

    testOverride = ($provide)->
        # $provide.value '$window', {localStorage}
        $provide.value 'fileReader', mockFileReader
        $provide.value 'students',
            students: ['David Souther', 'Thomas Bijesse']
        $provide.value 'huntservice',
            checkScriptName: (name)->
                name in ["hello.py", "count5.py"]
            itemList: [
                name: "hello.py"
                description: "print \"Hello, TEALS UAG!\""
                points: 4
            ,
                name: "count5.py"
                description: "Print 1 through 5."
                points: 1
            ]
            items:
                "hello.py":
                    name: "hello.py"
                    description: "print \"Hello, TEALS UAG!\""
                    points: 4
                "count5.py":
                    name: "count5.py"
                    description: "Print 1 through 5."
                    points: 1
        undefined

    beforeEach module(
        'teals.submissions.directive'
        'teals.fileInput.directive.override'
        testOverride
    )

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

            $httpBackend = $injector.get('$httpBackend')
            $httpBackend.whenPOST('/submissions')
            .respond 200, '{"status": "success", "log": ""}'

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
            $httpBackend.expectPOST('/submissions')
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

    describe 'directive', ->
        it 'renders', ->
            $element = render 'submissions'
            should.exist $element, 'Element rendered'
            $element.find('div').length.should.be.greaterThan 3
