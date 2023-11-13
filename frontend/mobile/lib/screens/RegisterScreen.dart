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

// class GlobalData
// {
//   static String userId = '';
//   static String firstName = '';
//   static String lastName = '';
//   static String loginName = '';
//   static String password = '';
//   static String state = '';
//   static String email = '';
// // state, email
// }


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
  bool verificationSent = false;

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

  void register() async {
    newMessageText = "";
    changeText();

    String payload = '{"firstName":"' + firstName.trim() + '","lastName":"' + lastName.trim() + '", "userName":"' + loginName.trim() + '","password":"' + password.trim() + '","email":"' + email.trim() + '"}';
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
      // newMessageText = jsonObject["error"];
      // changeText();
      //fname = jsonObject["firstName"];
    }
    catch(e)
    {
      newMessageText = e.toString();
      changeText();
      return;
    }
    if (jsonObject["message"] != "User Added Successfully") {
      String err1 = " - At least 8 characters\n";
      String err2 = " - No more than 100 characters\n";
      String err3 = " - At least 1 uppercase character\n";
      String err4 = " - At least 1 lowercase character\n";

      newMessageText = "Error: Password requires\n$err1$err3$err4$err2";
      messageColor = appColors.errRed;
      changeText();
    }
    else
    {
      bool success = verify() as bool;

      if (success) {
        //currentUser.userId = jsonObject["_id"];
        currentUser.firstName = firstName.trim();
        currentUser.lastName = lastName.trim();
        currentUser.email = email.trim();
        currentUser.userName = loginName.trim();
        currentUser.password = password.trim();
        currentUser.loggedIn = true;

        Navigator.pushNamed(context, Routes.LOGINSCREEN);
      }
      else {
        message = "Failed to verify. Please resend the link";
        messageColor = appColors.black;
        changeText();
      }

    }
  }

  Future<bool> verify() async {
    verificationSent = true;
    setState(() {
      verificationSent = true;
      message = "Please check your email for a verification link";
      messageColor = appColors.black;
    });

    return true;
  }

  Future<bool> reVerify() async {
    verificationSent = true;
    setState(() {
      verificationSent = true;
      message = "Verification link was resent\nPlease check your email.";
      messageColor = appColors.black;
    });

    return false;
  }



  @override
  Widget build(BuildContext context) {
    String buttonText = (verificationSent) ? "Resend Verification Email" : "Register";

    return Container(

        width: 600,
        margin:const EdgeInsets.only(top: 20.0),

        child: SingleChildScrollView(

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
            //crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      margin:const EdgeInsets.only(top: 20.0, left:95.0),
                      child:
                      TextField (
                        obscureText: false,
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
              Container(
                margin:const EdgeInsets.only(top:20),
                child: ElevatedButton(
                    child: Text(buttonText,style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.gold,
                    ),
                    onPressed: () async
                    {
                      if (verificationSent) {
                        reVerify(); // resend verification email
                      }
                      else {
                        register();
                      }

                    }
                ),
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
      )
    );

  }
}
