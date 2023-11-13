import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../routes/routes.dart';
import '../utils/Cars.dart';
import '../utils/Favorites.dart';
import '../utils/getAPI.dart';
import '../utils/header.dart';
import '../utils/Colors.dart';
import '../utils/currentUser.dart' as currentUser;

class FavScreen extends StatefulWidget {
  // final token;
  // const HomeScreen({@required this.token,Key? key}) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {

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

//====================================================
class MainPage extends StatefulWidget {
  // final token;
  // const MainPage({@required this.token,Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    // initialize favorites list to all false
  }

  Widget _itemBuilder(BuildContext context, int index) {
    IconData type;
    String make = currentUser.favCars[index].make;
    String model = currentUser.favCars[index].model;
    String typeStr = currentUser.favCars[index].type;
    String price = currentUser.favCars[index].price;

    switch (typeStr) {
      case "Truck":
        type = FontAwesomeIcons.truckPickup;
        break;
      case "Sedan":
        type = FontAwesomeIcons.carSide;
        break;
      case "SUV":
        type = FontAwesomeIcons.vanShuttle;
        break;
      default:
        type = FontAwesomeIcons.cat;
    }
    return Container(
      height: 150,
      child: Card(
          elevation: 4.0,
          color: appColors.gray,
          child: Column(
              children: [
                ListTile(
                  title: Text("$make $model"),
                  subtitle: Text("$price"),
                  trailing: Theme (
                      data: ThemeData(useMaterial3: true),
                      child: IconButton(
                        isSelected: true,
                        color: appColors.red,
                        onPressed: () {
                          Favorites.unfavorite(context, make, model, "favScreen");
                        },
                        icon: const Icon(Icons.favorite_outline),
                        selectedIcon: const Icon(Icons.favorite),
                      )
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: FaIcon(type,color: appColors.navy),
                    ),
                    const Spacer(),
                    ButtonBar(
                      children: [
                        TextButton(
                          child: const Text('MORE INFO',
                              style:TextStyle(color:appColors.navy)),
                          onPressed: () {
                            appCars.search(context, make, model);
                            Navigator.pushNamed(context, Routes.CARSSCREEN);
                          },
                        )
                      ],
                    )
                  ],
                )
              ]
          )

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column (
        children: [
          Container(
            margin: const EdgeInsets.only(top:10, bottom:5),
            child: const Text("Favorite Cars",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28
              ),
            ),
          ) ,

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: currentUser.favCars.length,
              itemBuilder: _itemBuilder,
            ),
          )
        ]
      )


    );
  }

}