const moongoose = require('mongoose');

const playerSchema = new moongoose.Schema({
    nickname: {
        type: String,
        required: true,
    },
    currentWordIndex: {
        type: Number,
        default: 0,
    },
    WPM: {
        type: Number,
        default: -1,
    },
    socketID: {
        type: String
    },
    isPartyLeader: {
        type: Boolean,
        default: false,
    },
});

module.exports = playerSchema;