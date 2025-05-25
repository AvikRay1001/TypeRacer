const axios = require('axios');

const getSentence = async () => {
    const response = await axios.get('https://api.animechan.io/v1/quotes/random');
    return response.data.data.content.split(' ');
};

module.exports = getSentence;
