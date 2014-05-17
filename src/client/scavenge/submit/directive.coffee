angular.module('teals.submissions.directive', [
    'teals.templates'
    'teals.submissions.controller'
    'teals.scavenger.fileInput'
    'teals.scavenger.fileReader'
])
.directive 'submissions', ->
    restrict: 'EA'
    templateUrl: 'scavenge/submit'
    controller: SubmissionsCtrl.name
    controllerAs: 'submit'
