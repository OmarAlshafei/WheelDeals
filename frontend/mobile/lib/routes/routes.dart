//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:mobile/screens/AccountScreen.dart';
import 'package:mobile/screens/ChangePassScreen.dart';
import 'package:mobile/screens/LoginScreen.dart';
import 'package:mobile/screens/CarsScreen.dart';
import 'package:mobile/screens/HomeScreen.dart';
import 'package:mobile/screens/PasswordVerifyScreen.dart';
import 'package:mobile/screens/PasswordVerifyScreen2.dart';
import 'package:mobile/screens/RegisterScreen.dart';
import 'package:mobile/screens/FavScreen.dart';
import 'package:mobile/screens/VerificationScreen.dart';
import 'package:mobile/screens/editAccountScreen.dart';


class Routes {
  static const String LOGINSCREEN = '/login';
  static const String CARSSCREEN = '/cars';
  static const String HOMESCREEN = '/home';
  static const String REGISTERSCREEN = '/register';
  static const String ACCOUNTSCREEN = '/account';
  static const String EDITACCOUNTSCREEN = '/editAccount';
  static const String FAVSCREEN = '/fav';
  static const String VERIFYSCREEN = '/verify';
  static const String PASSVERIFYSCREEN = '/passVerify';
  static const String PASSVERIFYSCREEN2 = '/passVerify2';
  static const String CHANGEPASSSCREEN = '/changePass';

  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
    '/': (context) => LoginScreen(),
    LOGINSCREEN: (context) => LoginScreen(),
    CARSSCREEN: (context) => CarsScreen(),
    HOMESCREEN: (context) => HomeScreen(),
    REGISTERSCREEN: (context) => RegisterScreen(),
    ACCOUNTSCREEN: (context) => AccountScreen(),
    FAVSCREEN: (context) => FavScreen(),
    EDITACCOUNTSCREEN: (context) => EditAccountScreen(),
    VERIFYSCREEN: (context) => VerificationScreen(),
    PASSVERIFYSCREEN: (context) => PasswordVerifyScreen(),
    PASSVERIFYSCREEN2: (context) => PasswordVerifyScreen2(),
    CHANGEPASSSCREEN: (context) => ChangePassScreen(),
  };
}
