describe 'Nav', ->
    beforeEach module 'teals.nav.directive'

    describe 'controller', ->
        debugger
        describe 'sets page state.', ->
            controller = null
            beforeEach inject ($controller, $rootScope)->
                $location = {path: -> '/'}
                controller = $controller('NavCtrl', {$rootScope, $location})
                $rootScope.$broadcast '$locationChangeSuccess'

            it 'sets page', ->
                controller.page.should.equal('submit')

            it 'handles several pages', ->
                controller.setLocation('/leaderboard')
                controller.page.should.equal('leaders')

                (->controller.setLocation('/bad'))
                .should.throw.Error

                controller.setLocation('')
                controller.page.should.equal('submit')

    describe 'directive', ->
        it 'renders', ->
            $element = render('topnav')
            $element.find('a').length.should.equal 2
