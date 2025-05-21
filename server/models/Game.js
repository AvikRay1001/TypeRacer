const mongooose = require('mongoose');
const playerSchema = require('./Player');

const gameSchema = new mongooose.Schema({
    words: [
        {

            type: String,
        }
    ],
    players: [playerSchema],
    isJoin: {
        type: Boolean,
        default: true,
    },
    isOver: {
        type: Boolean,
        default: false,
    },
    startTime: {
        type: Number,
    },
});



const gameModel = mongooose.model('Game', gameSchema);

module.exports = gameModel;