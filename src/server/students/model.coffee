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

module.exports = Student
