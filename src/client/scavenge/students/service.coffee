class StudentService
    constructor: ($resource, $timeout)->
        @Student = $resource('/api/v1/students/:id', {id: '@_id'})
        @students = @Student.query =>
            patchSave = (student)->
                $save = student.$save
                student.$save = ->
                    $save.call student, ->
                        student.saved = {success: true, failure: false}
                        $timeout (-> student.saved = {}), 5000
            @students._map = {}
            # Patch $save
            @students.forEach (student)=>
                patchSave student
                @students._map[student.email] = student

    saveAll: ->
        student.$save() for student in @students

StudentService.$inject = [
    '$resource'
]

angular.module('teals.students.service', [
    'ngResource'
])
.service 'students', StudentService
