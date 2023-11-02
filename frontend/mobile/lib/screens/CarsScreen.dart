import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'dart:convert';
import 'package:mobile/utils/currentUser.dart' as currentUser;
import 'package:mobile/utils/Cars.dart';



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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Favorites'),
                    ),//AlertDialog
                  );
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String make = appCars.getMake(carIndex);
    String model = appCars.getModel(carIndex);
    int year = appCars.getYear(carIndex);
    String price = appCars.getPrice(carIndex);

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
                        "$year $make $model",
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        price,
                        style: const TextStyle(fontSize: 18),
                      )
                    )

                  ],
                ),// name

                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 30.0),
                      alignment: Alignment.center,
                      child: Image.asset("images/wheel.png"),
                    )
                  ],
                ),

                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left:50, top:30),
                      alignment: Alignment.center,
                      child: const Text(
                        "Stay tuned for more info!",
                        style: TextStyle(fontSize: 24),
                      )
                    )
                  ],
                )
              ],
            )

        )
    );
  }

}
