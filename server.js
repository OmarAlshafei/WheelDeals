const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const PORT = process.env.PORT || 5000;

const app = express();

app.set('port', (process.env.PORT || 5000))
const MongoClient = require('mongodb').MongoClient;
require('dotenv').config();
const url = process.env.MONGODB_URL;
const client = new MongoClient(url);
client.connect()
app.use(cors());
app.use(bodyParser.json());

if (process.env.NODE_ENV === 'production') {
    // Set static folder
    app.use(express.static('frontend/build'));
    app.get('*', (req, res) => {
        res.sendFile(path.resolve(__dirname, 'frontend', 'build', 'index.html'));
    });
}

// app.listen(5000); // start Node + Express server on port 5000
app.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});

app.post('/api/login', async (req, res, next) => {
});

app.post('/api/register', async (req, res, next) => {
});

