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
  
  FirebaseFirestore db = FirebaseFirestore.instance;

  var chips;

  _HomePageState() {
    //getChips();
  }

  getChips() {
    var docRef =  db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.get().then(
      (DocumentSnapshot doc){
        final data = doc.data() as Map<String, dynamic>;
        chips = data["chips"];
        print(chips);
        return chips;
      },
      onError: (e) {
        print("Error getting document: $e");
        return "nothing";
      },
    );
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
                        child: FutureBuilder<Map<String, dynamic>?>(
                          future: readUser(),
                          builder: (context, snapshot) {
                            /** TODO need to clean this up */
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                int chips = data!["chips"];
                                return Text("$chips chips");
                              } else {
                                return Text('i suck');
                              }
                          },
                        ))),
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
                getChips();
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

  Future<Map<String , dynamic>?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      /** TODO: need to clean this up */
      return {"chips": '20'};
    }
  }


}
