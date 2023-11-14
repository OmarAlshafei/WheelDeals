import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/screens/FavScreen.dart';
import 'package:mobile/utils/header.dart';
import 'package:mobile/utils/Cars.dart';
import 'package:mobile/utils/Favorites.dart' as favClass;
import 'package:mobile/screens/CarsScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;

import '../utils/Favorites.dart';
import '../utils/currentUser.dart';
import '../utils/getAPI.dart';

final List<String> imgList = [
  'https://www.lensrentals.com/blog/media/2015/11/Automotive-Photography-Guide-1.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwVLDj3Q7Pmq_x5CNlPHlY4OR3RraFbZZm1Q&usqp=CAU'
];

class HomeScreen extends StatefulWidget {
  // final token;
  // const HomeScreen({@required this.token,Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

  HomeScreen({@required this.CarsScreenState});

  final CarsScreenState;
}

class _HomeScreenState extends State<HomeScreen> {

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

  String make = "Make";
  String model = "Model";

  Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(currentUser.token);

  void getHomeApiHelper() async {
    await appCars.getHomeApi();
  }


  @override
  void initState() {
    appCars.initPopularCars();  // set all to empty
    getHomeApiHelper();
    super.initState();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    IconData type;
    bool fav = Favorites.isFav(appCars.popularCars[index].make, appCars.popularCars[index].model);
    String make = appCars.popularCars[index].make;
    String model = appCars.popularCars[index].model;
    String price = appCars.popularCars[index].price;
    int rank = appCars.popularCars[index].rank;

    switch (appCars.popularCars[index].type) {
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
    if (index == 0) {
      return Column (
        children: [
          Container(
            //margin:const EdgeInsets.only(bottom: 10.0),
            child: CarouselSlider(
              options: CarouselOptions(),
              items: imgList
                  .map((item) => Container(
                child: Center(
                    child:
                    Image.network(item, fit: BoxFit.cover, width: 1000)),
              ))
                  .toList(),
            ),
          ),
          Container(
            child: const Text(
              "Popular Cars",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28
              ),
            )
          ), // TITLE
          Container(
            height: 150,
            child: Card(
                elevation: 4.0,
                color: appColors.gray,
                child: Column(
                    children: [
                      ListTile(
                        title: Text("$rank) $make $model"),
                        subtitle: Text(price, style: const TextStyle(color: appColors.black),),
                        trailing: Theme (
                            data: ThemeData(useMaterial3: true),
                            child: IconButton(
                              isSelected: fav,
                              color: appColors.red,
                              onPressed: () {
                                if (fav) {
                                  Favorites.unfavorite(context, make, model, "home");
                                }
                                else {
                                  Favorites.favorite(context, make, model, "home");
                                }
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
                                onPressed: () async {
                                  appCars.currentCar = await appCars.selectCar(index, context, "home");
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
          )  // FIRST CARD
        ],
      );
    } // Make slideshow before first card
    return Container(
      height: 150,
      child: Card(
            elevation: 4.0,
            color: appColors.gray,
            child: Column(
                children: [
                  ListTile(
                    title: Text("$rank) $make $model"),
                    subtitle: Text(price, style: const TextStyle(color: appColors.black),),
                    trailing: Theme (
                        data: ThemeData(useMaterial3: true),
                        child: IconButton(
                          isSelected: fav,
                          color: appColors.red,
                          onPressed: () {
                            if (fav) {
                              Favorites.unfavorite(context, make, model, "home");
                            }
                            else {
                              Favorites.favorite(context, make, model, "home");
                            }
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
                            onPressed: () async {
                              appCars.currentCar = await appCars.selectCar(index, context, "home");
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
    ); // CARD
  }

  @override
  Widget build(BuildContext context) {

    String makeText = (appCars.selectedMake == "") ? "Make" : appCars.selectedMake;
    String modelText = (appCars.selectedModel == "") ? "Model" : appCars.selectedModel;

    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left:5, top:10),
            child: const Text("Search:", style: TextStyle(fontSize: 18),)
          ), // SEARCH TITLE
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top:5, bottom:10, left: 5),
                height:35,
                width: 140,
                decoration: BoxDecoration(
                  color: appColors.gray,
                  border: Border.all(color: appColors.black),
                ),
                child: DropdownButton(
                  hint: Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: Text(makeText)
                  ),
                  items: appCars.getMakeOptions(),
                  dropdownColor: appColors.gray,
                  onChanged: (String? newValue) async {
                    appCars.selectedMake = newValue!;
                    await appCars.modelApi();
                    setState(() {
                      make = newValue!;
                      // print("Make: ${appCars.selectedMake}");
                      appCars.selectedModel = ""; // no cross contamination
                      //print(selectedMake);
                      //appCars.makeApi();
                    });
                  },
                ),
              ),// MAKE DROPDOWN
              Container(
                height: 35,
                margin: const EdgeInsets.only(top:5, bottom:10, left: 5),
                decoration: BoxDecoration(
                  color: appColors.gray,
                  border: Border.all(color: appColors.black),
                ),
                child: DropdownButton(
                  hint: Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: Text(modelText)
                  ),
                  items: appCars.getModelOptions(),
                  dropdownColor: appColors.gray,
                  onChanged: (String? newValue){
                    setState(() {
                      appCars.selectedModel = newValue!;
                      model = newValue!;
                      // print("Model: ${appCars.selectedModel}");
                      //appCars.makeApi();
                    });
                  },
                ),
              ), // MODEL DROPDOWN
              Container(
                //margin: const EdgeInsets.all(5),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await appCars.search(context, appCars.selectedMake, appCars.selectedModel);
                    Navigator.pushNamed(context, Routes.CARSSCREEN);
                  },)
              )
            ],
          ), // SEARCH

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: appCars.popularCars.length,
              itemBuilder: _itemBuilder,
            ),
          )

        ],
      )
    );
  }
}
