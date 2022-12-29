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
        backgroundColor: Colors.orangeAccent,
        body: SafeArea(
            child: Material(
          color: Colors.orangeAccent,
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Image(
                    image: AssetImage('assets/images/AlmanzaTechLogo.png')),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: leftMenu(),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: rightMenu(),
              )
            ],
          ),
        )));
  }

  Widget leftMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(0, 4))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: IconButton(
                      onPressed: () {},
                      color: Colors.white,
                      icon: const Icon(Icons.local_movies_outlined)),
                ))),
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
                decoration: const BoxDecoration(color: Colors.teal, boxShadow: [
                  BoxShadow(
                      color: Colors.black, blurRadius: 8, offset: Offset(0, 4))
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: IconButton(
                      onPressed: () {},
                      color: Colors.white,
                      icon: const Icon(Icons.shopping_bag)),
                ))),
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
                decoration: const BoxDecoration(color: Colors.blue, boxShadow: [
                  BoxShadow(
                      color: Colors.black, blurRadius: 8, offset: Offset(0, 4))
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: IconButton(
                      onPressed: () {},
                      color: Colors.white,
                      icon: const Icon(Icons.group)),
                )))
      ],
    );
  }

  Widget rightMenu() {
    const double height = 90;
    const double width = 180;
    const double fontSize = 16;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
            splashColor: Colors.black,
            onTap: () {},
            child: Ink(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ]),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "COMPETITVE",
                  style: TextStyle(fontSize: fontSize, color: Colors.white, fontStyle: FontStyle.italic),
                ),
              ),
            )),
        // FRIENDLY BUTTON
        InkWell(
            splashColor: Colors.black,
            onTap: () {},
            child: Ink(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ]),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "FRIENDLY",
                  style: TextStyle(fontSize: fontSize, color: Colors.white, fontStyle: FontStyle.italic),
                ),
              ),
            )),
        // HOW TO PLAY button
        InkWell(
            splashColor: Colors.black,
            onTap: () {},
            child: Ink(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ]),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "HOW TO PLAY",
                  style: TextStyle(fontSize: fontSize, color: Colors.white, fontStyle: FontStyle.italic),
                ),
              ),
            )),
        // SETTINGS button
        InkWell(
            splashColor: Colors.white,
            onTap: () {},
            child: Ink(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ]

              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "SETTINGS",
                  style: TextStyle(fontSize: fontSize, color: Colors.white, fontStyle: FontStyle.italic),
                ),
              ),
            )),
      ],
    );
  }

  Future<Map<String, dynamic>?> readUser() async {
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
