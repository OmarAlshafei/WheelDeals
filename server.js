// Node.js Dependencies
const express           = require('express');
const bodyParser        = require('body-parser');
const cors              = require('cors');
const path              = require('node:path');
const axios             = require('axios');
const PORT              = process.env.PORT || 9000;
const app               = express();
const MongoClient       = require('mongodb').MongoClient;
const passwordValidator = require('password-validator');
const ObjectId = require("mongodb").ObjectId;

// Environment Variables
require("dotenv").config();
const url = process.env.MONGODB_URL;
const client = new MongoClient(url);
const API_KEY = process.env.REACT_APP_API_KEY;

// Port Configurations
client.connect();
app.set("port", process.env.PORT || 9000);
app.use(cors());
app.use(bodyParser.json());

if (process.env.NODE_ENV === "production") {
  app.use(express.static("frontend/build"));
  app.get("*", (req, res) => {
    res.sendFile(path.resolve(__dirname, "frontend", "build", "index.html"));
  });
}

app.listen(PORT, () => {
  console.log("Server listening on port " + PORT);
});

// Global Constants
const region = "REGION_STATE_FL";

// Functions

// incoming: make
// outgoing: link to logo image (string)
// used in: search API
async function getBrandLogo(make) {
  const options = {
    method: "GET",
    url: "https://autocomplete.clearbit.com/v1/companies/suggest",
    params: {
      query: make,
    },
  };

  try {
    const response = await axios.request(options);
    return response.data[0].logo;
  } catch (error) {
    console.error(error);
  }
}

// incoming: make, model
// outgoing: car type (string)
// used in: databaseRefresh Function
async function getCarType(make, model) {
  const options = {
    method: "GET",
    url: "https://car-data1.p.rapidapi.com/cars",
    params: {
      limit: "1",
      page: "0",
      make: make,
      model: model,
    },
    headers: {
      "X-RapidAPI-Key": API_KEY,
      "X-RapidAPI-Host": "car-data1.p.rapidapi.com",
    },
  };

  try {
    const response = await axios.request(options);

    return response.data[0].type;
  } catch (error) {
    console.error(error);
  }
}

// incoming: make, model
// outgoing: histogramData (array of ints)
// used in: search API
async function getHistogramData(make, model) {
  const options = {
    method: "GET",
    url: "https://cis-automotive.p.rapidapi.com/salePriceHistogram",
    params: {
      modelName: model,
      brandName: make,
    },
    headers: {
      "X-RapidAPI-Key": API_KEY,
      "X-RapidAPI-Host": "cis-automotive.p.rapidapi.com",
    },
  };

  try {
    const response = await axios.request(options);
    return response.data.data;
  } catch (error) {
    console.error(error);
  }
}

/* 
    incoming: password
    outgoing: boolean, checks if password meets requirements

    Requirements:
        - Between 8-100 characters
        - One uppercase character
        - One lowercase character
*/
function isComplex(password) {
  var schema = new passwordValidator();

  schema.is().min(8);
  if (!schema.validate(password)) {
    return "Password is too short. 8 or more characters.";
  }
  schema.is().max(100);
  if (!schema.validate(password)) {
    return "Password is too long. 100 or less characters.";
  }
  schema.has().uppercase();
  if (!schema.validate(password)) {
    return "Password requires at least one uppercase character.";
  }
  schema.has().lowercase();
  if (!schema.validate(password)) {
    return "Password requires at least one lower case character.";
  }
  return "Valid Password";
}

// Refreshes cars database
async function databaseRefresh() {
  wipeDatabase();
  await delay(1010);
  const brands = await getBrands();
  insertBrands(brands);
  await delay(1010);
  carPrices(brands);
}

// TODO: rename this
// Takes in a list of brands and fills database
const carPrices = async (brands) => {
  const db = client.db("carTypes");
  const trucks = new Set(["Pickup"]);
  const suvs = new Set(["SUV", "Van/Minivan", "Wagon"]);
  const sedans = new Set([null, "Coupe", "Hatchback", "Sedan", "Convertible"]);
  var cars = [];
  var type = "";
  var carData = [];

  for (brand of brands) {
    cars = await carPrice(brand, region);
    carData = [];

    for (car of cars) {
      await delay(1500);
      type = await getCarType(brand, car["name"]);

      if (type != null) {
        type = type.split(",")[0];

        if (trucks.has(type)) {
          type = "Truck";
        } else if (suvs.has(type)) {
          type = "SUV";
        } else {
          console.log(type);
          type = "Sedan";
        }
      } else {
        type = "Sedan";
      }

      carData.push({ model: car["name"], price: car["median"], type: type });
    }

    // prices.push(carData)
    if (carData && carData.length > 0) {
      console.log("Inserting " + brand);
      db.collection(brand).insertMany(carData);
    } else db.collection(brand).drop();
    await delay(1500);
  }

  // return prices
  // console.log(prices)
};

// returns a promise that resolves after a given time
function delay(time) {
  return new Promise((resolve) => {
    setTimeout(resolve, time);
  });
}

const carPrice = async (brandName, region) => {
  const options = {
    method: "GET",
    url: "https://cis-automotive.p.rapidapi.com/salePrice",
    params: {
      brandName: brandName,
      regionName: region,
    },
    headers: {
      "X-RapidAPI-Key": process.env.REACT_APP_API_KEY,
      "X-RapidAPI-Host": "cis-automotive.p.rapidapi.com",
    },
  };

  try {
    const response = await axios.request(options);
    return response.data.data;
  } catch (error) {
    console.error(error);
  }
};

const getBrands = async () => {
  const options = {
    method: "GET",
    url: "https://cis-automotive.p.rapidapi.com/getBrands",
    headers: {
      "X-RapidAPI-Key": process.env.REACT_APP_API_KEY,
      "X-RapidAPI-Host": "cis-automotive.p.rapidapi.com",
    },
  };

  try {
    const response = await axios.request(options);
    return response.data.data;
  } catch (error) {
    console.error(error);
  }
};

const wipeDatabase = () => {
  const db = client.db("carTypes");
  db.dropDatabase();
};

const insertBrands = (brands) => {
  const db = client.db("carTypes");
  for (brand of brands) {
    db.createCollection(brand);
  }
};

// APIs
app.post("/api/search", async (req, res, next) => {
  // incoming: make, model
  // outgoing: histogram data, image, type, logo, price
  var token = require('./createJWT.js');
  var error = "";
  const { make, model, jwtToken } = req.body;

  try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
        var r = {error:e.message, jwtToken: ''};
        res.status(200).json(r);
        return;
      }
  
  var refreshedToken = null;
  try
  {
    refreshedToken = token.refresh(jwtToken);
  }
  catch(e)
  {
    console.log(e.message);
  }

  const logo = await getBrandLogo(make);
  const histogramData = await getHistogramData(make, model);
  var db = client.db("carTypes");
  const typesEntry = await db.collection(make).find({ model: model }).toArray();

  db = client.db("carPics");
  const pictureEntry = await db
    .collection(make)
    .find({ model: model })
    .toArray();

  var price = -1;
  var picture = "";
  var type = "";
  if (typesEntry.length > 0) {
    price = typesEntry[0].price;
    type = typesEntry[0].type;
  }

  if (pictureEntry.length > 0) {
    picture = pictureEntry[0].picture;
  }

  var ret = {
    image: picture,
    price: price,
    brandLogo: logo,
    type: type,
    histogramData: histogramData,
  };
  res.status(200).json(ret);
});

app.post("/api/register", async (req, res, next) => {
  // incoming: firstName, lastName, userName, email, password
  // outgoing: message, error
  // var token = require('./createJWT.js');
  var error = "";
  const { firstName, lastName, userName, email, password } = req.body;
  var validation = isComplex(password);

  if (validation != "Valid Password") {
    ret = { message: "", error: validation };
    res.status(200).json(ret);
  } else {
    const db = client.db("cop4331");
    const results = await db.collection("Users").insertOne({
      firstName: firstName,
      lastName: lastName,
      email: email,
      userName: userName,
      password: password,
      carsArr: []
    });
    // console.log(results)

    var ret = {message: "User Added Successfully", error: "" };
    res.status(200).json(ret);
  }
});

app.post('/api/login', async (req, res, next) => {
  // incoming: login, password
  // outgoing: id, firstName, lastName, error
  var token = require('./createJWT.js');
  var error = '';
  const { userName, password, jwtToken } = req.body;
  // console.log(userName, password)
  
  const db = client.db('cop4331');
  const results = await db.collection('Users').find({ userName: userName, password: password }).toArray();
  var id = -1;
  var fn = '';
  var ln = '';
  var em = '';
  if (results.length > 0) {
      id = results[0]._id;
      fn = results[0].firstName;
      ln = results[0].lastName;
      em = results[0].email;

      try
        {
          const token = require("./createJWT.js");
          ret = token.createToken( fn, ln, id, em );
          // console.log(ret)
        }
        catch(e)
        {
          ret = {error:e.message};
        }
  }
  else
  {
  ret = {error:"Login/Password incorrect"};
  console.log("Password incorrect")
  }

  res.status(200).json(ret);
});

app.post('/api/homepage', async (req, res, next) => {
  var token = require('./createJWT.js');
  var error = '';
  // const region = req.body.region;
  const region = 'REGION_STATE_FL';
  const {jwtToken } = req.body;

  try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
        var r = {error:e.message, jwtToken: ''};
        res.status(200).json(r);
        return;
      }
  
  var refreshedToken = null;
  try
  {
    refreshedToken = token.refresh(jwtToken);
  }
  catch(e)
  {
    console.log(e.message);
  }
  
  // incoming: region
  // outgoing: brand, model, type
  try {
      const options = {
          method: 'GET',
          url: 'https://cis-automotive.p.rapidapi.com/topModels',
          params: {
              regionName: region,
          },
          headers: {
              'X-RapidAPI-Key': process.env.REACT_APP_API_KEY,
              'X-RapidAPI-Host': 'cis-automotive.p.rapidapi.com'
          }
      };
      const db = client.db("carTypes");

      const response = await axios.request(options);
      const cars = response.data.data;
      console.log(response.data.data);

      const collections = await db.listCollections().toArray();
      const matchedCars = [];
      var i = 1;
      for (const car of cars) {
          for (const collection of collections) {
              // if(i > 10)
              //     break;
              if (collection.name === car.brandName) {
                  const carData = await db.collection(collection.name).findOne({ model: car.modelName });
                  if (carData) {
                      const matchedCar = {
                          brand: car.brandName,
                          model: car.modelName,
                          type: carData.type, 
                          price: carData.price,
                          rank: i++
                      };
                      matchedCars.push(matchedCar);
                  }
              }
          }
      }
      
      res.status(200).json({matchedCars});
      
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error' });
  }
});

app.post("/api/makes", async (req, res, next) => {
  // incoming: N/A
  // outgoing: json of all the makes
  //var token = require('./createJWT.js');
  var error = "";
  const db = client.db("carTypes");
  // const {jwtToken } = req.body;
  // console.log("test");

  // try
  //     {
  //       if( token.isExpired(jwtToken))
  //       {
  //         var r = {error:'The JWT is no longer valid', jwtToken: ''};
  //         res.status(200).json(r);
  //         return;
  //       }
  //     }
  //     catch(e)
  //     {
  //       console.log(e.message);
  //       var r = {error:e.message, jwtToken: ''};
  //       res.status(200).json(r);
  //       return;
  //     }
  
  // var refreshedToken = null;
  // try
  // {
  //   refreshedToken = token.refresh(jwtToken);
  // }
  // catch(e)
  // {
  //   console.log(e.message);
  // }

  const collections = await db.listCollections().toArray();
  const makeArr = collections.map((col) => col.name);
  makeArr.sort();

  res.status(200).json(makeArr);
});

app.post('/api/models', async (req, res, next) => {
    // incoming: make, model
    // outgoing: histogram data, image, type, logo, price

    const { make, jwtToken } = req.body;

    try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
        var r = {error:e.message, jwtToken: ''};
        res.status(200).json(r);
        return;
      }
  
  var refreshedToken = null;
  try
  {
    refreshedToken = token.refresh(jwtToken);
  }
  catch(e)
  {
    console.log(e.message);
  }

    var error = '';

    var db = client.db('carTypes');
    var models = await db.collection(make).find({}).toArray();
    console.log(models);
    models = models.map((model) => model["model"]);

    res.status(200).json(models);
});

app.post('/api/getfavorites', async (req, res, next) => {
    // incoming: userId
    // outgoing: favorites
    var token = require('./createJWT.js');
    var error = '';
    const { id, jwtToken } = req.body;

    try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
        var r = {error:e.message, jwtToken: ''};
        res.status(200).json(r);
        return;
      }
  
  var refreshedToken = null;
  try
  {
    refreshedToken = token.refresh(jwtToken);
  }
  catch(e)
  {
    console.log(e.message);
  }

    var carData = [];
    var curCar;
    const db = client.db('cop4331');
    var results = await db.collection("Users").findOne({ _id : new ObjectId(id)});
    results = Object.values(results["carsArr"])

    const carPromises = results.map(async(car) => {
        curCar = await client.db('carTypes').collection(car["make"]).findOne({ model : car["model"]})
        return ({make: car["make"], model: curCar["model"], price: curCar["price"], type: curCar["type"]})
    })

    const carDetails = await Promise.all(carPromises);
    carData = carDetails;

    var ret = { favorites: carData, error: '' };
    res.status(200).json(ret);
})

app.post('/api/addfavorite', async (req, res, next) => {
    // incoming: userId, make, model
    // processing: adding make and model to user's carArr field
    // outgoing: message, error
    var token = require('./createJWT.js');
    var error = '';
    const { id, make, model, jwtToken } = req.body;

    try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
        var r = {error:e.message, jwtToken: ''};
        res.status(200).json(r);
        return;
      }
  
  var refreshedToken = null;
  try
  {
    refreshedToken = token.refresh(jwtToken);
  }
  catch(e)
  {
    console.log(e.message);
  }

    const db = client.db('cop4331');
    var results = await db.collection("Users").findOne({ _id : new ObjectId(id)});
    carList = Object.values(results["carsArr"])
    carList.push({make: make, model: model})

    await db.collection("Users").updateOne({ _id : new ObjectId(id)}, {$set: {carsArr: carList}});

    var ret = { message: "Favorite added successfully", error: '' };
    res.status(200).json(ret);
})

app.post('/api/removefavorite', async (req, res, next) => {
    // incoming: userId, make, model
    // processing: removes make and model from user's carArr field
    // outgoing: message, error
    var token = require('./createJWT.js');
    var error = '';
    const { id, make, model, jwtToken } = req.body;

    try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
        var r = {error:e.message, jwtToken: ''};
        res.status(200).json(r);
        return;
      }
  
  var refreshedToken = null;
  try
  {
    refreshedToken = token.refresh(jwtToken);
  }
  catch(e)
  {
    console.log(e.message);
  }

    const db = client.db('cop4331');
    var results = await db.collection("Users").findOne({ _id : new ObjectId(id)});
    carList = Object.values(results["carsArr"])
    carList = carList.filter((car) => (car["make"] != make || car["model"] != model))
    console.log(carList)

    await db.collection("Users").updateOne({ _id : new ObjectId(id)}, {$set: {carsArr: carList}});

    var ret = { message: "Favorite removed successfully", error: '' };
    res.status(200).json(ret);
})


app.post("/api/modify", async (req, res, next) => {
  // incoming: userID; new firstName, lastName and userName
  // outgoing: new firstName, lastName and userName

  var token = require('./createJWT.js');
  var error = "";

  const { userId, newFirstName, newLastName, newUserName, jwtToken} = req.body;

  try
      {
        if( token.isExpired(jwtToken))
        {
          var r = {error:'The JWT is no longer valid', jwtToken: ''};
          res.status(200).json(r);
          return;
        }
      }
      catch(e)
      {
        console.log(e.message);
        var r = {error:e.message, jwtToken: ''};
        res.status(200).json(r);
        return;
      }

      var refreshedToken = null;
      try
      {
        refreshedToken = token.refresh(jwtToken);
      }
      catch(e)
      {
        console.log(e.message);
      }
  

  const db = client.db("cop4331");

  try {
    const result = await db.collection("Users").updateOne(
      { _id: new ObjectId(userId) },
      { $set: { firstName: newFirstName, lastName: newLastName, userName: newUserName } }
    );

    if (result.matchedCount > 0) {
      // If at least one document is matched and updated
      res.status(200).json({ firstName: newFirstName, lastName: newLastName, userName: newUserName });
    } else {
      // If no document is matched
      res.status(404).json({ error: "User not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});




