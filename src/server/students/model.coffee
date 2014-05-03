mongoose = require('../db')

studentSchema = mongoose.Schema({
    name: String
    email: String
    token: String
})
Student = mongoose.model 'student', studentSchema

Student.findAll = ->
    Student.findQ().then (students)->
        { students: students.map (_)-> {name: _.name, email: _.email } }

module.exports = Student
