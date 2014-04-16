describe 'Main', ->
    it 'defines an Angular module', ->
        angular.module('angularApp').should.have.property 'controller'

    describe 'directive', ->
        beforeEach module 'angularApp', 'main'

        $element = null
        beforeEach -> $element = render 'app'

        it 'has a main dom node.', ->
            ## after() is great for debugging
            # after -> console.log $element.html()
            $element.find('main').length.should.equal 1
            $element.text().indexOf('TEALS')
            .should.be.greaterThan -1
