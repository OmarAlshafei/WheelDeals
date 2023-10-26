import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/getAPI.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/header.dart';
import 'dart:convert';

class GlobalData
{
  static int userId = 0;
  static String firstName = '';
  static String lastName = '';
  static String loginName = '';
  static String password = '';
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

  String message = "This is a message", newMessageText = '';
  String loginName = '', password = '';

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
        width: 200,
        margin:const EdgeInsets.only(left: 95.0),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontal
          children: <Widget>[
            Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child:
                    TextField (
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Login Name',
                          hintText: 'Enter Your Login Name'
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
                    margin:const EdgeInsets.only(top: 10.0),
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
                  margin:const EdgeInsets.only(left: 60.0),
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
                        //String payload = '{"login":"' + loginName.trim() + '","password":"' + password.trim() + '"}';
                        var userId = -1;
                        var fname ='-';
                        var jsonObject;

                        try
                        {
                          String url = 'https://wheeldeals-d3e9615ad014.herokuapp.com/api/login';
                          String ret = await CardsData.getJson(url, payload);
                          jsonObject = json.decode(ret);
                          //userId = jsonObject["id"];
                          fname = jsonObject["firstName"];
                        }
                        catch(e)
                        {
                          newMessageText = e.toString();
                          changeText();
                          return;
                        }
                        //if( userId <= 0 )
                        if (fname == '-')
                        {
                          newMessageText = "Incorrect Login/Password";
                          changeText();
                        }
                        else
                        {
                          GlobalData.userId = userId;
                          GlobalData.firstName = jsonObject["firstName"];
                          GlobalData.lastName = jsonObject["lastName"];
                          GlobalData.loginName = loginName;
                          GlobalData.password = password;
                          Navigator.pushNamed(context, '/cards');
                        }
                      },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
              Text('$message',style: TextStyle(fontSize: 14 ,color:Colors.black)),
              ],
            )
          ],
        )
    );

    //return Container(
    //     margin: const EdgeInsets.all(150.0),
    //     child: ElevatedButton(
    //       child: Text('Login',style: TextStyle(fontSize: 14 ,color:Colors.black)),
    //       style: ElevatedButton.styleFrom(
    //         primary: Colors.amber,
    //       ),
    //       onPressed: ()
    //       {
    //         showDialog(
    //           context: context,
    //           builder: (context) => AlertDialog(
    //             title: Text('Login'),
    //             content: Text('Enter username & password'),
    //           ),//AlertDialog
    //         );
    //       },
    //     ),// Elevated button
    // );

  }
}
