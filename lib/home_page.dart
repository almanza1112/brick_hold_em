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
        backgroundColor: Colors.brown.shade300,
        body: SafeArea(
            child: Material(
          color: Colors.brown.shade300,
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
                  )),
                  Expanded(
                      child: Align(
                    alignment: Alignment.topRight,
                    child: rightMenu(),
                  ))
                ],
              ))
            ],
          ),
        )));
  }

  Widget leftMenu() {
    const Duration transitionDuration = Duration(milliseconds: 750);
    const Color closedColor = Colors.transparent;
    const double closedElevation = 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: OpenContainer(
                      closedBuilder: (context, openContainer) => IconButton(
                          onPressed: () {
                            openContainer();
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.local_movies_outlined)),
                      transitionDuration: transitionDuration,
                      closedColor: closedColor,
                      closedElevation: closedElevation,
                      openBuilder: (context, closedContainer) => AdsPage()),
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
                  child: OpenContainer(
                      closedBuilder: (context, openContainer) => IconButton(
                          onPressed: () {
                            openContainer();
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.shopping_bag)),
                      transitionDuration: transitionDuration,
                      closedColor: closedColor,
                      closedElevation: closedElevation,
                      openBuilder: (context, closedContainer) =>
                          FriendlyPage()),
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
                  child: OpenContainer(
                      closedBuilder: (context, openContainer) => IconButton(
                          onPressed: () {
                            openContainer();
                          },
                          color: Colors.white,
                          icon: const Icon(Icons.group)),
                      transitionDuration: transitionDuration,
                      closedColor: closedColor,
                      closedElevation: closedElevation,
                      openBuilder: (context, closedContainer) => FriendsPage()),
                ))),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              profileMenu()
            ],
          ))
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
          topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
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
                ))),
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
                        style:
                            TextStyle(fontSize: fontSize, color: Colors.white),
                      ),
                    ),
                  ));
            },
            transitionDuration: transitionDuration,
            closedShape: closedShape,
            closedElevation: closedElevation,
            closedColor: closedColor,
            openBuilder: (context, closedContainer) => HowToPlayPage()),
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
                      "SETTINGS",
                      style: TextStyle(fontSize: fontSize, color: Colors.white),
                    ),
                  ),
                ));
          },
        ),
      ],
    );
  }

  Widget profileMenu() {
    const double columnPadding = 25;
    return Container(
      color: Colors.transparent,
      width: 160,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              right: 20,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        )),
              )),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: columnPadding, bottom: 10),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            FirebaseAuth.instance.currentUser!.photoURL!)),
                  ),
                ),
                // Text(
                //   FirebaseAuth.instance.currentUser!.displayName!,
                //   style: const TextStyle(fontSize: 18, color: Colors.white),
                // ),
                FutureBuilder<Map<String, dynamic>?>(
                  future: readUser(),
                  builder: (context, snapshot) {
                    /** TODO need to clean this up */
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      var chips = data!["chips"];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: columnPadding),
                        child: Text(
                          "$chips chips",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      );
                    } else {
                      return const Text('i suck');
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
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
