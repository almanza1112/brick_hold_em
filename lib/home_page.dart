import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'settings_page.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({'firstName': 'Bryant', 'lastName': 'Almanza', 'age': '29'})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  var docId = '62XgoUPzHzUHtedwibyL';
  
  readData(){
    return FirebaseFirestore.instance
      .collection('users')
      .doc(docId)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
        if(documentSnapshot.exists) {
          print("document does exist! yayy!!");
        } else {
          print("youre wack!");
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.brown,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.group)),
                )),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text('1000 chips'))),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.local_movies)),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingsPage()));
                                },
                                icon: const Icon(Icons.settings))
                          ],
                        ))),
              ],
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameWidget(game: GamePage())));
              },
              padding: const EdgeInsets.all(16.0),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Start Playing",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            /* TEST BUTTON TODO: remove this eventaully */
            MaterialButton(
              onPressed: () {
                //addUser();
                //print(FirebaseAuth.instance.currentUser!.uid);
                readData();
              },
              color: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Test Button",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
