describe 'Scavenger Hunts', ->
    beforeEach module 'teals.hunts.directive', ($provide)->
        $provide.value 'huntservice', global.HUNT_SERVICE
        undefined

    describe 'Directive', ->
        it 'Renders', ->
            $element = render 'huntlist'
            # Two for the header, two for the scripts.
            $element.find('tr').length.should.equal 2 + 2
