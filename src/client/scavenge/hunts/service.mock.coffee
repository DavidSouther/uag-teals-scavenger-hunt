global.HUNT_SERVICE =
    loaded: then: (fn)->fn()
    hunts: [
        name: 'Intro'
        scripts: [
            name: "hello.py",
            description: "print \"Hello, TEALS UAG!\"",
            points: 4
        ,
            name: "count5.py",
            description: "Print 1 through 5.",
            points: 1
        ]
        _items:
            "hello.py":
                name: "hello.py",
                description: "print \"Hello, TEALS UAG!\"",
                points: 4
            "count5.py":
                name: "count5.py",
                description: "Print 1 through 5.",
                points: 1
    ]

    findScript: (name)->
        @hunts[0]._items[name]

    checkScriptName: (name)->
        name in ['hello.py', 'count5.py']
