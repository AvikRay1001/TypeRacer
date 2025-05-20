const express = require('express');
const http = require('http');
const mongooose = require('mongoose');


const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
var io = require('socket.io')(server);


app.use(express.json());

const DB = "mongodb+srv://avikray1010:Eq1rFqVD2p5n0pc0@cluster0.ho22kii.mongodb.net/";

io.on('connection', (socket) => {
    console.log(socket.id);
});



mongooose.connect(DB).then(() => {
    console.log("Connection Successful");
}).catch((err) => {
    console.log(err)
});

server.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});