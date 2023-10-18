import 'package:flutter/material.dart';

class CardsScreen extends StatefulWidget {
  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("Wheel Deals"),
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
        width: 400,
        margin: EdgeInsets.only(left:60.0),
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
                          labelText: 'Search',
                          hintText: 'Search for a Card'
                      ),
                    ),
                  ),

                  ElevatedButton(
                      child: Text('Search',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                      ),
                      onPressed: ()
                      {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Search'),
                          ),//AlertDialog
                        );
                      },

                  )

                ]
            ),
            Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child:
                    TextField (
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Add',
                          hintText: 'Add a Card'
                      ),
                    ),
                  ),

                  ElevatedButton(
                      child: Text('Add',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                      ),
                      onPressed: ()
                      {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Add'),
                          ),//AlertDialog
                        );
                      },

                  )

                ]
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                    child: Text('Logout',style: TextStyle(fontSize: 14 ,color:Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                    ),
                    onPressed: ()
                    {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Logout'),
                        ),//AlertDialog
                      );
                    },

                )
              ],
            )
          ],
        )
    );
  }

}
