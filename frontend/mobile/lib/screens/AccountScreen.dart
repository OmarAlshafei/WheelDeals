import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'dart:convert';
import 'package:mobile/utils/currentUser.dart' as currentUser;


class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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

  int carId = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
                      "Account Information",
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
                      "NAME\n${currentUser.firstName} ${currentUser.lastName}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),// name

              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Text(
                      "EMAIL\n${currentUser.email}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),

              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.gold,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.FAVSCREEN);
                        },
                        child: const Text('View Favorite Vehicles',style: TextStyle(fontSize: 18,color:Colors.black)),
                      ),
                    ),
                ],
              ),// favorites


            ],
          )

        )
    );
  }
}
