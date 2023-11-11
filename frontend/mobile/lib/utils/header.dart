import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/Colors.dart';
import 'package:mobile/utils/Cars.dart';
import 'package:mobile/utils/currentUser.dart' as currentUser;




class Header extends StatefulWidget implements PreferredSizeWidget{
  @override
  _HeaderState createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.HOMESCREEN);
          // if (currentUser.loggedIn) {
          //   Navigator.pushNamed(context, Routes.HOMESCREEN);
          // }
        },
        child: Image.asset(
            'images/logo.png',
            width:150,
            height:100,
            fit:BoxFit.fill
        ),
      ),
      title: Text(
        "Wheel Deals",
        style: TextStyle(color: appColors.white, fontSize: 24),
      ),
      backgroundColor: appColors.navy,

      // actions: [
      //   Drawer(
      //       child: Column(
      //         children: [
      //           const SizedBox(
      //             height: 110, // To change the height of DrawerHeader
      //             width: double.infinity, // To Change the width of DrawerHeader
      //             child: DrawerHeader(
      //               decoration: BoxDecoration(color: appColors.gold),
      //               child: Text('Menu',
      //                 style: TextStyle(color: Colors.black),
      //               ),
      //             ),
      //           ),
      //           ListTile(
      //             title: const Text('Login/Signup'),
      //             onTap: () {
      //
      //               Navigator.pushNamed(context, Routes.LOGINSCREEN);
      //               // showDialog(
      //               //   context: context,
      //               //   builder: (context) => AlertDialog(
      //               //     title: Text('Login/Signup'),
      //               //   ),//AlertDialog
      //               // );
      //             },
      //           ),
      //           ListTile(
      //             title: const Text('Favorites'),
      //             onTap: () {
      //               showDialog(
      //                 context: context,
      //                 builder: (context) => AlertDialog(
      //                   title: Text('Favorites'),
      //                 ),//AlertDialog
      //               );
      //             },
      //           ),
      //           ListTile(
      //             title: const Text('Account'),
      //             onTap: () {
      //               showDialog(
      //                 context: context,
      //                 builder: (context) => AlertDialog(
      //                   title: Text('Account'),
      //                 ),//AlertDialog
      //               );
      //             },
      //           ),
      //           ListTile(
      //             title: const Text('Logout'),
      //             onTap: () {
      //               showDialog(
      //                 context: context,
      //                 builder: (context) => AlertDialog(
      //                   title: Text('Logout'),
      //                 ),//AlertDialog
      //               );
      //             },
      //           ),
      //         ],
      //       )
      //   ),
      // ]
    );
  }
}
