fs = require 'fs'
path = require 'path'
Hunts = require '../../hunts/model'
Submissions = require '../model'
Students = require '../../students/model'
logger = require('../../logger').log

mongoose = require 'mongoose'

SUBMISSIONS_DIR = process.argv[2]

unless SUBMISSIONS_DIR
    logger.warn 'Need a submissions directory!'
    return

saveSubmission = (submission)->
    submission.saveQ().then ->
        logger.info "Saved #{submission.script} for #{submission.studentEmail}!"

saveStudentSubmissions = (student, dir, hunt)->
    (submittedFile)->
        submittedFile = path.join dir, submittedFile
        logger.info "Saving #{submittedFile}..."
        fs.readFile submittedFile, (err, data)->
            return logger.error(err) if err
            submission = new Submissions({
                studentEmail: student.email # Email student string
                hunt: mongoose.Types.ObjectId hunt._id
                script: submittedFile.match(/\/([^\/]+)$/)[1]
                content: data
            })
            logger.info "Saving submission..."
            logger.data JSON.stringify submission
            saveSubmission submission

loadStudentSubmissions = (hunt)-> (studentDir)->
    studentDir = path.join SUBMISSIONS_DIR, studentDir
    logger.info "Loading #{studentDir}..."
    name = Students.expandName(studentDir)
    Students.findOneQ({name})
    .then (student)->
        logger.info "Loaded #{student.name}!"
        logger.data JSON.stringify student
        fs.readdir studentDir, (err, list)->
            return logger.error(err) if err
            list.forEach saveStudentSubmissions(student, studentDir, hunt)
    .fail (err)->
        logger.error "Couldn't find #{name}!"
        throw new Exception "Student #{name} not found"

loadSubmissions = (hunt)->
    submissionsDir = path.join SUBMISSIONS_DIR
    logger.info "Loading submissions from #{submissionsDir}..."
    fs.readdir submissionsDir, (err, list)->
        return logger.error(err) if err
        list.forEach loadStudentSubmissions(hunt)

Hunts.findQ({name: "Intro"})
.then (hunt)->
    loadSubmissions hunt
.fail (err)->
    logger.error 'Exception loading submissions!'
    logger.data err
    logger.data arguments
    throw err

undefined
