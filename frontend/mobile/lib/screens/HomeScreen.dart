import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'package:mobile/utils/Cars.dart';
import 'package:mobile/screens/CarsScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;

final List<String> imgList = [
  'https://www.lensrentals.com/blog/media/2015/11/Automotive-Photography-Guide-1.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwVLDj3Q7Pmq_x5CNlPHlY4OR3RraFbZZm1Q&usqp=CAU'
];

class HomeScreen extends StatefulWidget {
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

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final appCars _data = appCars();
  List<bool> fav = <bool>[];

  @override
  void initState() {
    super.initState();
    // initialize favorites list to all false
    for (int i=0; i < _data.getLength(); i++) {
      fav.add(false);
    }
  }

  void favorite(int id, int index) {

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
          // child: Column(
          //   children: [
          //     ListTile(
          //       title: Text("${_data.getYear(index)} ${_data.getMake(index)} ${_data.getModel(index)}"),
          //       subtitle: Text(_data.getPrice(index)),
          //       trailing: Theme (
          //           data: ThemeData(useMaterial3: true),
          //           child: IconButton(
          //             isSelected: fav[index],
          //             color: appColors.red,
          //             onPressed: () {
          //               favorite(_data.getId(index), index);
          //             },
          //             icon: const Icon(Icons.favorite_outline),
          //             selectedIcon: const Icon(Icons.favorite),
          //           )
          //       ),
          //     ),
          //     Row(
          //       children: [
          //         Container(
          //           margin: const EdgeInsets.only(left: 20.0),
          //           child: FaIcon(type,color: appColors.navy),
          //         ),
          //         Spacer(),
          //         ButtonBar(
          //           children: [
          //             TextButton(
          //               child: const Text('MORE INFO',
          //                   style:TextStyle(color:appColors.navy)),
          //               onPressed: () {
          //                 //getCarId(_data.getId(index));
          //                 Navigator.pushNamed(context, Routes.CARSSCREEN);
          //               },
          //             )
          //           ],
          //         )
          //       ],
          //     ),
          //   ],
          // )
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //appCars _data = appCars();

    return Container(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _data.getLength(),
        itemBuilder: _itemBuilder,
      ),
    );
  }
}
