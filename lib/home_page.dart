import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';

import 'settings_page.dart';
import 'howtoplay_page.dart';
import 'tournament_page.dart';
import 'competitive_page.dart';
import 'profile_page.dart';
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
                          TournamentPage()),
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
          children: [profileMenu()],
        ))
      ],
    );
  }

  Widget rightMenu() {
    const double height = 100;
    const double width = 180;
    const double fontSize = 18;
    const Color fontColor = Colors.white;

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
        // COMPETITIVE button
        // Wrapping OpenContainer widget (used for animation to new page) with Container
        // widget to get use shadow on Container
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 8, offset: Offset(0, 4))
              ]),
          child: OpenContainer(
            closedBuilder: (context, openContainer) => GestureDetector(
              onTap: () => openContainer(),
              child: Container(
                  color: Colors.blue,
                  height: double.infinity,
                  width: double.infinity,
                  child: const Align(
                    alignment: Alignment.center,
                   child: Text("NO LIMIT",
                        style: TextStyle(fontSize: fontSize, color: fontColor)),
                  )),
            ),
            transitionDuration: transitionDuration,
            closedShape: closedShape,
            closedElevation: closedElevation,
            closedColor: closedColor,
            openBuilder: (context, action) => CompetitivePage(),
          ),
        ),
        // FRIENDLY BUTTON
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 8, offset: Offset(0, 4))
              ]),
          child: OpenContainer(
            closedBuilder: (context, openContainer) => GestureDetector(
              onTap: () => openContainer(),
              child: Container(
                  color: Colors.teal,
                  height: double.infinity,
                  width: double.infinity,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("TOURNAMENT",
                        style: TextStyle(fontSize: fontSize, color: fontColor)),
                  )),
            ),
            transitionDuration: transitionDuration,
            closedShape: closedShape,
            closedElevation: closedElevation,
            closedColor: closedColor,
            openBuilder: (context, action) => TournamentPage(),
          ),
        ),
        // HOW TO PLAY button
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 8, offset: Offset(0, 4))
              ]),
          child: OpenContainer(
            closedBuilder: (context, openContainer) => GestureDetector(
              onTap: () => openContainer(),
              child: Container(
                  color: Colors.red,
                  height: double.infinity,
                  width: double.infinity,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("HOW TO PLAY",
                        style: TextStyle(fontSize: fontSize, color: fontColor)),
                  )),
            ),
            transitionDuration: transitionDuration,
            closedShape: closedShape,
            closedElevation: closedElevation,
            closedColor: closedColor,
            openBuilder: (context, action) => HowToPlayPage(),
          ),
        ),
        // SETTINGS button
        Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 8, offset: Offset(0, 4))
              ]),
          child: OpenContainer(
            closedBuilder: (context, openContainer) => GestureDetector(
              onTap: () => openContainer(),
              child: Container(
                  color: Colors.black, 
                  height: double.infinity,
                  width: double.infinity,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("SETTINGS",
                        style: TextStyle(fontSize: fontSize, color: fontColor)),
                  )),
            ),
            transitionDuration: transitionDuration,
            closedShape: closedShape,
            closedElevation: closedElevation,
            closedColor: closedColor,
            openBuilder: (context, action) => SettingsPage(),
          ),
        ),
      ],
    );
  }

  Widget profileMenu() {
    const double columnPadding = 25;
    return Container(
      color: Colors.transparent,
      width: 160,
      child: OpenContainer(
        closedColor: Colors.brown.shade300,
        closedElevation: 0,
        closedBuilder: ((context, openContainer) =>  Stack(
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
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 4))
                        ]),
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
      )), 
        openBuilder: ((context, closedContainer) => ProfilePage()))
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
