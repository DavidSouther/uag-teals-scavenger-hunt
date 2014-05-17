global.SUBMISSION_MOCK =
    wire: ($httpBackend)->
        $httpBackend.whenPOST('/api/v1/submissions')
        .respond 200, JSON.stringify
            _id: "5377840498203b595abeb4af"
            accepted: false
            content: "print 'hello'"
            script: "hello.py"
            submitted: (new Date()).toISOString()

        $httpBackend.whenGET('/api/v1/submissions')
        .respond 200, JSON.stringify [{
            "studentEmail": "davidsouther@gmail.com",
            "hunt": "53721703566ad71581679192",
            "script": "hello.py",
            "content": "'''\nfdafdsfadsfsdfas\n'''\nbad python\n",
            "_id": "53721703566ad71581679193",
            "accepted": false,
            "submitted": "2014-05-13T12:58:43.937Z",
            "__v": 0
        }, {
            "studentEmail": "davidsouther@gmail.com",
            "hunt": "53721703566ad71581679194",
            "script": "sumAll.py",
            "content": "'''\nfdafdsfadsfsdfas\n'''\n" +
                "sum = 0\nwhile True:\n\tn = raw_input('Number: ')\n" +
                "\tif n == '':\n\t\nbreak\n\tsum = sum + int(n)\n" +
                "print 'The total is ', sum\n",
            "_id": "53721703566ad71581679195",
            "accepted": false,
            "submitted": "2014-05-13T12:58:43.942Z",
            "__v": 0
        }]
