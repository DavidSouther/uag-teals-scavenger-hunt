describe 'Scavenger Hunts', ->
    beforeEach module 'teals.hunts.directive', ($provide)->
        $provide.value 'huntservice',
            checkScriptName: (name)->
                name in ["hello.py", "count5.py"]
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

    describe 'Directive', ->
        it 'Renders', ->
            $element = render 'huntlist'
            $element.find('tr').length.should.equal 3
