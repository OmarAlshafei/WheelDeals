import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;

class Car {
  String make = "";
  String model = "";
  String type = "?";
  String price = "?";
  int rank = -1;
  var histData = null;

  Car(this.rank, this.make, this.model, this.price, this.type, this.histData);


  factory Car.fromJson(dynamic json) {
    return Car(json['rank'] as int, json['make'] as String, json['model'] as String, json['price'] as String, json['type'] as String, json['histogramData']);
  }

  @override
  String toString() {
    return '{ $make, $model , $price, $type}';
  }

}

class appCars {

  /*
  Map fetchedData = {
    "data": [
      {"id": "1", "make": "Ford", "model":"F-150", "year":2020, "price":"\$13,000","type":"truck"},
      {"id": "2", "make": "Ford", "model":"Explorer", "year":2018, "price":"\$12,000","type":"suv"},
      {"id": "3", "make": "Mazda", "model":"Mazda3", "year":2016, "price":"\$11,000","type":"sedan"},
      {"id": "4", "make": "Toyota", "model":"Camry", "year":2021, "price":"\$12,000","type":"sedan"},
    ]
  };

   */

  static List? _data = [];
  static int currentCarIndex = -1;

  static Image carPic = Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNOLQiaToHY1eu0J6Bz5XD5-IoBxrhcf3XeQ&usqp=CAU");

  static List<Car> popularCars = [];

  static void initPopularCars() {
    for (int i = 0; i < 25; i++) {
      popularCars.add(Car(-1,"","","","",null));
    }
  }

  static Future<void> getHomeApi() async {
    //_data = fetchedData["data"];
    //popularCars = [];

    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/homepage';
    String payload = '{"jwtToken":"${currentUser.token}"}';
    var ret = await CarsData.getJson(url, payload);
    var jsonObject = json.decode(ret);
    //print(jsonObject["matchedCars"]);

    var obj;

    for (int i=0; i < jsonObject["matchedCars"].length; i++) {
      obj = jsonObject["matchedCars"][i];
      popularCars[i] = Car(i+1, obj["brand"], obj["model"], "\$${obj['price']}", obj["type"], null);
    }

    popularCars = popularCars.sublist(0, 25); // keep 1st 25 (fixing extra empty cars)
    // for (Car c in popularCars) {
    //   print(c);
    // }
    // print(popularCars.length);
  }

  // static Future<String> getPicApi(String make, String model) async{
  //   String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/search';
  //   String payload = '{"make":"$make","model":"$model"}';
  //   String ret = await CarsData.getJson(url, payload);
  //   var jsonObject = json.decode(ret);
  //
  //   return jsonObject["image"];
  // }
  //
  // static void getImage(String make, String model) async {
  //
  //   String pic = await getPicApi(make, model);
  //   //print(pic);
  //   appCars.carPic = Image.network(pic, width: 350,);
  //
  //   return;
  // }

  /*Future load() {
    rocket = new ImageElement(src: "nofire.png");
    firingRockets = new ImageElement(src: "fire.png");
    var futures = [rocket.onLoad.first, firingRockets.onLoad.first];
    return Future.wait(futures).then((_) {  // return a Future
      width = rocket.width;
      height = rocket.height;
      print("Images loaded. $width $height");
    })
        .then(() {
      print("Returning");
    }});
  }*/

  // for more car info
  static Future selectCar(int index, context) async {
    currentCarIndex = index;
    selectedMake = getMake(index);
    selectedModel = getModel(index);

    await search(context, selectedMake, selectedModel);
  }

  static int getCarIndex() {
    return currentCarIndex;
  }

  static String getMake(int index) {
    return popularCars[index].make;
  }

  static String getModel(int index) {
    if (_data == null) return "";
    return popularCars[index].model;
  }

  static String getPrice(int index) {
    return popularCars[index].price;
  }

  static String getType(int index) {
    return popularCars[index].type;
  }

  int getLength() {
    return popularCars.length;
  }

  static List<String> makes = [];
  static List<String> models = [];

  static void makeApi() async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/makes';
    String payload = '{"jwtToken":"${currentUser.token}"}';
    var ret = await CarsData.getJson(url,payload);
    //print(ret);
    var makesDyn = json.decode(ret);
    var makesStr = makesDyn.cast<String>();
    int count = 0;
    for (String m in makesStr) {
      //print(makes);
      if (!makes.contains(m)) {
        count = count + 1;
        makes.add(m);
      }
    }
  }

  static void modelApi() async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/models';
    //print("Selected Make: $selectedMake");
    String payload = '{"jwtToken":"${currentUser.token}","make":"$selectedMake"}';
    var ret = await CarsData.getJson(url,payload);
    var modelsDyn = json.decode(ret);
    var modelsStr = modelsDyn.cast<String>();
    int count = 0;
    models = [];
    for (String m in modelsStr) {
      //print(m);
      if (!models.contains(m)) {
        count = count + 1;
        models.add(m);
      }
    }
  }

  static String selectedMake = "";
  static String selectedModel = "";

  static List<DropdownMenuItem<String>> getMakeOptions() {
    makeApi();
    List<DropdownMenuItem<String>> makeItems = [];
    //print(makes);
    for (String make in makes) {
      //print(make);
      makeItems.add(DropdownMenuItem(value: make, child: Text(make)));
    }
    return makeItems;
  }

  static List<DropdownMenuItem<String>> getModelOptions() {
    List<DropdownMenuItem<String>> modelItems = [];

    if (selectedMake == "") {
      //print("Empty make");
      modelItems.add(const DropdownMenuItem(value: "", child: Text("Select a Make")));
      return modelItems;
    }
    else {
      modelItems = [];
      modelApi();
      for (String model in models) {
        //print(model);
        modelItems.add(DropdownMenuItem(value: model, child: Text(model)));
      }
      return modelItems;
    }
  }

  static String price = "?";
  static Car currentCar = Car(-1, "","","","","");

  static Future<void> search(context, String make, String model) async {
    // API returns image, price, brandLogo, and histogramData

    if (selectedMake == "") {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Select a car make'),
        ),//
      );
    }
    else if (selectedModel == "" ){
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Select a car model'),
        ),//
      );
    }
    else {
      String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/search';
      String payload = '{"jwtToken":"${currentUser.token}","make":"$make","model":"$model"}';
      var ret = await CarsData.getJson(url,payload);
      var jsonObj = json.decode(ret);
      print(jsonObj["histogramData"].runtimeType);
      print(jsonObj["histogramData"]);

      print("Searching for $make $model");

      price = "\$${jsonObj["price"]}";
      print(price);

      currentCar = Car(-1, make, model, price, jsonObj["type"], jsonObj["histogramData"]);

      String picUrl = jsonObj["image"];
      appCars.carPic = Image.network(picUrl, width: 350,);
    }
  }


}