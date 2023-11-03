const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('node:path');
const axios = require('axios');
const PORT = process.env.PORT || 9000;
const app = express();
app.set('port', (process.env.PORT || 9000))
const MongoClient = require('mongodb').MongoClient;
const passwordValidator = require('password-validator');
require('dotenv').config();
const url = process.env.MONGODB_URL;
const client = new MongoClient(url);
const API_KEY = process.env.REACT_APP_API_KEY;
const region = "REGION_STATE_FL";
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
        // console.log(response.data[0].logo);
        return response.data[0].logo;
    } catch (error) {
        console.error(error);
    }
}

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

// Checks if password meets requirements
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



app.post('/api/homepage', async (req, res, next) => {
    // // incoming: region
    // // Processing: Calls topModels for top 10 cars, then gets the price for each using getPrice.
    // // outgoing: make, model, current price, popularity
    var error = '';
    var cars = [];
    var brands = [];
    var brandPrices = null;
    wipeDatabase();
    await delay(1010);

    // incoming: region
    // outgoing: brand, model, condition (new)
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

    try {
        // const response = await axios.request(options);
        // cars = response.data.data
        brands = await getBrands()
        insertBrands(brands)
        await delay(1010)
        carPrices(brands);

        var newCars = cars.map(function (car) {
            // create a new object with the new parameter and value
            var newCar = { ...car, price: 1 }//findPrice(cars.modelName, cars.brandName) }
            // return the new object to the new array
            return newCar;
        });

        res.status(200).json({ data: newCars });
    } catch (error) {
        console.error(error)
        cars, error = null, error
    }

})

// async function databaseRefresh

const carPrices = async (brands) => {
    // var prices = []
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




// Define a function that returns a promise that resolves after a given time
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

app.post('/api/carprice', async (req, res, next) => {

    // // incoming: make, model
    // // outgoing: sales histogram, average price
    const { brandName, region } = req.body;
    response = await carPrice(brandName, region)
    res.status(200).json({ data: response.data });

});

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

// const insertCarData = (brand, carData) => {
    
//     const db = client.db('carTypes');
//     // console.log(carData[brand])
//     if (carData != null) {
        
//     }
//     // console.log(prices)
//     // return prices
// }

const formatPrice = (cars, modelName) => {
    for (car of cars) {
        if (car['name'] === modelName) {
            return car['median']
        }
    }
}