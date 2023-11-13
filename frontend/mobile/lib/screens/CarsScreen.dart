import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'dart:convert';
import 'package:mobile/utils/currentUser.dart' as currentUser;
import 'package:mobile/utils/Cars.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../utils/Favorites.dart';



class CarsScreen extends StatefulWidget {
  @override
  _CarsScreenState createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
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

class histData {
  final double percentOfMarket;
  final int bucket;

  histData(this.percentOfMarket, this.bucket);
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

  SfCartesianChart makeHist(List jsonData) {
    List<histData> data = [];
    for (var obj in jsonData) {
      data.add(histData(obj["percentOfMarket"], obj["bucket"]));
    }

    return SfCartesianChart(
      title: ChartTitle(text: 'Percent of Market w/ Car Price'),
      legend: Legend(isVisible: true),
      //tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        BarSeries<histData, int>(
            name: 'GDP',
            dataSource: data,
            xValueMapper: (histData d, _) => d.bucket,
            yValueMapper: (histData d, _) => d.percentOfMarket,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true)
      ],
      primaryXAxis: NumericAxis(),
      primaryYAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
          title: AxisTitle(text: 'Car Price')),
    );
  }

  @override
  Widget build(BuildContext context) {
    String make = appCars.selectedMake;
    String model = appCars.selectedModel;
    String price = appCars.price;

    print(fav);

    return Container(
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
                      margin:const EdgeInsets.only(bottom: 40.0),
                      child:
                      const Text(
                        "Car Information",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),// title

                Row(
                  children: <Widget>[
                    Container(
                      //margin: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        "$make $model",
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      isSelected: fav,
                      color: appColors.red,
                      onPressed: () {
                        setState(() {
                          fav = !fav;
                        });
                        if (fav) {
                          Favorites.unfavorite(context, make, model, "carInfo");
                        }
                        else {
                          Favorites.favorite(context, make, model, "carInfo");
                        }
                      },
                      icon: const Icon(Icons.favorite_outline),
                      selectedIcon: const Icon(Icons.favorite),
                    )

                  ],
                ),// name
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          price,
                          style: const TextStyle(fontSize: 18),
                        )
                    )
                  ],
                ),

                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 15.0),
                      alignment: Alignment.center,
                      child: appCars.carPic,
                      //child: picture,
                    )
                  ],
                ),

                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left:50, top:30),
                      alignment: Alignment.center,
                      //child: makeHist(car.histData)
                      child: const Text("Working on histogram")
                    )
                  ],
                )
              ],
            )

        )
    );
  }

}
