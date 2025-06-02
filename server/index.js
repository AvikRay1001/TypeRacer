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

            const gameID = game._id.toString();
            socket.join(gameID);

            io.to(gameID).emit('updateGame', game);
        } catch (error) {
            console.log(error);
        }
    });

    socket.on('join-game', async({nickname, gameID}) => {
        try {
            console.log(gameID);
            if(!gameID.match(/^[0-9a-fA-F]{24}$/)){
                socket.emit('notCorrectGame', "Please enter a valid game ID");
                return;
            }

            let game = await Game.findById(gameID);
            if(game.isJoin){
                const id = game._id.toString();
                let player = {
                    nickname,
                    socketID: socket.id,
                }
                socket.join(id);
                game.players.push(player);
                game = await game.save();
                io.to(gameID).emit('updateGame', game);
            } else {
                socket.emit('notCorrectGame', "Game is full");
            }
        } catch (error) {
            console.log(error);
        }
    });


    socket.on('timer', async({playerId, gameID}) => {
        console.log("Timer started")
        let countDown = 5;
        let game = await Game.findById(gameID);
        let player = game.players.id(playerId);

        if(player.isPartyLeader) {
            let timerId = setInterval(async() => {
                if(countDown>=0){
                    io.to(gameID).emit('timer',{
                      countDown,
                      msg: "Game is Starting"
                    });
                    console.log(countDown);
                    countDown--;
                } else {
                    game.isJoin = false;
                    game = await game.save();
                    io.to(gameID).emit('updateGame', game);
                    startGameClock(gameID);
                    clearInterval(timerId);
                }
            },1000);
        }
    })
});

const startGameClock = async(gameID) => {
        let game = await Game.findById(gameID);
        game.startTime = new Date().getTime();
        game = await game.save();

        let time = 120;
        let timerId = setInterval((function gameIntervalFunc() {
            if(time>=0){
                const timeFormat = calculateTime(time);
                io.to(gameID).emit('timer', {
                    countDown: timeFormat,
                    msg: `Time Left`
                });
                console.log(time);
                time--;
            }
            return gameIntervalFunc;
        })(),1000)
}


const calculateTime = (time) => {
    let min = Math.floor(time/60);
    let sec = time%60;
    return `${min}:${sec < 10 ? "0" +sec: sec}`;
}



mongooose.connect(DB).then(() => {
    console.log("Connection Successful");
}).catch((err) => {
    console.log(err)
});



server.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});