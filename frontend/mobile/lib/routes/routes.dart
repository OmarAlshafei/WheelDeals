import 'package:flutter/material.dart';
import 'package:mobile/screens/LoginScreen.dart';
import 'package:mobile/screens/CarsScreen.dart';
import 'package:mobile/screens/HomeScreen.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARSSCREEN = '/cars';
  static const String HOMESCREEN = '/home';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => LoginScreen(),
    LOGINSCREEN: (context) => LoginScreen(),
    CARSSCREEN: (context) => CarsScreen(),
    HOMESCREEN: (context) => HomeScreen(),
  };
}
