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


class ChangePassScreen extends StatefulWidget {
  @override
  _ChangePassScreenState createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
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
  String code = "";
  String pass = "";

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

  Future<void> changePassword() async {



    String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/changePassword';
    String payload = '{"password":"$pass","email":"${currentUser.email}"}';
    var ret = await CarsData.getJson(url, payload);
    var jsonObject = json.decode(ret);
    print(payload);
    print(jsonObject);

    Navigator.pushNamed(context, Routes.LOGINSCREEN);
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //margin:const EdgeInsets.only(left: 55.0),
                              child:
                              const Text(
                                "Change your password",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ],
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 320,
                                margin:const EdgeInsets.only(top:20),
                                child:
                                TextField (
                                  decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                      labelText: 'New Password',
                                      hintText: 'Enter a new password'
                                  ),
                                  onChanged: (text) {
                                    pass = text;
                                  },
                                ),
                              ),
                            ]
                        ), // Password 1

                        Container(
                          margin:const EdgeInsets.only(top:20),
                          child: ElevatedButton(
                              child: const Text("Change Password",style: TextStyle(fontSize: 14 ,color:Colors.black)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appColors.gold,
                              ),
                              onPressed: () async
                              {
                                await changePassword();
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
