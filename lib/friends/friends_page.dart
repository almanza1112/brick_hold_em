import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'friend.dart';

class FriendsPage extends StatefulWidget {
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<Friend>> friendsList;

  @override
  void initState() {
    friendsList = getFriends();
    super.initState();
  }

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
      body: FutureBuilder<List<Friend>>(
          future: friendsList,
          builder: (context, snapshot) {
                          print("no");

            if (snapshot.hasError) {
              return const Text(
                  "Something went wrong. Unable to retrieve cards.");
            }
            if (snapshot.hasData) {
              //var friendList = List<Friend>.from(snapshot.data as List);
              //print(friendList.length);
              return Text("hi");
            } else {
              return const Text(
                  "Something went wrong. Unable to retrieve cards.");
            }
          }),
    );
  }

  Future<List<Friend>> getFriends() async {
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    List<Friend> friendList = <Friend>[];
    final friendsRef =
        await db.collection("users").doc(uid).collection("friends").get();

    List<dynamic> result = friendsRef.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < result.length; i++) {
      Friend friend = Friend(
          username: result[i][globals.CF_KEY_USERNAME],
          photoURL: result[i][globals.CF_KEY_PHOTOURL],
          status: result[i][globals.CF_KEY_STATUS]);
      friendList.add(friend);
    }
    print("object");
    return friendList;
  }

  test() async {
    // Searches all subcollections that are named Friends in every document and
    // returns those documents. Then it updates those documents using forEach
    final db = FirebaseFirestore.instance;
    final ref = await db
        .collectionGroup("friends")
        .where("status", isEqualTo: "requestSent")
        .get();

    List<dynamic> result = ref.docs.map((doc) => doc.data()).toList();

    print(result[0]['status']);

    ref.docs.forEach((element) {
      element.reference.update({"status": "requestSent"});
    });
  }
}
