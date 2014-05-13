class SubmissionsSvc
    constructor: ($resource)->
        Submission = $resource('/api/v1/submissions')
        @submissions = Submission.query()

SubmissionsSvc.$inject = [
    '$resource'
]

angular.module('teals.submissions.service', [
    'ngResource'
]).service 'submissionsSvc', SubmissionsSvc
