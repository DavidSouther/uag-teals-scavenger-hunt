db = require('../db')
Schema = db.Schema

huntSchema = Schema
    name: String
    scripts: [
        name: String
        description: String
        points: Number
    ]

Hunts = db.model 'hunts', huntSchema

module.exports = Hunts
