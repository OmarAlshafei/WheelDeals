import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/routes/routes.dart';

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
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.HOMESCREEN);
          },
          child: Image.asset(
              'images/wheel.png',
              width:70
          ),
        ),
        backgroundColor: Colors.black54,
        title: Text("Wheel Deals"),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 110, // To change the height of DrawerHeader
              width: double.infinity, // To Change the width of DrawerHeader
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.amber),
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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

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

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        Column(
          children: <Widget>[
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
            for (var s in carList)
              Row(
                children: <Widget>[
                  tableRow(s),
                ],
              )
          ]
        )
    );
  }
}
