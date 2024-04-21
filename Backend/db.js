const mongoose = require('mongoose');

const connection = mongoose.createConnection("mongodb://localhost:27017/tEST1").on('open', 
()=> {
console.log("MongoDB Connected boy no error at all!!!!");}).on('error',()=>{
    console.log('error boy check your code!!!!');
});

module.exports = connection;