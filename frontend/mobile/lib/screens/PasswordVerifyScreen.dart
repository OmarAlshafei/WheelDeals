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


class PasswordVerifyScreen extends StatefulWidget {
  @override
  _PasswordVerifyScreenState createState() => _PasswordVerifyScreenState();
}

class _PasswordVerifyScreenState extends State<PasswordVerifyScreen> {
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
  bool verificationSent = false;
  String code = "";String pass1 = "";
  String pass2 = "";

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

  Future<void> sendCode() async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/resetPassword';
    String payload = '{"email":"${currentUser.email}"}';
    var ret = await CarsData.getJson(url, payload);
    var jsonObject = json.decode(ret);
    print(payload);
    print(jsonObject);
  }

  Future<void> verify(String token) async {
    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/confirmEmail';
    String payload = '{"jwtToken":"$token","email":"${currentUser.email}"}';
    var ret = await CarsData.getJson(url, payload);
    var jsonObject = json.decode(ret);
    print(payload);
    print(jsonObject);

    if (jsonObject["msg"] != "Your account has been successfully verified") {
      message = "Invalid code";
      messageColor = appColors.errRed;
      changeText();
    }
    else {
      Navigator.pushNamed(context, Routes.CHANGEPASSSCREEN);
    }
  }


  @override
  Widget build(BuildContext context) {

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //margin:const EdgeInsets.only(left: 55.0),
                          child:
                          const Text(
                            "Before you change your password,",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //margin:const EdgeInsets.only(left: 55.0),
                          child:
                          const Text(
                            "please enter your email for a verification code.",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),


                    Row(
                        children: <Widget>[
                          Container(
                            width: 320,
                            margin:const EdgeInsets.only(left: 50.0, top:20),
                            child:
                            TextField (
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  hintText: 'Enter your email address'
                              ),
                              onChanged: (text) {
                                currentUser.email = text;
                              },
                            ),
                          ),
                        ]
                    ), // Email

                    Container(
                      margin:const EdgeInsets.only(top:20),
                      child: ElevatedButton(
                          child: const Text("Get code",style: TextStyle(fontSize: 14 ,color:Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.gold,
                          ),
                          onPressed: () async
                          {
                            newMessageText = "Check your email for a verification code!";
                            messageColor = appColors.black;
                            changeText();
                            await sendCode();
                            Navigator.pushNamed(context, Routes.PASSVERIFYSCREEN2);
                          }
                      ),
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
                    ),
                  ],
                )
            )
        )
    );
  }
}
