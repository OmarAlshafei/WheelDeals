// Node.js Dependencies
const {
  login,
  signup,
  confirmEmail,
  resetPassword,
  changePassword,
} = require("./email");
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const path = require("node:path");
const axios = require("axios");
const PORT = process.env.PORT || 9000;
const app = express();
const MongoClient = require("mongodb").MongoClient;
const passwordValidator = require("password-validator");
const ObjectId = require("mongodb").ObjectId;
// const tokenSchema = require("./email.js")
const Bcrypt = require("bcrypt");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
const sendgridTransport = require("nodemailer-sendgrid-transport");
const mongoose = require("mongoose");

// Environment Variables
require("dotenv").config();
const url = process.env.MONGODB_URL;
const client = new MongoClient(url);
const API_KEY = process.env.REACT_APP_API_KEY;
const SEND_GRID_API_KEY = process.env.SENDGRID_API_KEY;

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
var tokenSchema = new mongoose.Schema({
  _userId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },
  token: { type: String, required: true },
  expireAt: { type: Date, default: Date.now, index: { expires: 86400000 } },
});

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
  var token = require("./createJWT.js");
  var error = "";
  const { make, model, jwtToken } = req.body;

  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
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
  var token = require('./createJWT.js');
  var error = "";
  const db = client.db("cop4331");
  const { firstName, lastName, userName, email, password } = req.body;
  var Token = mongoose.model("Token", tokenSchema);
  var validation = isComplex(password);

  if (validation != "Valid Password") {
    ret = { message: "", error: validation };
    res.status(200).json(ret);
  } else {
    try {
      console.log("about to search db");
      var user = await db.collection("Users").findOne({ email: email });
      console.log("searched db");
      // error occur
      // if email is exist into database i.e. email is associated with another user.
      if (user) {
        return res
          .status(400)
          .send({
            msg: "This email address is already associated with another account.",
          });
      }
      // if user is not exist into database then save the user into database for register account
      else {
        // password hashing for save into databse
        // create and save user
        console.log("about to add user");
        await db.collection("Users").insertOne({
          firstName: firstName,
          lastName: lastName,
          email: email,
          userName: userName,
          password: password,
          isVerified: false,
          carsArr: [],
        });
        console.log("added user");
        user = await db.collection("Users").findOne({ email: req.body.email });

        // generate token and save
        try {
          var token = new Token({
            _userId: user._id,
            token: crypto.randomBytes(16).toString("hex"),
            expireAt: {
              type: Date,
              default: Date.now,
              index: { expires: 86400000 },
            },
          });
          await db.collection("Tokens").insertOne(token);
        } catch (e) {
          return res
            .status(500)
            .send({ msg: "Failed to generate token. Please try again." });
        }

        // Send email (use verified sender's email address & generated API_KEY on SendGrid)
        const transporter = nodemailer.createTransport(
          sendgridTransport({
            auth: {
              api_key: SEND_GRID_API_KEY,
            },
          })
        );
        var mailOptions = {
          from: "thaihungtran57116@gmail.com",
          to: user.email,
          subject: "Account Verification Code",
          text:
            "Hello " +
            req.body.firstName +
            ",\n\n" +
            "Here is your login token: " + 
            token.token +
            "\n\nThank You!\n",
        };
        try {
          transporter.sendMail(mailOptions);
        } catch (e) {
          return res
            .status(500)
            .send({
              msg: "Technical Issue!, Please click on resend for verify your Email.",
            });
        }
        return res
          .status(200)
          .send({
            msg:
              "A verification email has been sent to " +
              user.email +
              ". It will be expire after one day. If you not get verification Email click on resend token.",
          });
        // sendEmail()
      }
    } catch (e) {
      return res
        .status(500)
        .send({ msg: "Failed to register user. Please try again." });
    }
  }
});

app.post("/api/login", async (req, res, next) => {
  // incoming: login, password
  // outgoing: id, firstName, lastName, error
  var token = require("./createJWT.js");
  var error = "";
  const { userName, password } = req.body;
  console.log(userName, password);

  var db = client.db("cop4331");

  try {
    const user = await db
      .collection("Users")
      .findOne({ userName: userName, password: password });
    const id = user._id;
    const fn = user.firstName;
    const ln = user.lastName;
    const em = user.email;

    // user is not found in database i.e. user is not registered yet.
    if (!user) {
      return res.status(401).send({ msg: "Username or Password is invalid!" });
    }
    // comapre user's password if user is find in above step
    // else if (password != user.password) {
    //   return res.status(401).send({ msg: 'Wrong Password!' });
    // }
    // check user is verified or not
    else if (!user.isVerified) {
      return res
        .status(401)
        .send({
          msg: "Your Email has not been verified. Please click on resend",
        });
    }
    // user successfully logged in
    else {
      try {
        const token = require("./createJWT.js");
        ret = token.createToken(fn, ln, id, em);
        console.log(ret);
      } catch (e) {
        ret = { error: e.message };
      }

      return res.status(200).send(ret);
    }
  } catch (e) {
    return res.status(500).send({ msg: "Incorrect username or password." });
  }
});

app.post("/api/homepage", async (req, res, next) => {
  var token = require("./createJWT.js");
  var error = "";
  // const region = req.body.region;
  const region = "REGION_STATE_FL";
  const { jwtToken } = req.body;
  console.log("req test:" + req);
  console.log("req-body test:" + req.body);
  console.log("token test:" + jwtToken);
  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
    console.log(e.message);
  }

  // incoming: region
  // outgoing: brand, model, type
  try {
    const options = {
      method: "GET",
      url: "https://cis-automotive.p.rapidapi.com/topModels",
      params: {
        regionName: region,
      },
      headers: {
        "X-RapidAPI-Key": process.env.REACT_APP_API_KEY,
        "X-RapidAPI-Host": "cis-automotive.p.rapidapi.com",
      },
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
          const carData = await db
            .collection(collection.name)
            .findOne({ model: car.modelName });
          if (carData) {
            const matchedCar = {
              brand: car.brandName,
              model: car.modelName,
              type: carData.type,
              price: carData.price,
              rank: i++,
            };
            matchedCars.push(matchedCar);
          }
        }
      }
    }

    res.status(200).json({ matchedCars });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error" });
  }
});

app.post("/api/makes", async (req, res, next) => {
  // incoming: N/A
  // outgoing: json of all the makes
  var token = require("./createJWT.js");
  var error = "";
  const db = client.db("carTypes");
  console.log("test");
  const { jwtToken } = req.body;

  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
    console.log(e.message);
  }

  const collections = await db.listCollections().toArray();
  const makeArr = collections.map((col) => col.name);
  makeArr.sort();

  res.status(200).json(makeArr);
});

app.post("/api/models", async (req, res, next) => {
  // incoming: make, model
  // outgoing: histogram data, image, type, logo, price
  const { make, jwtToken } = req.body;
  var token = require("./createJWT.js");
  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
    console.log(e.message);
  }

  var error = "";

  var db = client.db("carTypes");
  var models = await db.collection(make).find({}).toArray();
  console.log(models);
  models = models.map((model) => model["model"]);

  res.status(200).json(models);
});

app.post("/api/getfavorites", async (req, res, next) => {
  // incoming: userId
  // outgoing: favorites
  var token = require("./createJWT.js");
  var error = "";
  const { id, jwtToken } = req.body;

  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
    console.log(e.message);
  }

  var carData = [];
  var curCar;
  const db = client.db("cop4331");
  var results = await db.collection("Users").findOne({ _id: new ObjectId(id) });
  var carPromises = [];
  console.log("users cars are", results);

  if (results && results["carsArr"]) {
    results = Object.values(results["carsArr"]);

    carPromises = results.map(async (car) => {
      curCar = await client
        .db("carTypes")
        .collection(car["make"])
        .findOne({ model: car["model"] });
      return {
        make: car["make"],
        model: curCar["model"],
        price: curCar["price"],
        type: curCar["type"],
      };
    });
  }

  const carDetails = await Promise.all(carPromises);
  carData = carDetails;

  var ret = { favorites: carData, error: "" };
  res.status(200).json(ret);
});

app.post("/api/addfavorite", async (req, res, next) => {
  // incoming: userId, make, model
  // processing: adding make and model to user's carArr field
  // outgoing: message, error
  var token = require("./createJWT.js");
  var error = "";
  const { id, make, model, jwtToken } = req.body;
  var carList = [];

  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
    console.log(e.message);
  }

  const db = client.db("cop4331");
  var results = await db.collection("Users").findOne({ _id: new ObjectId(id) });
  if (results !== null && results["carsArr"] !== null) {
    carList = Object.values(results["carsArr"]);
  }
  carList.push({ make: make, model: model });

  await db
    .collection("Users")
    .updateOne({ _id: new ObjectId(id) }, { $set: { carsArr: carList } });

  var ret = { message: "Favorite added successfully", error: "" };
  res.status(200).json(ret);
});

app.post("/api/removefavorite", async (req, res, next) => {
  // incoming: userId, make, model
  // processing: removes make and model from user's carArr field
  // outgoing: message, error
  var token = require("./createJWT.js");
  var error = "";
  const { id, make, model, jwtToken } = req.body;
  var carList = [];

  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
    console.log(e.message);
  }

  const db = client.db("cop4331");
  var results = await db.collection("Users").findOne({ _id: new ObjectId(id) });
  if (results && results["carsArr"]) {
    carList = Object.values(results["carsArr"]);
    carList = carList.filter(
      (car) => car["make"] != make || car["model"] != model
    );
  }

  await db
    .collection("Users")
    .updateOne({ _id: new ObjectId(id) }, { $set: { carsArr: carList } });

  var ret = { message: "Favorite removed successfully", error: "" };
  res.status(200).json(ret);
});

app.post("/api/modify", async (req, res, next) => {
  // incoming: userID; new firstName and lastName
  // outgoing: new firstName and lastName

  var token = require("./createJWT.js");
  var error = "";

  const { userId, newFirstName, newLastName, jwtToken } = req.body;

  try {
    if (token.isExpired(jwtToken)) {
      var r = { error: "The JWT is no longer valid", jwtToken: "" };
      res.status(200).json(r);
      return;
    }
  } catch (e) {
    console.log(e.message);
    var r = { error: e.message, jwtToken: "" };
    res.status(200).json(r);
    return;
  }

  var refreshedToken = null;
  try {
    refreshedToken = token.refresh(jwtToken);
  } catch (e) {
    console.log(e.message);
  }

  const db = client.db("cop4331");

  try {
    const result = await db
      .collection("Users")
      .updateOne(
        { _id: new ObjectId(userId) },
        { $set: { firstName: newFirstName, lastName: newLastName } }
      );

    if (result.matchedCount > 0) {
      // If at least one document is matched and updated
      res.status(200).json({ firstName: newFirstName, lastName: newLastName });
    } else {
      // If no document is matched
      res.status(404).json({ error: "User not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal Server Error" });
  }
});

app.post("/api/confirmEmail", confirmEmail);
app.post("/api/resetPassword", resetPassword);
// app.get("/confirmation/:email/:token", confirmEmail);
app.post("/api/changePassword", changePassword);
