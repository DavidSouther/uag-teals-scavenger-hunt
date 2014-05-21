class GradingCtrl
    constructor: (@submissionSvc, @huntSvc)->
        @byStudent = {}
        @submissionSvc.submissions.$promise.then =>
            reduction = (red, sub)->
                (red[sub.studentEmail] = red[sub.studentEmail] || []).push sub
                red

            @submissionSvc.submissions.reduce(reduction, @byStudent)

GradingCtrl.$inject = [
    'submissionsSvc'
    'huntservice'
]

angular.module('teals.grading.controller', [
    'teals.submissions.service'
    'teals.hunts.service'
]).controller(GradingCtrl.name, GradingCtrl)
