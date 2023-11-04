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

// Environment Variables
require('dotenv').config();
const url = process.env.MONGODB_URL;
const client = new MongoClient(url);
const API_KEY = process.env.REACT_APP_API_KEY;

// Port Configurations
client.connect()
app.set('port', (process.env.PORT || 9000))
app.use(cors());
app.use(bodyParser.json());

if (process.env.NODE_ENV === 'production') {
    app.use(express.static('frontend/build'));
    app.get('*', (req, res) => {
        res.sendFile(path.resolve(__dirname, 'frontend', 'build', 'index.html'));
    });
}

app.listen(PORT, () => {
    console.log('Server listening on port ' + PORT);
});

// Global Constants
const region = "REGION_STATE_FL";

// Functions

// incoming: make
// outgoing: link to logo image (string)
// used in: search API
async function getBrandLogo(make) {
    const options = {
        method: 'GET',
        url: 'https://autocomplete.clearbit.com/v1/companies/suggest',
        params: {
            query: make
        }
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
    method: 'GET',
    url: 'https://car-data1.p.rapidapi.com/cars',
    params: {
        limit: '1',
        page: '0',
        make: make,
        model: model
    },
    headers: {
        'X-RapidAPI-Key': API_KEY,
        'X-RapidAPI-Host': 'car-data1.p.rapidapi.com'
    }
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
        method: 'GET',
        url: 'https://cis-automotive.p.rapidapi.com/salePriceHistogram',
        params: {
          modelName: model,
          brandName: make
        },
        headers: {
          'X-RapidAPI-Key': API_KEY,
          'X-RapidAPI-Host': 'cis-automotive.p.rapidapi.com'
        }
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

    schema.is().min(8)
    if (!schema.validate(password)) {
        return "Password is too short. 8 or more characters."
    }
    schema.is().max(100)
    if (!schema.validate(password)) {
        return "Password is too long. 100 or less characters."
    }
    schema.has().uppercase()
    if (!schema.validate(password)) {
        return "Password requires at least one uppercase character."
    }
    schema.has().lowercase()
    if (!schema.validate(password)) {
        return "Password requires at least one lower case character."
    }
    return "Valid Password"
}

// Refreshes cars database
async function databaseRefresh() {
    wipeDatabase();
    await delay(1010);
    const brands = await getBrands()
    insertBrands(brands)
    await delay(1010)
    carPrices(brands);
}

// TODO: rename this
// Takes in a list of brands and fills database
const carPrices = async (brands) => {
    const db = client.db('carTypes');
    const trucks = new Set(["Pickup"])
    const suvs = new Set(["SUV", "Van/Minivan", "Wagon"])
    const sedans = new Set([null, "Coupe", "Hatchback", "Sedan", "Convertible"])
    var cars = [];
    var type = '';
    var carData = [];
    
    for (brand of brands) {
        cars = await carPrice(brand, region);
        carData = []

        for (car of cars) {
            await delay(1500);
            type = await getCarType(brand, car["name"]);

            if (type != null) {
                type = type.split(",")[0];

                if (trucks.has(type)) {
                    type = "Truck"
                }
                else if (suvs.has(type)) {
                    type = "SUV"
                }
                else {
                    console.log(type)
                    type = 'Sedan'
                }
            }
            else {
                type = 'Sedan'
            }

            carData.push(({model: car["name"], price: car["median"], type: type}));
        };
          
        // prices.push(carData)
        if (carData && carData.length > 0){
            console.log("Inserting " + brand)
            db.collection(brand).insertMany(carData);
        }
        else
            db.collection(brand).drop();
        await delay(1500)
    }

    // return prices
    // console.log(prices)
}

// returns a promise that resolves after a given time
function delay(time) {
    return new Promise(resolve => {
        setTimeout(resolve, time);
    });
}

const carPrice = async (brandName, region) => {
    const options = {
        method: 'GET',
        url: 'https://cis-automotive.p.rapidapi.com/salePrice',
        params: {
            brandName: brandName,
            regionName: region
        },
        headers: {
            'X-RapidAPI-Key': process.env.REACT_APP_API_KEY,
            'X-RapidAPI-Host': 'cis-automotive.p.rapidapi.com'
        }
    };

    try {
        const response = await axios.request(options);
        return response.data.data;
    } catch (error) {
        console.error(error);
    }
}

const getBrands = async () => {
    const options = {
        method: 'GET',
        url: 'https://cis-automotive.p.rapidapi.com/getBrands',
        headers: {
            'X-RapidAPI-Key': process.env.REACT_APP_API_KEY,
            'X-RapidAPI-Host': 'cis-automotive.p.rapidapi.com'
        }
    };

    try {
        const response = await axios.request(options);
        return response.data.data
    } catch (error) {
        console.error(error);
    }
}

const wipeDatabase = () => {
    const db = client.db('carTypes');
    db.dropDatabase();
}


const insertBrands = (brands) => {
    const db = client.db('carTypes');
    for (brand of brands) {
        db.createCollection(brand)
    }
}

// APIs
app.post('/api/search', async (req, res, next) => {
    // incoming: make, model
    // outgoing: histogram data, image, type, logo, price

    var error = '';
    const { make, model } = req.body;
    const logo = await getBrandLogo(make);
    const histogramData = await getHistogramData(make, model);

    var db = client.db('carTypes');
    const typesEntry = await db.collection(make).find({ model: model }).toArray();

    db = client.db('carPics');
    const pictureEntry = await db.collection(make).find({ model: model }).toArray();

    var price = -1;
    var picture = '';
    var type = '';
    if (typesEntry.length > 0) {
        price = typesEntry[0].price;
        type = typesEntry[0].type;
    }

    if (pictureEntry.length > 0) {
        picture = pictureEntry[0].picture;
    }

    var ret = { image: picture, price: price, brandLogo: logo, type: type, histogramData: histogramData };
    res.status(200).json(ret);
});

app.post('/api/register', async (req, res, next) => {
    // incoming: firstName, lastName, userName, email, password
    // outgoing: message, error
    var error = '';
    const { firstName, lastName, userName, email, password } = req.body;
    var validation = isComplex(password);

    if (validation != "Valid Password") {
        ret = { message: '', error: validation }
        res.status(200).json(ret);
    }
    else {
        const db = client.db('cop4331');
        const results = await
            db.collection('Users').insertOne(
                {
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    userName: userName,
                    password: password,
                }
            );
        // console.log(results)

        var ret = { message: 'User Added Successfully', error: '' };
        res.status(200).json(ret);
    }
});

app.post('/api/login', async (req, res, next) => {
    // incoming: login, password
    // outgoing: id, firstName, lastName, error
    var error = '';
    const { userName, password } = req.body;
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
    }
    var ret = { _id: id, firstName: fn, lastName: ln, email: em, error: '' };
    res.status(200).json(ret);
});

app.post('/api/homepage', async (req, res, next) => {

    var error = '';
    const db = client.db('CarTypes');
    const region = req.body.region;
    
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
    
        const response = await axios.request(options);
        const cars = Object.values(response.data.data);
        console.log(response.data.data);

        const collections = await db.listCollections().toArray();
        const matchedCars = [];

        for (const car of cars) {
            for (const collection of collections) {
                if (collection.name === car.brandName) {
                    const carData = await db.collection(collection.name).findOne({ model: car.modelName });
                    console.log(carData);
                    if(carData != null){
                    car.brand = collection.name;
                    car.model = carData.model;
                    car.type = carData.type; 
                    car.price = carData.price;
                    matchedCars.push(car);
                    }
                }
            }
        }
        
        res.status(200).json({matchedCars});
        
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error' });
    }

})

app.post('/api/makes', async (req, res, next) => {
    // incoming: N/A
    // outgoing: json of all the makes
    var error = '';
    const db = client.db('carTypes');

    const collections = await db.listCollections().toArray();
    const makeArr = collections.map((col) => col.name);
    makeArr.sort();

    res.status(200).json(makeArr);
});

app.post('/api/models', async (req, res, next) => {
    // incoming: make, model
    // outgoing: histogram data, image, type, logo, price

    var error = '';
    const { make } = req.body;

    var db = client.db('carTypes');
    var models = await db.collection(make).find({}).toArray();
    console.log(models);
    models = models.map((model) => model["model"]);

    res.status(200).json(models);
});

// comment

// Archive

// async function getType(make, model) {
//     const options = {
//         method: 'GET',
//         url: 'https://autocomplete.clearbit.com/v1/companies/suggest',
//         params: {
//             query: make
//         }
//     };

//     try {
//         const response = await axios.request(options);
//         // console.log(response.data[0].logo);
//         return response.data[0].logo;
//     } catch (error) {
//         console.error(error);
//     }
// }

// app.post('/api/carprice', async (req, res, next) => {

//     // // incoming: make, model
//     // // outgoing: sales histogram, average price
//     const { brandName, region } = req.body;
//     response = await carPrice(brandName, region)
//     res.status(200).json({ data: response.data });

// });

// const insertCarData = (brand, carData) => {
    
//     const db = client.db('carTypes');
//     // console.log(carData[brand])
//     if (carData != null) {
        
//     }
//     // console.log(prices)
//     // return prices
// }

// const formatPrice = (cars, modelName) => {
//     for (car of cars) {
//         if (car['name'] === modelName) {
//             return car['median']
//         }
//     }
// }

// app.post('/api/pricechart', async (req, res, next) => {
//     // // incoming: make, model
//     // // outgoing: sales histogram, average price
//     const { modelName, brandName } = req.body;

    

//     const options = {
//         method: 'GET',
//         url: 'https://cis-automotive.p.rapidapi.com/salePriceHistogram',
//         params: {
//             modelName: modelName,
//             brandName: brandName
//         },
//         headers: {
//             'X-RapidAPI-Key': process.env.REACT_APP_API_KEY,
//             'X-RapidAPI-Host': 'cis-automotive.p.rapidapi.com'
//         }
//     };

//     try {
//         const response = await axios.request(options);
//         console.log(response.data);
//         res.status(200).json({ data: response.data });
//     } catch (error) {
//         console.error(error);
//     }


// });
