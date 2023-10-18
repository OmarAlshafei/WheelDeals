import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';


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
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.HOMESCREEN);
          },
          child: Image.asset(
              'images/wheel.png',
              width:70
          ),
        ),

        backgroundColor: Colors.black54,
        title: Text("Wheel Deals"),
      ),
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
                        Navigator.pushNamed(context, Routes.HOMESCREEN);
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
