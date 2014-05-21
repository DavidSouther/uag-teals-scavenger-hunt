angular.module('teals.grading.directive', [
    'teals.templates'
    'teals.grading.controller'
])
.directive 'grading', ->
    restrict: 'EA'
    templateUrl: 'scavenge/submit/grading'
    controller: GradingCtrl.name
    controllerAs: 'grading'
