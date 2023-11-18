import 'dart:convert';
import '../routes/routes.dart';
import '../utils/currentUser.dart' as currentUser;
import '../screens/CarsScreen.dart' as carsScreen;
import 'Cars.dart';
import 'getAPI.dart';
import 'package:flutter/material.dart';


class Favorites {
  static Future<void> favorite(context, String make, String model, String originPage) async {
    print("Favoriting $make $model");
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/addfavorite';
    String payload = '{"jwtToken":"${currentUser.token}","make":"$make","model":"$model","id":"${currentUser.userId}"}';
    var ret = await CarsData.getJson(url,payload);
    var jsonObj = json.decode(ret);
    print(jsonObj);

    // add to local favorites array in currentUser
    url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/search';
    payload = '{"jwtToken":"${currentUser.token}","make":"$make","model":"$model"}';
    ret = await CarsData.getJson(url,payload);
    jsonObj = json.decode(ret);
    currentUser.favCars.add(Car(-1, make, model, "\$${jsonObj["price"]}", jsonObj["type"], carsScreen.histData.makeHist(jsonObj['histogramData'])));

    if (originPage == "home") {
      Navigator.pushNamed(context, Routes.HOMESCREEN);
    }
    if (originPage == "carInfo") {
      Navigator.pushNamed(context, Routes.CARSSCREEN);
    }
  }

  static Future<void> unfavorite(context, String make, String model, String originPage) async {
    Car goner = Car(-1, "","","","",[]);
    print("Unfavoriting $make $model");

    // Delete from database
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/removefavorite';
    String payload = '{"jwtToken":"${currentUser.token}","make":"$make","model":"$model","id":"${currentUser.userId}"}';
    var ret = await CarsData.getJson(url,payload);
    var jsonObj = json.decode(ret);
    print(jsonObj);

    // Delete from local favorites array in currentUser
    for (Car c in currentUser.favCars) {
      if ((c.make == make) && (c.model == model)) {
        goner = c;
      }
    }
    currentUser.favCars.remove(goner);

    print(context);
    if (originPage == "favScreen") {
      Navigator.pushNamed(context, Routes.FAVSCREEN);
    }
    if (originPage == "carInfo") {
      Navigator.pushNamed(context, Routes.CARSSCREEN);
    }
    if (originPage == "home") {
      Navigator.pushNamed(context, Routes.HOMESCREEN);
    }
  }

  static bool isFav(String make, String model) {
    for (Car c in currentUser.favCars) {
      if ((c.make == make) && (c.model == model)) {
        return true;
      }
    }
    return false;
  }

  static void printFavorites() {
    print("Printing Favorites");
    for (Car c in currentUser.favCars) {
      print(c);
    }
  }

  static Future<void> getFavorites(context) async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/getfavorites';
    String payload = '{"jwtToken":"${currentUser.token}","id":"${currentUser.userId}"}';
    var ret = await CarsData.getJson(url,payload);
    var jsonObj = json.decode(ret);

    // Populate favorites array in currentUser
    for (var obj in jsonObj["favorites"]) {
      url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/search';
      payload = '{"jwtToken":"${currentUser.token}","make":"${obj["make"]}","model":"${obj["model"]}"}';
      ret = await CarsData.getJson(url,payload);
      jsonObj = json.decode(ret);
      currentUser.favCars.add(Car(-1,obj["make"], obj["model"], "\$${jsonObj["price"]}", jsonObj["type"], carsScreen.histData.makeHist(jsonObj['histogramData'])));
    }

    for (Car c in currentUser.favCars) {
      print(c);
    }

  }
}