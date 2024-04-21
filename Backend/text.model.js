const db = require('./db');
const UserModel = require("./user.model");
const mongoose = require('mongoose');
const { Schema } = mongoose;

const textSchema = new Schema({
    userId:{
        type: String,
        ref: UserModel.modelName
    },
    topic: {
        type: String,
        required: true
    },
    journey: {
        type: String,
        required: true
    },
    start_date: {
        type: String,
        required: true,
        // Custom date parsing function
    
    },
    end_date: {
        type: String,
        required: true,
        // Custom date parsing function
    },
    completed_tasks:{
        type: Array,
        required: true
    }
},{timestamps:true});

const TextModel = db.model('content',textSchema);
module.exports = TextModel;