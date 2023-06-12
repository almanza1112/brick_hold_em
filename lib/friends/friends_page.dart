import 'package:brick_hold_em/friends/friend_requests_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'friend.dart';

class FriendsPage extends StatefulWidget {
  _FriendsPageState createState() => _FriendsPageState();
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
              onPressed: () {},
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
                       Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FriendRequestsPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
                      child: Row(
                        children: [
                          Text("$numOfFriendRequests friend requests"),
                          const Expanded(child: SizedBox()),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white,)
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
                  print("no");
                  if (snapshot.hasError) {
                    return const Text(
                        "Something went wrong. Unable to retrieve cards.");
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
                        "Something went wrong. Unable to retrieve cards.");
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
          username: result[i][globals.CF_KEY_USERNAME],
          photoURL: result[i][globals.CF_KEY_PHOTOURL],
          status: result[i][globals.CF_KEY_STATUS]);
      friendList.add(friend);
    }

    print("object");
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
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(friend.photoURL),
            radius: 20,
          ),
          SizedBox(
            width: 12,
          ),
          Text(friend.username)
        ],
      ),
    );
  }

  test() async {
    // Searches all subcollections that are named Friends in every document and
    // returns those documents. Then it updates those documents using forEach
    final ref = await db
        .collectionGroup("friends")
        .where("status", isEqualTo: "requestRecieved")
        .get();

    List<dynamic> result = ref.docs.map((doc) => doc.data()).toList();

    print(result[0]['status']);

    // ref.docs.forEach((element) {
    //   element.reference.update({"status": "requestSent"});
    // });
  }
}
