describe 'Footer', ->
    beforeEach module 'teals.footer.directive'

    describe 'controller', ->
        afterEach inject ($cookies)->
            delete $cookies[key] for own key of $cookies

        $controller = null
        beforeEach inject (_$controller_)->
            $controller = _$controller_

        it 'starts logged out', ->
            footerCtrl = $controller('FooterCtrl')
            footerCtrl.loggedin.should.equal false
            footerCtrl.admin.should.equal false

        it 'checks the li cookie', inject ($cookies)->
            $cookies.li = '1'
            footerCtrl = $controller('FooterCtrl', {$cookies})
            footerCtrl.loggedin.should.equal true
            footerCtrl.admin.should.equal false


    describe 'directive', ->
        it 'renders', ->
            $element = render('footer')
            $element.find('a').length.should.equal 1

        it 'can be logged in', inject ($cookies)->
            $cookies.li = '1'
            $element = render('footer')
            $element.find('a').length.should.equal 2
