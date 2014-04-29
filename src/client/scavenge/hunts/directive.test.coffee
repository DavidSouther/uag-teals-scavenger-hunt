angular.module('teals.hunts.service.mock', [])
.config ($provide)->
    $provide.value 'huntservice',
        checkScriptName: (name)->
            name in ["hello.py", "count5.py"]
        loaded: then: (fn)->fn()
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

describe 'Scavenger Hunts', ->
    beforeEach module 'teals.hunts.directive', 'teals.hunts.service.mock'

    describe 'Directive', ->
        it 'Renders', ->
            $element = render 'huntlist'
            $element.find('tr').length.should.equal 3
