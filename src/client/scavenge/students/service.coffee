class StudentService
    constructor: ($resource)->
        @Student = $resource('/api/v1/students/:id', {id: '@_id'})
        @students = @Student.query =>
            # Patch $save
            @students.forEach (student)->
                $save = student.$save
                student.$save = ->
                    $save.call student, ->
                        student.saved = {success: true, failure: false}
            @students.push @newStudent = new @Student

    saveAll: ->
        student.$save() for student in @students

StudentService.$inject = [
    '$resource'
]

angular.module('teals.students.service', [
    'ngResource'
])
.service 'students', StudentService
