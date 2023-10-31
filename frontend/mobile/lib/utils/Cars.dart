class appCars {
  Map fetchedData = {
    "data": [
      {"id": 1, "make": "Ford", "model":"F150", "year":2020, "price":"\$13,000","type":"truck"},
      {"id": 2, "make": "Ford", "model":"Explorer", "year":2018, "price":"\$12,000","type":"suv"},
      {"id": 3, "make": "Mazda", "model":"Mazda3", "year":2016, "price":"\$11,000","type":"sedan"},
      {"id": 4, "make": "Toyota", "model":"Camry", "year":2021, "price":"\$12,000","type":"sedan"},
    ]
  };
  List? _data;

  appCars() {
    _data = fetchedData["data"];
  }

  int getId(int index) {
    return _data![index]["id"];
  }

  String getMake(int index) {
    return _data![index]["make"];
  }

  String getModel(int index) {
    if (_data == null) return "";
    return _data![index]["model"];
  }

  int getYear(int index) {
    if (_data == null) return -1;
    return _data![index]["year"];
  }

  String getPrice(int index) {
    return _data![index]["price"];
  }

  String getType(int index) {
    return _data![index]["type"];
  }

  int getLength() {
    return _data!.length;
  }
}