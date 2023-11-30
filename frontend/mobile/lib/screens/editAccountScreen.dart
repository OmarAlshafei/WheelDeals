import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'dart:convert';
import 'package:mobile/utils/currentUser.dart' as currentUser;


class EditAccountScreen extends StatefulWidget {
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
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
    String fname = currentUser.firstName;
    String lname = currentUser.lastName;
    String uname = currentUser.userName;

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
                      margin:const EdgeInsets.only(bottom: 20.0),
                      child:
                      const Text(
                        "Account Information",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),// title

                const Row(
                  children: <Widget>[
                    Text(
                      "First Name",
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    )
                  ],
                ),// name
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top:10),
                      width: 150,
                      height: 50,
                      child: TextField (
                        controller: TextEditingController(text: fname),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            //labelText: 'First Name',
                            hintText: 'Enter Your First Name'
                        ),
                        onChanged: (text) {
                          fname = text;
                        },
                      ),
                    )
                  ],
                ),
                const Row(
                  children: <Widget>[
                    Text(
                      "\nLast Name",
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    )
                  ],
                ),// name
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top:10),
                      width: 150,
                      height: 50,
                      child: TextField (
                        controller: TextEditingController(text: lname),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            //labelText: 'First Name',
                            hintText: 'Enter Your Last Name'
                        ),
                        onChanged: (text) {
                          lname = text;
                        },
                      ),
                    )
                  ],
                ),
                const Row(
                  children: <Widget>[
                    Text(
                      "\nUsername",
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    )
                  ],
                ),// name
                Row(
                  children: <Widget>[
                    Text(
                      currentUser.userName,
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),

                const Row(
                  children: <Widget>[
                    Text(
                      "\nEmail",
                      style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    )
                  ],
                ),// name
                Row(
                  children: <Widget>[
                    Text(
                      currentUser.email,
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.gold,
                        ),
                        onPressed: () async {
                            currentUser.firstName = fname;
                            currentUser.lastName = lname;
                            currentUser.userName = uname;

                            String payload = '{"userId":"${currentUser.userId}","newFirstName":"$fname","newLastName":"$lname","jwtToken":"${currentUser.token}"}';
                            print(payload);
                            String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/modify';
                            var ret = await CarsData.getJson(url, payload);
                            print(ret);

                            Navigator.pushNamed(context, Routes.ACCOUNTSCREEN);
                        },
                        child: const Text('Done',style: TextStyle(fontSize: 18,color:Colors.black)),
                      ),
                    ),
                  ],
                ),


              ],
            )

        )
    );
  }
}
