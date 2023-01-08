import 'package:brick_hold_em/game/game_main.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';

import 'settings_page.dart';
import 'howtoplay_page.dart';
import 'friendly_page.dart';
import 'competitive_page.dart';
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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 100, bottom: 100),
                child: Image(
                    image: AssetImage('assets/images/AlmanzaTechLogo.png')),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: leftMenu(),
                      )
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: rightMenu(),
                      )
                    )
                  ],
                ) 
              )
            ],
          ),
        )));
  }

  Widget leftMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
    const double height = 100;
    const double width = 180;
    const double fontSize = 20;

    const Duration transitionDuration = Duration(milliseconds: 750);
    const Color closedColor = Colors.transparent;
    const double closedElevation = 0; 
    const RoundedRectangleBorder closedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10)
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        OpenContainer(
          closedBuilder: (context, openContainer) => InkWell(
                splashColor: Colors.black,
                onTap: () {
                  openContainer();
                },
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
                      style: TextStyle(fontSize: fontSize, color: Colors.white),
                    ),
                  ),
                )), 
          transitionDuration: transitionDuration,
          closedShape: closedShape,
          closedElevation: closedElevation,
          closedColor: closedColor,
          openBuilder: (context, closedBuilder) => CompetitivePage()),
        // FRIENDLY BUTTON
        OpenContainer(
          closedBuilder: ((context, openContainer) => InkWell(
            splashColor: Colors.black,
            onTap: () {
              openContainer();
            },
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
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              ),
            )
            )
            ), 
          transitionDuration: transitionDuration,
          closedShape: closedShape,
          closedElevation: closedElevation,
          closedColor: closedColor,
          openBuilder: (context, closedContainer) => FriendlyPage()),
        // HOW TO PLAY button
        OpenContainer(
          closedBuilder: (context, openContainer) {
            return InkWell(
            splashColor: Colors.black,
            onTap: () {
              openContainer();
            },
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
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              ),
            )
          );
          }, 
          transitionDuration: transitionDuration,
          closedShape: closedShape,
          closedElevation: closedElevation,
          closedColor: closedColor,
          openBuilder: (context, closedContainer) => HowToPlayPage()
        ),
        // SETTINGS button
        OpenContainer(
          openBuilder: (context, closedContainer) => SettingsPage(), 
          transitionDuration: transitionDuration,
          closedShape: closedShape,
          closedElevation: closedElevation,
          closedColor: closedColor,
          closedBuilder: (context, openContainer) { 
            return InkWell(
              splashColor: Colors.white,
              onTap: () {
                openContainer();
              },
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
                    style: TextStyle(fontSize: fontSize, color: Colors.white),
                  ),
                ),
              )
            );
           },

        ),
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
