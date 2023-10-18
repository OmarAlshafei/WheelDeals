import 'package:flutter/material.dart';


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
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Image.asset(
            'images/wheel.png',
            width:80
        ),
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

  @override
  void initState() {
    super.initState();
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
                        primary: Colors.amber,
                      ),
                      onPressed: ()
                      {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Login'),
                            content: Text('Enter username & password'),
                          ),//AlertDialog
                        );
                      },
                    ),
                ),
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
