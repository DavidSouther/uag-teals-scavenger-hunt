describe 'Main', ->
    it 'defines an Angular module', ->
        angular.module('angularApp').should.have.property 'controller'

    describe 'directive', ->
        beforeEach module 'angularApp'

        $element = null
        beforeEach -> $element = render 'app'

        it 'has a main dom node.', ->
            after -> console.log $element.html()
            $element.find('main').length.should.equal 1
