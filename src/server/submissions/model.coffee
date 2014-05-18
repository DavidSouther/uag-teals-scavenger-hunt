mongoose = require('../db')

Schema = mongoose.Schema
submissionSchema = Schema({
    studentEmail: String # Email student string
    hunt: String # Name of the parent hunt
    script: String # Name of the script
    content: String # Content of the script
    submitted: # Date Submitted most recently
        type: Date
        default: Date.now
    accepted: # Correct or not
        type: Boolean
        default: false
})
Submission = mongoose.model 'submission', submissionSchema

module.exports = Submission
