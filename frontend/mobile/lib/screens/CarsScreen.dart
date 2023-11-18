import 'package:charts_flutter/flutter.dart' as flutter;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'dart:convert';
import 'package:mobile/utils/currentUser.dart' as currentUser;
import 'package:mobile/utils/Cars.dart';
import 'package:intl/intl.dart';
import 'package:mobile/screens/CarsScreen.dart' as carsScreen;
import '../utils/Favorites.dart';



class histData {
  final double percentOfMarket;
  //final String bucket;
  // final String minPrice;
  // final String maxPrice;
  final String priceRng;

  //histData(this.percentOfMarket, this.bucket);
  histData(this.percentOfMarket, this.priceRng);

  @override
  String toString() {
    return "$percentOfMarket: $priceRng";
  }

  static List<histData> makeHist(List jsonData) {
    List<histData> data = [];
    data = consolidate(jsonData);
    int i = 0;
    for (var obj in jsonData) {
      // double thousand = obj["bucket"] / 1000;
      // data.add(histData(obj["percentOfMarket"], "\$${thousand.toStringAsFixed(0)}k");
      // print("i = $i");
      // i++;
    }

    //print(data.length);

    return data;
  }

  static List<histData> consolidate(List jsonData) {
    int numBuckets = 5;
    int len = jsonData.length;
    print("len: $len");
    int numPerBucket = (len/(numBuckets-1)).floor();
    print("numPerBucket: $numPerBucket");
    int maxNumFull = (len/numPerBucket).floor();
    print("max full buckets: $maxNumFull");
    int numFull = 0;
    int objNum = 0;
    int i;
    String minPrice = "";
    String maxPrice = "";
    String price = "";
    double percent = 0;
    var obj;
    List<histData> data = [];
    histData bar;

    while (numFull < maxNumFull) {
      percent = 0;
      //print("Bucket #" "${numFull}");
      for (i = 0; i < numPerBucket; i++) {
        print("Object number: $objNum");
        obj = jsonData[objNum++];  // Get next object
        price = "\$${(obj["bucket"] / 1000).toStringAsFixed(0)}k";
        if (i == 0) { minPrice = price; }
        if (i == numPerBucket - 1) { maxPrice = price; }
        percent += obj["percentOfMarket"];
      }
      numFull++;
      bar = histData(percent, "$minPrice-$maxPrice");
      print(bar);
      data.add(bar);
    }
    // Fill up last bar/bin
    bool first = true;
    percent = 0;
    while (objNum < len) {
      print("Object Number: $objNum");
      // print(obj["bucket"]);
      // print(obj["percentOfMarket"]);
      obj = jsonData[objNum++];
      price = "\$${(obj["bucket"] / 1000).toStringAsFixed(0)}k";

      if (first) {
        minPrice = price;
        first = false;
      }
      percent += obj["percentOfMarket"];
    }
    if (!first) {
      maxPrice = price;
      bar = histData(percent, "$minPrice-$maxPrice");
      print(bar);
      data.add(bar);
    }

    return data;
  }
}

class histChart extends StatelessWidget {
  final List<histData> data = appCars.currentCar.histDataList;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<histData, String>> series = [
      charts.Series(
          id: "carHistogram",
          data: data,
          domainFn: (histData series, _) => series.priceRng,
          measureFn: (histData series, _) => series.percentOfMarket,
      )
    ];

    return Card(
      //height: 700,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                  "Percent of Market with Different Prices",
                  style: TextStyle(fontSize: 18),
              ),
              Container(
                  height: 500,
                  width: 355,
                  child: charts.BarChart(series)
              ),
            ],
          )
        ),
    );


  }

}


class CarsScreen extends StatefulWidget {
  @override
  CarsScreenState createState() => CarsScreenState();
}

class CarsScreenState extends State<CarsScreen> {
  @override
   void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      endDrawer: Drawer(
          child: Column(
            children: [
              const SizedBox(
                height: 110, // To change the height of DrawerHeader
                width: double.infinity, // To Change the width of DrawerHeader
                child: DrawerHeader(
                  decoration: BoxDecoration(color: appColors.gold),
                  child: Text('Menu',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Favorites'),
                onTap: () {
                  Navigator.pushNamed(context, Routes.FAVSCREEN);
                },
              ),
              ListTile(
                title: const Text('Account'),
                onTap: () {
                  Navigator.pushNamed(context, Routes.ACCOUNTSCREEN);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  currentUser.clear();
                  Navigator.pushNamed(context, Routes.LOGINSCREEN);
                },
              ),
            ],
          )
      ),
      backgroundColor: Colors.white,
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String carId = "";
  appCars _data = appCars();
  int carIndex = appCars.getCarIndex();
  Car car = appCars.currentCar;
  bool fav = Favorites.isFav(appCars.currentCar.make, appCars.currentCar.model);

  @override
  void initState() {
    super.initState();
  }

  // List<DataRow> getRows() {
  //   List<DataRow> rows = [];
  //   for (var data in appCars.currentCar.histDataList) {
  //     rows.add(
  //         DataRow(
  //             cells: <DataCell> [
  //               //DataCell(Text(data.bucket, textAlign: TextAlign.center,)),
  //               DataCell(Text("${data.percentOfMarket}", textAlign: TextAlign.center))
  //             ]
  //         )
  //     );
  //   }
  //
  //   return rows;
  // }

  // Widget buildDataTable() {
  //   return DataTable(
  //     columns: const<DataColumn> [
  //       // DataColumn(
  //       //     label: Center(child: Text("Price", textAlign: TextAlign.center))
  //       // ),
  //       DataColumn(
  //           label: Center(child: Text("% of Market", textAlign: TextAlign.center))
  //       ),
  //     ],
  //     rows: getRows(),
  //     sortColumnIndex: 1,
  //     sortAscending: false,
  //     border: TableBorder.all(),
  //     columnSpacing: 40,
  //     dataTextStyle: const TextStyle(color: appColors.black, fontSize: 18),
  //     headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  //       return appColors.navy;  // Use the default value.
  //     }),
  //     headingTextStyle: const TextStyle(color: appColors.white, fontSize: 18),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    String make = car.make;
    String model = car.model;
    String price = car.price;

    //print(fav);

    return SingleChildScrollView(
      child:  Container(
          width: 400,
          margin: EdgeInsets.only(left:10.0, top:20),
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(bottom: 20.0),
                        child:
                        const Text(
                          "Car Information",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),// title
                  ListTile(
                    title: Text("$make $model", style: const TextStyle(fontSize: 28),),
                    subtitle: Text(price, style: const TextStyle(color: appColors.black, fontSize: 20),),
                    trailing: Theme (
                        data: ThemeData(useMaterial3: true),
                        child: IconButton(
                          isSelected: fav,
                          color: appColors.red,
                          onPressed: () {
                            if (fav) {
                              Favorites.unfavorite(context, make, model, "carInfo");
                            }
                            else {
                              Favorites.favorite(context, make, model, "carInfo");
                            }
                          },
                          icon: const Icon(Icons.favorite_outline, size: 35,),
                          selectedIcon: const Icon(Icons.favorite, size: 35),
                        )
                    ),
                  ),//TITLE
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 15.0),
                        alignment: Alignment.center,
                        child: appCars.carPic,
                        //child: picture,
                      )
                    ],
                  ),// PIC
                  // Row(
                  //   //mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.only(left:75),
                  //       child: buildDataTable()
                  //     )
                  //   ],
                  // ),
                  Row (
                      children:[
                        Container(
                          //margin: const EdgeInsets.only(left:50, top:30),
                            alignment: Alignment.center,
                            child: histChart()
                          //child: const Text("Working on histogram")
                        )
                      ]
                  )
                ],
              )

          )
      )
    );
  }

}
