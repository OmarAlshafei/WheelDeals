import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;


class appCars {
  Map fetchedData = {
    "data": [
      {"id": "1", "make": "Ford", "model":"F-150", "year":2020, "price":"\$13,000","type":"truck"},
      {"id": "2", "make": "Ford", "model":"Explorer", "year":2018, "price":"\$12,000","type":"suv"},
      {"id": "3", "make": "Mazda", "model":"Mazda3", "year":2016, "price":"\$11,000","type":"sedan"},
      {"id": "4", "make": "Toyota", "model":"Camry", "year":2021, "price":"\$12,000","type":"sedan"},
    ]
  };
  static List? _data;
  static int currentCarIndex = -1;

  static Image carPic = Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNOLQiaToHY1eu0J6Bz5XD5-IoBxrhcf3XeQ&usqp=CAU");

  appCars() {
    _data = fetchedData["data"];
  }

  static Future<String> getPicApi(String make, String model) async{
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/search';
    String payload = '{"make":"$make","model":"$model"}';
    String ret = await CarsData.getJson(url, payload);
    var jsonObject = json.decode(ret);

    return jsonObject["image"];
  }

  static void getImage(String make, String model) async {

    String pic = await getPicApi(make, model);
    print(pic);
    appCars.carPic = Image.network(pic, width: 350,);

    return;
  }

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
  static Future setCarIndex(int index) async {
    currentCarIndex = index;

    getImage(getMake(index), getModel(index));

  }

  static int getCarIndex() {
    return currentCarIndex;
  }

  static int getCarIndexFromID(String id) {
    for (int i=0; i < _data!.length; i++) {
      if (getId(i) == id) {
        return i;
      }
    }
    return -1;
  }

  static String getId(int index) {
    return _data![index]["id"];
  }

  static String getMake(int index) {
    return _data![index]["make"];
  }

  static String getModel(int index) {
    if (_data == null) return "";
    return _data![index]["model"];
  }

  static int getYear(int index) {
    if (_data == null) return -1;
    return _data![index]["year"];
  }

  static String getPrice(int index) {
    return _data![index]["price"];
  }

  static String getType(int index) {
    return _data![index]["type"];
  }

  int getLength() {
    return _data!.length;
  }

  static List<String> makes = [];
  static List<String> models = [];

  static void makeApi() async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/makes';
    String payload = '{"jwtToken":"${currentUser.token}"}';
    var ret = await CarsData.getJson(url,payload);
    print(ret);
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
    String payload = '{"jwtToken":"${currentUser.token}"}';
    print(selectedMake);
    var ret = await CarsData.getJson(url,selectedMake);
    print(ret);
    var modelsDyn = json.decode(ret);
    var modelsStr = modelsDyn.cast<String>();
    int count = 0;
    for (String m in modelsStr) {
      //print(makes);
      if (!models.contains(m)) {
        count = count + 1;
        models.add(m);
      }
    }
  }

  static List<DropdownMenuItem<String>> getMakeOptions() {
    makeApi();
    List<DropdownMenuItem<String>> makeItems = [];
    print(makes);
    for (String make in makes) {
      //print(make);
      makeItems.add(DropdownMenuItem(value: make, child: Text(make)));
    }
    return makeItems;
  }

  static String selectedMake = "";

  static List<DropdownMenuItem<String>> getModelOptions() {
    List<DropdownMenuItem<String>> modelItems = [];
    print("Selected Make: $selectedMake");

    if (selectedMake == "") {
      print("Empty make");
      modelItems.add(const DropdownMenuItem(value: "", child: Text("Select a Make")));
      return modelItems;
    }

    else {
      //modelItems.remove(""); // get rid of "Select a Make"
      modelItems = [];
      //print("Calling modelAPI");
      modelApi();
      //print("Models populated");
      for (String model in models) {
        //print(model);
        modelItems.add(DropdownMenuItem(value: model, child: Text(model)));
      }
      return modelItems;

    }
  }



}