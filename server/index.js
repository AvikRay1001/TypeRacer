const express = require('express');
const http = require('http');
const mongooose = require('mongoose');
const Game = require('./models/Game');
const getSentence = require('./api/getSentence');


const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
var io = require('socket.io')(server);

app.use(express.json());

const DB = "mongodb+srv://avikray1010:Eq1rFqVD2p5n0pc0@cluster0.ho22kii.mongodb.net/";



io.on('connection', (socket) => {
    console.log(`User Connected: ${socket.id}`);       
    socket.on('create-game', async({nickname}) => {
        try {
            let game = new Game();
            const sentence = await getSentence();
            game.words = sentence;
            let player = {
                socketID: socket.id,
                nickname: nickname,
                isPartyLeader: true,
            };
            game.players.push(player);
            game = await game.save();

            const gameId = game._id.toString();
            socket.join(gameId);

            io.to(gameId).emit('updateGame', game);
        } catch (error) {
            console.log(error);
        }
    })
});



mongooose.connect(DB).then(() => {
    console.log("Connection Successful");
}).catch((err) => {
    console.log(err)
});



server.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});