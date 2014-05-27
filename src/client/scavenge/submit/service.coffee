class SubmissionsSvc
    constructor: ($resource, @$cookies)->
        @Submission = $resource('/api/v1/submissions')
        @submissions = @Submission.query()

    submit: (data)->
        (submission = new @Submission(data)).$save()
        .then =>
            @submissions.push submission
            submission

    splitComment: (submission)->
        submission.match(/'''\n((?:.|[\r\n])*)\n'''\n((?:.|[\r\n])*)/m)

SubmissionsSvc.$inject = [
    '$resource'
    '$cookies'
]

angular.module('teals.submissions.service', [
    'ngResource'
    'ngCookies'
]).service 'submissionsSvc', SubmissionsSvc
