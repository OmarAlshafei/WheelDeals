import 'package:flutter/material.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/utils/Colors.dart';


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
        },
        child: Image.asset(
            'images/logo.png',
            width:70,
            height:50,
        ),
      ),
      backgroundColor: appColors.navy,
      title: Container(
          height: 35,
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                // padding: const MaterialStatePropertyAll<EdgeInsets>(
                //     EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            },
          )
      ),
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
