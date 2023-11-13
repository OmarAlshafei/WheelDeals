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
import 'package:mobile/screens/LoginScreen.dart' as login;
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

  late String email;
  final appCars _data = appCars();
  List<bool> fav = <bool>[];

  Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(currentUser.token);

  //email = jwtDecodedToken["email"];

  @override
  void initState() {
    super.initState();
    // initialize favorites list to all false
    for (int i=0; i < _data.getLength(); i++) {
      fav.add(false);
    }
  }

  void favorite(String id, int index) {

    //AlertDialog(content:Text("something"));
    setState(() {
      fav[index] = !fav[index];
    });
    //Navigator.pushNamed(context, Routes.CARSSCREEN);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    IconData type;
    bool fav = Favorites.isFav(appCars.getMake(index), appCars.getModel(index));
    String make = appCars.getMake(index);
    String model = appCars.getModel(index);
    String price = appCars.getPrice(index);
    switch (appCars.getType(index)) {
      case "truck":
        type = FontAwesomeIcons.truckPickup;
        break;
      case "sedan":
        type = FontAwesomeIcons.carSide;
        break;
      case "suv":
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
          ),
          Container(
            height: 150,
            child: Card(
                elevation: 4.0,
                color: appColors.gray,
                child: Column(
                    children: [
                      ListTile(
                        title: Text("$make $model"),
                        subtitle: Text(price),
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
                                onPressed: () {
                                  //getCarId(_data.getId(index));
                                  //getImage(make, model);
                                  appCars.selectCar(index, context);
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
          )
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
                    title: Text("${appCars.getMake(index)} ${appCars.getModel(index)}"),
                    subtitle: Text(appCars.getPrice(index)),
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
                            onPressed: () {
                              appCars.selectCar(index, context);
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

  String make = "Make";
  String model = "Model";

  @override
  Widget build(BuildContext context) {
    //appCars _data = appCars();
    // appCars.selectedMake = "";
    // appCars.selectedModel = "";

    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left:5, top:10),
            child: const Text("Search:", style: TextStyle(fontSize: 18),)
          ),
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
                      child: Text(make)
                  ),
                  items: appCars.getMakeOptions(),
                  dropdownColor: appColors.gray,
                  onChanged: (String? newValue){
                    setState(() {
                      appCars.selectedMake = newValue!;
                      make = newValue!;
                      print("Make: ${appCars.selectedMake}");
                      appCars.selectedModel = ""; // no cross contamination
                      //print(selectedMake);
                      //appCars.makeApi();
                    });
                  },
                ),
              ),// MAKE
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
                      child: Text(model)
                  ),
                  items: appCars.getModelOptions(),
                  dropdownColor: appColors.gray,
                  onChanged: (String? newValue){
                    setState(() {
                      appCars.selectedModel = newValue!;
                      model = newValue!;
                      print("Model: ${appCars.selectedModel}");
                      //appCars.makeApi();
                    });
                  },
                ),
              ),
              Container(
                //margin: const EdgeInsets.all(5),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    appCars.search(context, appCars.selectedMake, appCars.selectedModel);
                    Navigator.pushNamed(context, Routes.CARSSCREEN);
                  },)
              )
            ],
          ), // Search

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _data.getLength(),
              itemBuilder: _itemBuilder,
            ),
          )

        ],
      )
    );
  }
}
