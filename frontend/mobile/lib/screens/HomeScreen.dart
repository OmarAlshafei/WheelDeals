import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile/routes/routes.dart';

final List<String> imgList = [
  'https://www.lensrentals.com/blog/media/2015/11/Automotive-Photography-Guide-1.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwVLDj3Q7Pmq_x5CNlPHlY4OR3RraFbZZm1Q&usqp=CAU'
];

class Cars {
  Map fetchedData = {
    "data": [
      {"id": 1, "make": "Ford", "model":"F150", "year":2020, "price":"\$13,000","type":"truck"},
      {"id": 2, "make": "Ford", "model":"Explorer", "year":2018, "price":"\$12,000","type":"SUV"},
      {"id": 3, "make": "Mazda", "model":"Mazda3", "year":2016, "price":"\$11,000","type":"sedan"},
      {"id": 4, "make": "Toyota", "model":"Camry", "year":2021, "price":"\$12,000","type":"sedan"},
    ]
  };
  List? _data;

  Cars() {
    _data = fetchedData["data"];
  }

  int getId(int index) {
    return _data![index]["id"];
  }

  String getMake(int index) {
    return _data![index]["make"];
  }

  String getModel(int index) {
    if (_data == null) return "";
    return _data![index]["model"];
  }

  int getYear(int index) {
    if (_data == null) return -1;
    return _data![index]["year"];
  }

  String getPrice(int index) {
    return _data![index]["price"];
  }

  String getType(int index) {
    return _data![index]["type"];
  }

  int getLength() {
    return _data!.length;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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

                Navigator.pushNamed(context, Routes.LOGINSCREEN);
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     title: Text('Login/Signup'),
                //   ),//AlertDialog
                // );
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

//====================================================
class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Cars _data = Cars();
  List<bool> fav = <bool>[];

  @override
  void initState() {
    super.initState();
  }

  Set<String> carList = {
    "2016\tFord\tF150\n\$10,000",
    "2018\tToyota\tCamry\n\$11,000",
    "2017\tFord\tExplorer\n\$12,000"
  };

  // Card buildCard(String car, String price) {
  //   return Card(
  //       elevation: 4.0,
  //       color: Colors.grey,
  //       child: Column(
  //         children: [
  //           ListTile(
  //             title: Text(car),
  //             subtitle: Text(price),
  //             trailing: Theme (
  //               data: ThemeData(useMaterial3: true),
  //               child: IconButton(
  //                 isSelected: favorited,
  //                 onPressed: () {
  //                   setState(() {
  //                     favorited = !favorited;
  //                   });
  //                 },
  //                 icon: const Icon(Icons.favorite_outline),
  //                 selectedIcon: const Icon(Icons.favorite),
  //               )
  //             ),
  //           ),
  //           ButtonBar(
  //             children: [
  //               TextButton(
  //                 child: const Text('LEARN MORE',
  //                 style:TextStyle(color:Colors.indigo)),
  //                 onPressed: () {/* ... */},
  //               )
  //             ],
  //           )
  //         ],
  //       ));
  // }

  Widget tableRow(String str) {
    return Container(
      child: GestureDetector(

        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gesture Detected!')));
        },
        child: Container(
          height: 75,
          width: 380,
          child: Card(
            elevation: 5,
            child: Text(str),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    String favMessage="";
    return GestureDetector(
      child: Card(
          elevation: 4.0,
          color: Colors.grey,
          child: Column(
            children: [
              ListTile(
                title: Text("${_data.getYear(index)} ${_data.getMake(index)} ${_data.getModel(index)}"),
                subtitle: Text(_data.getPrice(index)),
                trailing: Theme (
                    data: ThemeData(useMaterial3: true),
                    child: IconButton(
                      isSelected: fav[index],
                      onPressed: () {
                        // if (fav[index])
                        //   favMessage="Unfavorited";
                        // else
                        //   favMessage="Favorite";
                        // AlertDialog(content:Text(favMessage));
                        setState(() {
                          fav[index] = !fav[index];
                        });
                      },
                      icon: const Icon(Icons.favorite_outline),
                      selectedIcon: const Icon(Icons.favorite),
                    )
                ),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    child: const Text('LEARN MORE',
                        style:TextStyle(color:Colors.indigo)),
                    onPressed: () {/* ... */},
                  )
                ],
              )
            ],
          )
      ),
      onTap: () => {
        const AlertDialog(
          content: Text("See more info"),
        )
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Cars data = Cars();

    // initialize favorites list to all false
    for (int i=0; i < _data.getLength(); i++) {
      fav.add(false);
    }

    return Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child:
            Column(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(),
                    items: imgList
                        .map((item) => Container(
                      child: Center(
                          child:
                          Image.network(item, fit: BoxFit.cover, width: 1000)),
                    ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 2000,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(5.5),
                      itemCount: data.getLength(),
                      itemBuilder: _itemBuilder,
                    ),
                  ),


                  // buildCard("2016 Ford F150","\$15,000"),
                  // buildCard("2021 Toyota Camry","\$12,000"),
                  // buildCard("2018 Ford Explorer","\$14,000"),
                  // buildCard("2016 Mazda Mazda3","\$10,000"),

                ]
            )
        )

    );
  }
}
