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


class PasswordVerifyScreen2 extends StatefulWidget {
  @override
  _PasswordVerifyScreen2State createState() => _PasswordVerifyScreen2State();
}

class _PasswordVerifyScreen2State extends State<PasswordVerifyScreen2> {
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
                      children: [
                        Container(
                          margin:const EdgeInsets.only(left: 55.0),
                          child:
                          Text(
                            "A verification code has been sent to",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentUser.email,
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),//title

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
                                  labelText: 'Verification Code',
                                  hintText: 'Enter the code'
                              ),
                              onChanged: (text) {
                                code = text;
                              },
                            ),
                          ),
                        ]
                    ), // code

                    Container(
                      margin:const EdgeInsets.only(top:20),
                      child: ElevatedButton(
                          child: const Text("Verify",style: TextStyle(fontSize: 14 ,color:Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColors.gold,
                          ),
                          onPressed: () async
                          {
                            print(code);
                            await verify(code);
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
