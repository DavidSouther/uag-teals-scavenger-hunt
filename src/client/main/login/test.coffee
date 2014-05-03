describe 'Login', ->
    beforeEach module 'teals.login.directive'

    describe 'controller', ->
        controller = null
        beforeEach inject ($controller)->
            controller = $controller('LoginCtrl', {})

        it 'exists', ->
            should.exist controller

    describe 'directive', ->
        it 'renders', ->
            $element = render('login')
            $element.find('a').length.should.equal 1
