class Student
    constructor: ({@name, @email, @roles}, @$http, @$rootScope, @$timeout)->
        @saved = {success: false, failure: false}

    save: ->
        success = =>@saved.success = true
        failure = =>@saved.failure = true
        clear = => @$timeout (=> @saved.success = @saved.failure = false), 8e3
        @$http.post('/api/students/save', {@name, @email, @roles})
        .then(success, failure)
        .then(clear)

class StudentService
    constructor: ($http, $rootScope, $timeout)->
        @students = []
        $http.get('/api/students.json').then (_)=>
            @students =
                for student in _.data.students
                    new Student(student, $http, $rootScope, $timeout)

    saveAll: ->
        student.save() for student in @students

StudentService.$inject = [
    '$http'
    '$rootScope'
    '$timeout'
]

angular.module('teals.students.service', [])
.service 'students', StudentService
