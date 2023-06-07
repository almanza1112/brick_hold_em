import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'friend.dart';

class FriendsPage extends StatefulWidget {
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<Friend>> friendsList;

  @override
  void initState() {
    getFriends();
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
        body: SafeArea(child: Text("data")));
  }

  //Future<List<Friend>>
  getFriends() async {
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final friendsRef =
        await db.collection("users").doc(uid).collection("friends").get();

    List<dynamic> result = friendsRef.docs.map((doc) => doc.data()).toList();

    print(result);
  }

  test() async {
    // Searches all subcollections that are named Friends in every document and 
    // returns those documents. Then it updates those documents using forEach 
    final db = FirebaseFirestore.instance;
    final ref = await db.collectionGroup("friends").where("status", isEqualTo: "requestSent").get();

      List<dynamic> result = ref.docs.map((doc) => doc.data()).toList();
      print(result);

      ref.docs.forEach((element) { 
         element.reference.update({"status" : "requestSent"});
       });

  }
}
