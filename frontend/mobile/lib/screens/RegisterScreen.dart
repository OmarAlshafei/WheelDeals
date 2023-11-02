import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;
import 'dart:convert';
import 'package:mobile/routes/routes.dart';

class GlobalData
{
  static String userId = '';
  static String firstName = '';
  static String lastName = '';
  static String loginName = '';
  static String password = '';
  static String state = '';
  static String email = '';
// state, email
}


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:Header(),
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
              /*
              ListTile(
                title: const Text('Login'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Login'),
                    ),//AlertDialog
                  );
                },
              ),
              ListTile(
                title: const Text('Register'),
                //login/signup->register
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Register'),
                      //login/signup->register
                    ),//AlertDialog
                  );
                },
              ), */
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

  String message = " ", newMessageText = '';
  String loginName = '', password = '';
  String firstName = '', lastName = '';
  String state = '', email = '';

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

  /*
  return new Container(
  child: new SingleChildScrollView(
    child: new Column(
      children: <Widget>[
        _showChild1(),
        _showChild2(),
        ...
        _showChildN()
      ]
    )
  )
);
   */

  @override
  Widget build(BuildContext context) {
    return Container(

        width: 600,
        margin:const EdgeInsets.only(top: 20.0),

        child: SingleChildScrollView(

        child :Column(
          mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
          //crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
            ), //title


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
                          labelText: 'First name',
                          hintText: 'Enter Your first name'
                      ),
                      onChanged: (text) {
                        firstName = text;
                      },
                    ),
                  ),
                ]
            ), // first name

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
                          labelText: 'Last name',
                          hintText: 'Enter Your last name'
                      ),
                      onChanged: (text) {
                        lastName = text;
                      },
                    ),
                  ),
                ]
            ), // last name

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
            ), // username


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
            ), // password



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
                          labelText: 'Email',
                          hintText: 'Enter Your email'
                      ),
                      onChanged: (text) {
                        email = text;
                      },
                    ),
                  ),
                ]
            ), // email


            Row(
              children: <Widget>[
                Container(
                  margin:const EdgeInsets.only(left: 160.0),
                  child:
                  ElevatedButton(
                    child: Text('Register',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.gold,
                    ),
                    onPressed: () async
                    {
                      newMessageText = "";
                      changeText();

                     // String payload = '{"userName":"' + loginName.trim() + '","password":"' + password.trim() + '"}';
                      String payload = '{"firstName":"' + firstName.trim() + '","userName":"' + loginName.trim() + '","password":"' + password.trim() + '","state":"' + state.trim() + '","email":"' + email.trim() + '"}';
                      var userId = '';
                      var fname ='-';
                      var jsonObject;
                      String ret = 'ah';

                      if (firstName=='') {
                        newMessageText = "Please enter first name";
                        messageColor = appColors.errRed;
                        changeText();

                      }
                      if (lastName=='') {
                        newMessageText = "Please enter last name";
                        messageColor = appColors.errRed;
                        changeText();

                      }
                      if (loginName=='') {
                        newMessageText = "Please enter Username";
                        messageColor = appColors.errRed;
                        changeText();

                      }
                      if (password=='') {
                        newMessageText = "Please enter password";
                        messageColor = appColors.errRed;
                        changeText();

                      }

                      if (email=='') {
                        newMessageText = "Please enter email";
                        messageColor = appColors.errRed;
                        changeText();

                      }

                      try
                      {
                        String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/register';
                        ret = await CarsData.getJson(url, payload);
                        jsonObject = json.decode(ret);
                        // newMessageText = jsonObject["message"];
                        // changeText();
                        //fname = jsonObject["firstName"];
                      }
                      catch(e)
                      {
                        newMessageText = e.toString();
                        changeText();
                        return;
                      }
                      if (fname == '')
                      {

                        if (firstName == '' ) {
                          newMessageText = "Please enter first name";
                        }
                        else if (lastName == '') {
                          newMessageText = "Please enter last name";
                        }
                        else if (loginName == '') {
                          newMessageText = "Please enter Username";
                        }
                        else if (password == '') {
                          newMessageText = "Please enter Password";
                        }

                        /*
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
                        */

                        messageColor = appColors.errRed;
                        changeText();
                      }
                      else
                      {
                        //currentUser.userId = jsonObject["_id"];
                        // currentUser.fName = jsonObject["firstName"];
                        // currentUser.lName = jsonObject["lastName"];
                        // currentUser.email = jsonObject["email"];
                        currentUser.userName = loginName;
                        currentUser.password = password;
                        //currentUser.state = state;
                        //currentUser.email = email;
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
            /*
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
                      Navigator.pushNamed(context, Routes.CARSSCREEN);
                    },
                  ),
                ),
              ],
            ),

            */
          ],
        )
      )
    );

  }
}
