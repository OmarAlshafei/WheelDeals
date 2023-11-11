import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/Cars.dart';
import 'package:mobile/utils/header.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

class GlobalData
{
  static String userId = '';
  static String firstName = '';
  static String lastName = '';
  static String loginName = '';
  static String password = '';
  // state, email
}


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      // endDrawer: Drawer(
      //     child: Column(
      //       children: [
      //         const SizedBox(
      //           height: 110, // To change the height of DrawerHeader
      //           width: double.infinity, // To Change the width of DrawerHeader
      //           child: DrawerHeader(
      //             decoration: BoxDecoration(color: Colors.amber),
      //             child: Text('Menu',
      //               style: TextStyle(color: Colors.black),
      //             ),
      //           ),
      //         ),
      //         ListTile(
      //           title: const Text('Login/Signup'),
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) => AlertDialog(
      //                 title: Text('Login/Signup'),
      //               ),//AlertDialog
      //             );
      //           },
      //         ),
      //         ListTile(
      //           title: const Text('Favorites'),
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) => AlertDialog(
      //                 title: Text('Favorites'),
      //               ),//AlertDialog
      //             );
      //           },
      //         ),
      //         ListTile(
      //           title: const Text('Account'),
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) => AlertDialog(
      //                 title: Text('Account'),
      //               ),//AlertDialog
      //             );
      //           },
      //         ),
      //         ListTile(
      //           title: const Text('Logout'),
      //           onTap: () {
      //             showDialog(
      //               context: context,
      //               builder: (context) => AlertDialog(
      //                 title: Text('Logout'),
      //               ),//AlertDialog
      //             );
      //           },
      //         ),
      //       ],
      //     )
      // ),
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

  String message = "or", newMessageText = '';
  String loginName = currentUser.userName, password = currentUser.password;
  Color messageColor = appColors.black;
  bool obscurePassword = true;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
      prefs = await SharedPreferences.getInstance();
  }

  changeText() {
    setState(() {
      message = newMessageText;
    });
  }

  Future<bool> verify() async {
    // verificationSent = true;
    // setState(() {
    //   message = "Account has not been verified\nPlease re-register.";
    //   messageColor = appColors.errRed;
    // });

    return true;
  }

  void login() async {
    newMessageText = "";
    changeText();

    bool success = true;

    String payload = '{"userName":"' + loginName.trim() + '","password":"' + password.trim() + '"}';
    var fname ='-';
    var jsonObject;
    var ret;
    var token;

    try
    {
      String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/login';
      ret = await CarsData.getJson(url, payload);
      jsonObject = json.decode(ret);
      token = jsonObject["accessToken"];
      print(token);
    }
    catch(e)
    {
      newMessageText = e.toString();
      changeText();
      return;
    }
    if (token == null) {
      newMessageText = "Incorrect Login/Password";
      messageColor = appColors.errRed;
      changeText();
      success = false;
    }
    if(success) {
      Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(token);
      print(jwtDecodedToken["email"]);
      print(jwtDecodedToken["firstName"]);
      print(jwtDecodedToken["lastName"]);
      // print(jwtDecodedToken["_id"]);
      // currentUser.userId = jwtDecodedToken["_id"];
      currentUser.firstName = jwtDecodedToken["firstName"];
      currentUser.lastName = jwtDecodedToken["lastName"];
      if (jwtDecodedToken["email"] != null) {
        currentUser.email = jwtDecodedToken["email"];
      }
      currentUser.userName = loginName;
      currentUser.password = password;
      //prefs.setString("token",token);
      currentUser.loggedIn = true;
      currentUser.token = token;

      Navigator.pushNamed(context, Routes.HOMESCREEN);
      //Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen(token:token)));
    }
    else{
      print("Why no success?");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 600,
        //margin:const EdgeInsets.only(top: 10.0),
        child:
            SingleChildScrollView (
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                //crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom:16),

                    child: Image.asset(
                        'images/chevy_camero.jpg',
                        //width: 70000,
                        height: 250,
                        fit:BoxFit.fill
                    ),
                  ),// image
                  Row(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(left: 55.0),
                        child:
                        Text(
                          "Welcome to Wheel Deals!",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),// title

                  Row(
                      children: <Widget>[
                        Container(
                          width: 200,
                          margin:const EdgeInsets.only(left: 95.0, top:20),
                          child:
                          TextField (
                            controller: TextEditingController(text: loginName),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                hintText: 'Enter Your Username'
                            ),
                            onChanged: (text) {
                              loginName = text;
                            },
                          ),
                        ),
                      ]
                  ),// username
                  Row(
                      children: <Widget>[
                        Container(
                          width: 200,
                          margin:const EdgeInsets.only(top: 10.0, left:95.0),
                          child:
                          TextField (
                            obscureText: obscurePassword,
                            controller: TextEditingController(text: password),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Enter Your Password',
                              suffixIcon: IconButton(
                                icon: Icon(obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                    },
                                  );
                                },
                              ),
                            ),
                            onChanged: (text) {
                              password = text;
                            },
                          ),
                        ),
                      ]
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin:const EdgeInsets.only(left: 160.0),
                        child:
                        ElevatedButton(
                          child: Text('Login',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.gold,
                          ),
                          onPressed: () async
                          {
                            login();
                          },
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin:const EdgeInsets.only(top: 15.0),
                          child:
                          Text(
                            message,
                            style: TextStyle(fontSize: 18, color: messageColor),
                          )
                      ),
                    ],
                  ),// message
                  Row(
                    children: [
                      Container(
                        margin:const EdgeInsets.only(left: 120.0, top: 20),
                        child:
                        ElevatedButton(
                          child: Text('Create an Account',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.gold,
                          ),
                          onPressed: () async
                          {
                            Navigator.pushNamed(context, Routes.REGISTERSCREEN);
                          },
                        ),
                      ),
                    ],
                  ),// register button
                ],
              )
            )

    );

  }
}
