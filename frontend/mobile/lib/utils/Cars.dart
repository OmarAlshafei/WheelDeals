import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;
import 'package:mobile/screens/CarsScreen.dart' as carsScreen;

class Car {
  String make = "";
  String model = "";
  String type = "?";
  String price = "?";
  int rank = -1;
  List<carsScreen.histData> histDataList = [];

  Car(this.rank, this.make, this.model, this.price, this.type, this.histDataList);

  factory Car.fromJson(dynamic json) {
    return Car(json['rank'] as int, json['make'] as String, json['model'] as String, json['price'] as String, json['type'] as String, carsScreen.histData.makeHist(json['histogramData']));
  }

  @override
  String toString() {
    return '{ $make, $model , $price, $type}';
  }

}

class appCars {

  static List<Car> popularCars = [];
  static int currentCarIndex = -1;
  static Image carPic = Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNOLQiaToHY1eu0J6Bz5XD5-IoBxrhcf3XeQ&usqp=CAU");

  static void initPopularCars() {
    for (int i = 0; i < 25; i++) {
      popularCars.add(Car(-1,"","","","",[]));
    }
  }

  static Future<List<Car>> getHomeApi() async {

    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/homepage';
    String payload = '{"jwtToken":"${currentUser.token}"}';
    var ret = await CarsData.getJson(url, payload);
    var jsonObject = json.decode(ret);
    var obj;
    //print(jsonObject["matchedCars"]);

    for (int i=0; i < jsonObject["matchedCars"].length; i++) {
      obj = jsonObject["matchedCars"][i];
      //popularCars[i] = Car(i+1, obj["brand"], obj["model"], "\$${obj['price']}", obj["type"], []);
      popularCars.add(Car(i+1, obj["brand"], obj["model"], "\$${obj['price']}", obj["type"], []));
    }

    popularCars = popularCars.sublist(0, 25); // keep 1st 25 (fixing extra empty cars)
    return popularCars;
  }

  static Future<Car> searchCar(String make, String model, context) async{
    searchedMake = make;
    searchedModel = model;

    String ret = await search(context, searchedMake, searchedModel);
    var jsonObj = json.decode(ret);
    print(ret);
    currentCar = Car(-1, searchedMake, searchedModel, price, jsonObj["type"], carsScreen.histData.makeHist(jsonObj['histogramData']));
    print("In select car");
    print(currentCar);

    return currentCar;
  }


  // for more car info
  static Future<Car> selectCar(int index, context, String origin) async {
    currentCarIndex = index;
    selectedMake = (origin == "fav") ? getMake(index, currentUser.favCars) : getMake(index, popularCars);
    selectedModel = (origin == "fav") ? getModel(index, currentUser.favCars) : getModel(index, popularCars);

    String ret = await search(context, selectedMake, selectedModel);
    var jsonObj = json.decode(ret);
    currentCar = Car(-1, selectedMake, selectedModel, price, jsonObj["type"], carsScreen.histData.makeHist(jsonObj['histogramData']));
    
    return currentCar;
  }

  static int getCarIndex() {
    return currentCarIndex;
  }

  static String getMake(int index, List<Car> arr) {
    return arr[index].make;
  }

  static String getModel(int index, List<Car> arr) {
    //if (_data == null) return "";
    return arr[index].model;
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

  static String searchedMake = "";
  static String searchedModel = "";

  static void makeApi() async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/makes';
    String payload = '{"jwtToken":"${currentUser.token}"}';
    var ret = await CarsData.getJson(url,payload);
    print("Make API: $ret");
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

  static void modelApiHelper() async {
    await modelApi();
  }

  static Future<void> modelApi() async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/models';
    //print("Selected Make: $selectedMake");
    String payload = '{"jwtToken":"${currentUser.token}","make":"$searchedMake"}';
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



  static List<DropdownMenuItem<String>> getModelOptions()  {
    List<DropdownMenuItem<String>> modelItems = [];

    if (searchedMake == "") {
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
  static Car currentCar = Car(-1, "","","","",[]);

  static Future<String> search(context, String make, String model) async {
    // API returns image, price, brandLogo, and histogramData
    var ret = '';
    var jsonObj;

    print("In search\nSearching $make $model");

    if (model == "") {
      print("uh oh");
    }
    // if (selectedMake == "") {
    //   showDialog(
    //     context: context,
    //     builder: (context) => const AlertDialog(
    //       title: Text('Select a car make'),
    //     ),//
    //   );
    // }
    // else if (selectedModel == "" ){
    //   showDialog(
    //     context: context,
    //     builder: (context) => const AlertDialog(
    //       title: Text('Select a car model'),
    //     ),//
    //   );
    // }
    else {
      String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/search';
      String payload = '{"jwtToken":"${currentUser.token}","make":"$make","model":"$model"}';
      ret = await CarsData.getJson(url,payload);
      jsonObj = json.decode(ret);

      // print(jsonObj["histogramData"].runtimeType);
      // print(jsonObj["histogramData"]);

      print("Searching for $make $model");

      price = "\$${jsonObj["price"]}";
      print(price);

      currentCar = Car(-1, make, model, price, jsonObj["type"], carsScreen.histData.makeHist(jsonObj['histogramData']));

      String picUrl = jsonObj["image"];
      appCars.carPic = Image.network(picUrl, width: 350,);
    }
    return ret;
  }


}