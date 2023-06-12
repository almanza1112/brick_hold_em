import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;

import 'friend.dart';

class FriendRequestsPage extends StatefulWidget {
  FriendRequestsPageState createState() => FriendRequestsPageState();
}

class FriendRequestsPageState extends State<FriendRequestsPage> {
  late Future<List<Friend>> _friendRequestsList;
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    _friendRequestsList = getFriendRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('FRIENDS REQUESTS'),
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _friendRequestsList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error retrieving friend requests");
          }

          if (snapshot.hasData) {
            var friendList = List<Friend>.from(snapshot.data as List);
            List<Widget> friends = <Widget>[];
            for (int i = 0; i < friendList.length; i++) {
              friends.add(friendRequestRow(friendList[i]));
            }

            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: friendList.length,
                itemBuilder: (context, index) {
                  return friends[index];
                });
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<List<Friend>> getFriendRequests() async {
    List<Friend> friendList = <Friend>[];

    final ref = await db
        .collection("users")
        .doc(uid)
        .collection("friends")
        .where("status", isEqualTo: "requestReceived")
        .get();

    List<dynamic> result = ref.docs.map((doc) => doc.data()).toList();
    for (int i = 0; i < result.length; i++) {
      Friend friend = Friend(
          username: result[i][globals.CF_KEY_USERNAME],
          photoURL: result[i][globals.CF_KEY_PHOTOURL],
          status: result[i][globals.CF_KEY_STATUS]);
      friendList.add(friend);
    }
    return friendList;
  }

  Widget friendRequestRow(Friend friend) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(friend.photoURL),
            radius: 20,
          ),
          Text(friend.username),
          Expanded(child: Container()),
          ElevatedButton(
              onPressed: () => acceptFriendRequest(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                "ACCEPT",
                style: TextStyle(fontSize: 10, color: Colors.white),
              )),
          const SizedBox(
            width: 4,
          ),
          ElevatedButton(
              onPressed: () => rejectFriendRequest(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                "REJECT",
                style: TextStyle(fontSize: 10, color: Colors.white),
              ))
        ],
      ),
    );
  }

  void acceptFriendRequest() {

  }

  void rejectFriendRequest() {

  }
}
