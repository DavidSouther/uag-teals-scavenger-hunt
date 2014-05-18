class SubmissionsSvc
    constructor: ($resource)->
        @Submission = $resource('/api/v1/submissions')
        @submissions = @Submission.query()

    submit: (data)->
        (submission = new @Submission(data)).$save()
        .then =>
            @submissions.push submission
            submission

SubmissionsSvc.$inject = [
    '$resource'
]

angular.module('teals.submissions.service', [
    'ngResource'
]).service 'submissionsSvc', SubmissionsSvc
