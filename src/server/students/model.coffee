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

Student.expandName = (name)->
    [name, first, last] = name.match /([A-Z][a-z]+)([A-Z].*)/
    "#{first} #{last}"

module.exports = Student
