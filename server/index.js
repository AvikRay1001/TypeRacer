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


    socket.on('userInput', async({userInput, gameID}) => {
        console.log("Hello from userInput socket");
        console.log(userInput);
        let game = await Game.findById(gameID);
        if(!game.isJoin && !game.isOver) {
            let player = game.players.find(
                (playerr) => playerr.socketID === socket.id
            );
            if(game.words[player.currentWordIndex] === userInput.trim()) {
                player.currentWordIndex = player.currentWordIndex + 1;
                if(player.currentWordIndex !== game.words.length) {
                    game = await game.save();
                    io.to(gameID).emit('updateGame', game);
                }
            } else {
                let endTime = new Date().getTime();
                let {startTime} = game;
                player.WPM = calculateWPM(endTime, startTime, player);
                game = await game.save();
                socket.emit('done');
                io.to(gameID).emit('updateGame', game);
            }
        }
    })

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
            } else {
                (async() => {
                    try {
                        let endTime = new Date().getTime();
                        let game = await Game.findById(gameID);
                        let {startTime} = game;
                        game.isOver = true;
                        game.players.forEach((player, index) => {
                            if(player.WPM === -1){
                                game.players[index].WPM = calculateWPM(endTime, startTime, player);
                            }
                        })
                        game = await game.save();
                        io.to(gameID).emit('updateGame', game);
                        clearInterval(timerId);
                    } catch (error) {
                        console.log(error);
                    }
                })();
            }
            return gameIntervalFunc;
        })(),1000)
}


const calculateTime = (time) => {
    let min = Math.floor(time/60);
    let sec = time%60;
    return `${min}:${sec < 10 ? "0" +sec: sec}`;
}

const calculateWPM = (endTime, startTime, player) => {
    const timeTakenInSec = (endTime - startTime)/1000;
    const timeTaken = timeTakenInSec/60;
    let wordsTyped = player.currentWordIndex;
    const WPM = Math.floor(wordsTyped/timeTaken);
    return WPM;
}

mongooose.connect(DB).then(() => {
    console.log("Connection Successful");
}).catch((err) => {
    console.log(err)
});



server.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});