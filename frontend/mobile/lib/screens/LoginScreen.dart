import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;
import 'dart:convert';

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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Login/Signup'),
                    ),//AlertDialog
                  );
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

  String message = "or", newMessageText = '';
  String loginName = '', password = '';
  Color messageColor = appColors.black;

  @override
  void initState() {
    super.initState();
  }

  changeText() {
    setState(() {
      message = newMessageText;
    });
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
                  ),
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
                  ),

                  Row(
                      children: <Widget>[
                        Container(
                          width: 200,
                          margin:const EdgeInsets.only(left: 95.0, top:20),
                          child:
                          TextField (
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
                  ),
                  Row(
                      children: <Widget>[
                        Container(
                          width: 200,
                          margin:const EdgeInsets.only(top: 10.0, left:95.0),
                          child:
                          TextField (
                            obscureText: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                hintText: 'Enter Your Password'
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
                            newMessageText = "";
                            changeText();

                            String payload = '{"userName":"' + loginName.trim() + '","password":"' + password.trim() + '"}';
                            var userId = '';
                            var fname ='-';
                            var jsonObject;
                            String ret = 'ah';

                            if (loginName=='') {
                              newMessageText = "Please enter Username";
                              messageColor = appColors.errRed;
                              changeText();

                            }

                            try
                            {
                              String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/login';
                              ret = await CarsData.getJson(url, payload);
                              jsonObject = json.decode(ret);
                              fname = jsonObject["firstName"];
                              newMessageText = jsonObject["lastName"];
                              changeText();
                            }
                            catch(e)
                            {
                              newMessageText = e.toString();
                              changeText();
                              return;
                            }
                            if (fname == '')
                            {
                              if (loginName == '' && password == '') {
                                newMessageText = "Please enter Username and Password";
                              }
                              else if (loginName == '') {
                                newMessageText = "Please enter Username";
                              }
                              else if (password == '') {
                                newMessageText = "Please enter Password";
                              }
                              else {
                                newMessageText = "Incorrect Login/Password";
                              }
                              messageColor = appColors.errRed;
                              changeText();
                            }
                            else
                            {
                              currentUser.userId = jsonObject["_id"];
                              currentUser.fName = jsonObject["firstName"];
                              currentUser.lName = jsonObject["lastName"];
                              // currentUser.email = jsonObject["email"];
                              currentUser.userName = loginName;
                              currentUser.password = password;
                              Navigator.pushNamed(context, Routes.HOMESCREEN);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Container(
                  //       margin: const EdgeInsets.only(left: 105.0),
                  //       child: Text(
                  //           message,
                  //           style: const TextStyle(fontSize: 14 ,color:appColors.errRed),
                  //           textAlign: TextAlign.center
                  //       ),
                  //     )
                  //   ],
                  // ),
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
                  ),
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
                  ),
                ],
              )
            )

    );

  }
}
