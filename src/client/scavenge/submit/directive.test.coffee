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
        $provide.value 'huntservice', global.HUNT_SERVICE
        undefined

    beforeEach module(
        'teals.submissions.directive'
        'teals.fileInput.directive.override'
        testOverride
    )

    $httpBackend = null
    beforeEach inject (_$httpBackend_)->
        $httpBackend = _$httpBackend_
        global.SUBMISSION_MOCK.wire $httpBackend

    describe 'directive', ->
        it 'renders', ->
            $element = render 'submissions'
            $httpBackend.flush()
            should.exist $element, 'Element rendered'
            $element.find('div').length.should.be.greaterThan 3
