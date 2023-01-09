import 'package:flutter/material.dart';



class FriendsPage extends StatefulWidget {
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('FRIENDS'),
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 64.0, top: 16.0),
        child: Column(
          children: <Widget>[
             Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mario G",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Steve M",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Major League",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}