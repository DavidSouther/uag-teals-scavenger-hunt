mongoose = require('../db')

Schema = mongoose.Schema
studentSchema = Schema({
    name: String
    email: String
    token: String
    roles: {
        teacher: Boolean
    }
})
Student = mongoose.model 'student', studentSchema

Student.findAll = ->
    Student.findQ().then (students)->
        { students: students.map (_)-> {
            name: _.name, email: _.email, roles: _.roles
        } }

module.exports = Student
