class GradebookCtrl
    constructor: (@service)->

GradebookCtrl.$inject = [
    'gradebook'
]

angular.module('teals.gradebook.directive', [
    'teals.gradebook.service'
    'teals.templates'
])
.filter('letter', -> (points)->
    if points > 90
        return 'A'
    if points > 80
        return 'B'
    if points > 70
        return 'C'
    if points > 60
        return 'D'
    return 'F'
)
.controller(GradebookCtrl.name, GradebookCtrl)
.directive 'gradebook', ->
    restrict: 'EA'
    templateUrl: 'scavenge/gradebook'
    controller: GradebookCtrl.name
    controllerAs: 'gradebook'
