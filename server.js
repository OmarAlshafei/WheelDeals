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

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PATCH, DELETE, OPTIONS');
    next();
  });
  
// app.listen(5000); // start Node + Express server on port 5000
app.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});



app.post('/api/login', async (req, res, next) => {
  // incoming: login, password
  // outgoing: id, firstName, lastName, error
  var error = '';
  const { User, Pass } = req.body;
  const db = client.db('cop4331');
  const results = await db.collection('Users').find({ userName: User, password: Pass }).toArray();
  var id = -1;
  var fn = '';
  var ln = '';
  var em = '';
  if (results.length > 0) {
    id = results[0].id;
    fn = results[0].firstName;
    ln = results[0].lastName;
    em = results[0].email;
  }
  var ret = { id: id, firstName: fn, lastName: ln, email: em, error: '' };
  res.status(200).json(ret);
});
