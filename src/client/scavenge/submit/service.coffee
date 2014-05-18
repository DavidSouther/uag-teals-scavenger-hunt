class SubmissionsSvc
    constructor: ($resource, @$cookies)->
        @Submission = $resource('/api/v1/submissions')
        @submissions = @Submission.query()

    submit: (data)->
        (submission = new @Submission(data)).$save()
        .then =>
            @submissions.push submission
            submission

SubmissionsSvc.$inject = [
    '$resource'
    '$cookies'
]

angular.module('teals.submissions.service', [
    'ngResource'
    'ngCookies'
]).service 'submissionsSvc', SubmissionsSvc
