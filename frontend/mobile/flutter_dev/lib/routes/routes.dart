import 'package:flutter/material.dart';
import 'package:flutter_dev/screens/LoginScreen.dart';
import 'package:flutter_dev/screens/CardsScreen.dart';
import 'package:flutter_dev/screens/HomeScreen.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARDSSCREEN = '/cards';
  static const String HOMESCREEN = '/home';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => HomeScreen(),
    LOGINSCREEN: (context) => LoginScreen(),
    CARDSSCREEN: (context) => CardsScreen(),
    HOMESCREEN: (context) => HomeScreen(),
  };
}
