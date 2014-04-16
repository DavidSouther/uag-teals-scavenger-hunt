describe 'Main', ->
    it 'defines an Angular module', ->
        angular.module('scavengerSubmissions').should.have.property 'controller'

    describe 'directive', ->
        beforeEach module 'scavengerSubmissions', 'main'

        $element = null
        beforeEach -> $element = render 'app'

        it.skip 'has a main dom node.', ->
            ## after() is great for debugging
            # after -> console.log $element.html()
            $element.find('main').length.should.equal 1
            $element.text().indexOf('TEALS')
            .should.be.greaterThan -1
