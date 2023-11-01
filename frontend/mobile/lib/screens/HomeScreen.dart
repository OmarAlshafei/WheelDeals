import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'package:mobile/utils/Cars.dart';
import 'package:mobile/screens/CarsScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              title: const Text('Login/Signup'),
              onTap: () {

                Navigator.pushNamed(context, Routes.LOGINSCREEN);
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     title: Text('Login/Signup'),
                //   ),//AlertDialog
                // );
              },
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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Account'),
                  ),//AlertDialog
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                  ),//AlertDialog
                );
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

  appCars _data = appCars();
  List<bool> fav = <bool>[];

  @override
  void initState() {
    super.initState();
  }

  Set<String> carList = {
    "2016\tFord\tF150\n\$10,000",
    "2018\tToyota\tCamry\n\$11,000",
    "2017\tFord\tExplorer\n\$12,000"
  };



  Widget tableRow(String str) {
    return Container(
      child: GestureDetector(

        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gesture Detected!')));
        },
        child: Container(
          height: 75,
          width: 380,
          child: Card(
            elevation: 5,
            child: Text(str),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void favorite(int id, int index) {

    //AlertDialog(content:Text("something"));
    setState(() {
      fav[index] = !fav[index];
    });
    //Navigator.pushNamed(context, Routes.CARSSCREEN);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    String favMessage="";
    IconData type;
    switch (_data.getType(index)) {
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
          CarouselSlider(
            options: CarouselOptions(),
            items: imgList
                .map((item) => Container(
              child: Center(
                  child:
                  Image.network(item, fit: BoxFit.cover, width: 1000)),
            ))
                .toList(),
          ),
          GestureDetector(
            child: Card(
              elevation: 4.0,
              color: appColors.gray,
              child: Column(
              children: [
                ListTile(
                  title: Text("${_data.getYear(index)} ${_data.getMake(index)} ${_data.getModel(index)}"),
                  subtitle: Text(_data.getPrice(index)),
                  trailing: Theme (
                    data: ThemeData(useMaterial3: true),
                    child: IconButton(
                      isSelected: fav[index],
                      color: appColors.red,
                      onPressed: () {
                      favorite(_data.getId(index), index);
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
                    Spacer(),
                    ButtonBar(
                      children: [
                        TextButton(
                          child: const Text('MORE INFO',
                          style:TextStyle(color:appColors.navy)),
                          onPressed: () {
                            //getCarId(_data.getId(index));
                            Navigator.pushNamed(context, Routes.CARSSCREEN);
                          },
                        )
                      ],
                    )
                  ],
                ),
                ],
              )
            ),
            onTap: () => {
              const AlertDialog(
                content: Text("See more info"),
              )
            }
          ),
        ],
      );
    }
    return GestureDetector(
      child: Card(
          elevation: 4.0,
          color: appColors.gray,
          child: Column(
            children: [
              ListTile(
                title: Text("${_data.getYear(index)} ${_data.getMake(index)} ${_data.getModel(index)}"),
                subtitle: Text(_data.getPrice(index)),
                trailing: Theme (
                    data: ThemeData(useMaterial3: true),
                    child: IconButton(
                      isSelected: fav[index],
                      color: appColors.red,
                      onPressed: () {
                        favorite(_data.getId(index), index);
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
                  Spacer(),
                  ButtonBar(
                    children: [
                      TextButton(
                        child: const Text('MORE INFO',
                            style:TextStyle(color:appColors.navy)),
                        onPressed: () {
                          //getCarId(_data.getId(index));
                          Navigator.pushNamed(context, Routes.CARSSCREEN);
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          )
      ),
      onTap: () => {
        const AlertDialog(
          content: Text("See more info"),
        )
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    appCars _data = appCars();

    // initialize favorites list to all false
    for (int i=0; i < _data.getLength(); i++) {
      fav.add(false);
    }

    return Container(
        child: SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          child:
            Column(
                children: <Widget>[
                  // CarouselSlider(
                  //   options: CarouselOptions(),
                  //   items: imgList
                  //       .map((item) => Container(
                  //     child: Center(
                  //         child:
                  //         Image.network(item, fit: BoxFit.cover, width: 1000)),
                  //   ))
                  //       .toList(),
                  // ),
                  SizedBox(
                    height: 2000,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(5.5),
                      itemCount: _data.getLength(),
                      itemBuilder: _itemBuilder,
                    ),
                  ),


                  // buildCard("2016 Ford F150","\$15,000"),
                  // buildCard("2021 Toyota Camry","\$12,000"),
                  // buildCard("2018 Ford Explorer","\$14,000"),
                  // buildCard("2016 Mazda Mazda3","\$10,000"),

                ]
            )
        )

    );
  }
}
