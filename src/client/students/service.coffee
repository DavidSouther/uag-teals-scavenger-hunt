class StudentService
    constructor: (@$http)->
        @students = {}
        @$http.get('/assets/students.json').then (_)=>
            @students = _.data.students

angular.module('teals.students.service', [])
.service 'students', ($http)->
    new StudentService($http)
