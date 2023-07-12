import 'package:brick_hold_em/purchase_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:brick_hold_em/globals.dart' as globals;

import 'login/create_account_username_page.dart';
import 'login/new_user_info.dart';
import 'settings_page.dart';
import 'howtoplay_page.dart';
import 'tournament_page.dart';
import 'competitive_page.dart';
import 'profile_page.dart';
import 'friends/friends_page.dart';
import 'ads_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  late Future<List<String>> userInfo;
  final Duration transitionDuration = const Duration(milliseconds: 500);


  @override
  void initState() {
    super.initState();
    userInfo = getUserInfo();
    checkIfUserExists();
  }

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
              // SIGN OUT BUTTON JUST IN CASE APP ACTS WEIRD
              // ElevatedButton(onPressed: () {
              //   FirebaseAuth.instance.signOut();
              // }, child: Text("Sign out")),
              const Padding(
                padding: EdgeInsets.only(top: 100, bottom: 100),
                child: Image(
                    image: AssetImage('assets/images/BrickHoldEmLogo.png')),
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
                          PurchasePage()),
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
                    child: Text("COMPETITIVE",
                        style: TextStyle(fontSize: fontSize, color: fontColor)),
                  )),
            ),
            transitionDuration: transitionDuration,
            closedShape: closedShape,
            closedElevation: closedElevation,
            closedColor: closedColor,
            openBuilder: (context, action) => const CompetitivePage(),
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
                    child: Text("FRIENDLY",
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
            transitionDuration: transitionDuration,
            closedBuilder: ((context, openContainer) => Stack(
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
                            padding: const EdgeInsets.only(
                                top: columnPadding, bottom: 10),
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
                                  image: NetworkImage(FirebaseAuth
                                      .instance.currentUser!.photoURL!)),
                            ),
                          ),
                          FutureBuilder(
                              future: userInfo,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("error");
                                }
                                
                                if (snapshot.hasData) {
                                  List<String> userInfo =
                                      List<String>.from(snapshot.data as List);
                                  return Column(
                                    children: [
                                      Text(
                                        userInfo[0],
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: columnPadding),
                                        child: Text(
                                          "${userInfo[1]} chips",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              })
                        ],
                      ),
                    )
                  ],
                )),
            openBuilder: ((context, closedContainer) => ProfilePage())));
  }

  // Basically here to confirm the facebook user finished the sign up process
  checkIfUserExists() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(uid);
    docRef.get().then((DocumentSnapshot doc) {
      if (!doc.exists) {
        // User does not exist, proceed to create new account
        var newUserInfo = NewUserInfo(
            fullName: FirebaseAuth.instance.currentUser!.displayName,
            email: FirebaseAuth.instance.currentUser!.email,
            photoURL: FirebaseAuth.instance.currentUser!.photoURL,
            loginType: globals.LOGIN_TYPE_FACEBOOK);

        navigateToUsername(null, newUserInfo);
      }
    }, onError: (error) {
      print(error);
    });
  }

  void navigateToUsername(var credential, NewUserInfo newUserInfo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateAccountUsernamePage(
                  credential: credential,
                  newUserInfo: newUserInfo,
                )));
  }

  Future<List<String>> getUserInfo() async {
    final chips = await storage.read(key: globals.FSS_CHIPS);
    final username = await storage.read(key: globals.FSS_USERNAME);

    return [username!, chips!];
  }
}
