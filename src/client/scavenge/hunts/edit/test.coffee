describe 'Scavenger Hunts', -> describe 'Editor', ->
    beforeEach module 'teals.hunts.editor.directive', ($provide)->
        $provide.value global.HUNT_SERVICE
        undefined

    describe 'controller', ->
        getController = do ->
            _ctrl = _scope = undefined
            (scope = _scope, $controller = _ctrl)->
                _ctrl = $controller
                _scope = scope
                ctrl = $controller('SubmissionsCtrl', {$scope: scope})
                scope.$digest()
                ctrl


    describe 'directive', ->
        it 'Renders', ->
            $element = render 'scripts-validator'
            $element.find('form').length.should.equal 1
