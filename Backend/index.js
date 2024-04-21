const express = require("express");
app = express();
const port = 3000;
const db = require("./db");
const mongoose = require("mongoose");
const body_parser = require('body-parser');
app.use(body_parser.json());



const userRouter = require('./user.routes');

app.use("/",userRouter);


app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
})
