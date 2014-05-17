class SubmissionsSvc
    constructor: ($resource)->
        @Submission = $resource('/api/v1/submissions')
        @submissions = @Submission.query()

    submit: (data)->
        (new @Submission(data)).$save()

SubmissionsSvc.$inject = [
    '$resource'
]

angular.module('teals.submissions.service', [
    'ngResource'
]).service 'submissionsSvc', SubmissionsSvc
