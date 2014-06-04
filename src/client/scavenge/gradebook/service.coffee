class GradebookService
    constructor: (@submissions, @hunts, @students, $q)->
        @book = {}
        promises = [
            hunts.loaded
            @submissions.submissions.$promise
            @students.students.$promise
        ]
        $q.all.apply($q, promises)
        .then (huntlist)=> # Huntlist is only one that passes a resolved object
            @rebuild()
            true

    rebuild: ->
        @buildGradebook()
        @curveGradebook()

    buildGradebook: ->
        @submissions.submissions.reduce ((b, s)=>@addSubmission(b, s)), @book

    addSubmission: (book, submission)->
        @confirmStudentIn book, submission
        @confirmHuntForStudent book, submission
        @addPointsToHunt book, submission
        book

    confirmStudentIn: (book, submission)->
        book[submission.studentEmail] or= {}

    confirmHuntForStudent: (book, submission)->
        hunt = @hunts.findHunt submission.script
        book[submission.studentEmail][hunt.name] or= {points: 0}

    addPointsToHunt: (book, submission)->
        hunt = @hunts.findHunt submission.script
        script = @hunts.findScript submission.script
        book[submission.studentEmail][hunt.name].points += script.points

    curveGradebook: ->
        for student, hunts of @book
            for name, hunt of hunts
                if name is 'Intro'
                    hunt.grade = (Math.sqrt(hunt.points) + 1) * 10
                else if name is 'Strings and Integers'
                    hunt.grade = hunt.points
                else
                    hunt.grade = hunt.points

GradebookService.$inject = [
    'submissionsSvc'
    'huntservice'
    'students'
    '$q'
]

angular.module('teals.gradebook.service', [
    'teals.hunts.service'
    'teals.students.service'
    'teals.submissions.service'
]).service 'gradebook', GradebookService
