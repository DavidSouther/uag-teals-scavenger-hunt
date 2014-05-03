class StudentCtrl
    constructor: (@service)->

StudentCtrl.$inject = [
    'students'
]

angular.module('teals.students.directive', [
    'teals.students.service'
    'teals.templates'
]).controller('StudentCtrl', StudentCtrl)
.directive 'students', ->
    replace: false
    restrict: 'AE'
    controller: 'StudentCtrl'
    controllerAs: 'students'
    templateUrl: 'scavenge/students'
