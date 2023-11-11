import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'package:mobile/utils/Cars.dart';
import 'package:mobile/screens/LoginScreen.dart' as login;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;

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
    //print("Here1" + currentUser.token + "!");
    print(jwtDecodedToken["email"]);
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
                        title: Text("${appCars.getYear(index)} ${appCars.getMake(index)} ${appCars.getModel(index)}"),
                        subtitle: Text(appCars.getPrice(index)),
                        trailing: Theme (
                            data: ThemeData(useMaterial3: true),
                            child: IconButton(
                              isSelected: fav[index],
                              color: appColors.red,
                              onPressed: () {
                                favorite(appCars.getId(index), index);
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
                                  appCars.setCarIndex(index);
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
                    title: Text("${appCars.getYear(index)} ${appCars.getMake(index)} ${appCars.getModel(index)}"),
                    subtitle: Text(appCars.getPrice(index)),
                    trailing: Theme (
                        data: ThemeData(useMaterial3: true),
                        child: IconButton(
                          isSelected: fav[index],
                          color: appColors.red,
                          onPressed: () {
                            favorite(appCars.getId(index), index);
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
                              appCars.setCarIndex(index);
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
    //appCars _data = appCars();
    String urlModels = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/models';

    return Container(
      child: Column(
        children: [

          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text("Search:", style: TextStyle(fontSize: 18),)
              ),
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: appColors.gray,
                  border: Border.all(color: appColors.black),
                ),
                child: DropdownButton(
                  hint: Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: const Text("Make")
                  ),
                  items: appCars.getMakeOptions(),
                  dropdownColor: appColors.gray,
                  onChanged: (String? newValue){
                    setState(() {
                      appCars.selectedMake = newValue!;
                      //print(selectedMake);
                      //appCars.makeApi();
                    });
                  },
                ),
              ),// MAKE
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: appColors.gray,
                  border: Border.all(color: appColors.black),
                ),
                child: DropdownButton(
                  hint: Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: const Text("Model")
                  ),
                  items: appCars.getModelOptions(),
                  dropdownColor: appColors.gray,
                  onChanged: (String? newValue){
                    setState(() {
                      appCars.selectedMake = newValue!;
                      //appCars.makeApi();
                    });
                  },
                ),
              ),
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
