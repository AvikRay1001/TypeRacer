const express = require('express');
const http = require('http');
const mongooose = require('mongoose');


const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);


app.use(express.json());



server.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});