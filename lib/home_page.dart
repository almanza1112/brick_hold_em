import 'package:brick_hold_em/game/game_main.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'settings_page.dart';
import 'game/game_table.dart';
import 'friends_page.dart';
import 'ads_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FriendsPage()));
                      }, 
                      icon: const Icon(Icons.group)),
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
                                var chips = data!["chips"];
                                return Text(
                                  "$chips chips",
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
                              } else {
                                return const Text('i suck');
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdsPage()));
                                },
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
                        builder: (context) => GameMain()));
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
