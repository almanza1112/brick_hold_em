import 'package:brick_hold_em/friends/friend_requests_page.dart';
import 'package:brick_hold_em/friends/search_users_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'friend.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<Friend>> _friendsList;
  late Future<int> _friendRequestReceivedNum;

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    _friendsList = getFriends();
    _friendRequestReceivedNum = getFriendRequests();
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
        actions: <Widget>[
          IconButton(
              onPressed: navigateToSearchUsers,
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: _friendRequestReceivedNum,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error getting friend requests");
                }

                if (snapshot.hasData) {
                  var numOfFriendRequests = snapshot.data as int;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendRequestsPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 12, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$numOfFriendRequests friend requests",
                            style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
          Expanded(
            child: FutureBuilder(
                future: _friendsList,
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                        "Something went wrong. Unable to retrieve friends list.");
                  }

                  if (snapshot.hasData) {
                    var friendList = List<Friend>.from(snapshot.data as List);
                    List<Widget> friends = <Widget>[];
                    for (int i = 0; i < friendList.length; i++) {
                      friends.add(friendRow(friendList[i]));
                    }

                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: friendList.length,
                        itemBuilder: (context, index) {
                          return friends[index];
                        });
                  } else {
                    return const Text(
                        "Something went wrong. Unable to retrieve friends list.");
                  }
                })),
          ),
        ],
      ),
    );
  }

  Future<List<Friend>> getFriends() async {
    List<Friend> friendList = <Friend>[];
    final friendsRef = await db
        .collection("users")
        .doc(uid)
        .collection("friends")
        .where("status", isEqualTo: "friends")
        .get();

    List<dynamic> result = friendsRef.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < result.length; i++) {
      Friend friend = Friend(
          uid: result[i][globals.CF_KEY_UID],
          username: result[i][globals.CF_KEY_USERNAME],
          photoURL: result[i][globals.CF_KEY_PHOTOURL],
          fullName: result[i][globals.CF_KEY_FULLNAME],
          status: result[i][globals.CF_KEY_STATUS]);
      friendList.add(friend);
    }

    return friendList;
  }

  Future<int> getFriendRequests() async {
    final ref = await db
        .collection("users")
        .doc(uid)
        .collection("friends")
        .where("status", isEqualTo: "requestReceived")
        .count()
        .get();

    return ref.count;
  }

  Widget friendRow(Friend friend) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(friend.photoURL),
            radius: 20,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                friend.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
               Text(
                friend.fullName,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }

  void navigateToSearchUsers() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchUsersPage()));
  }
}
