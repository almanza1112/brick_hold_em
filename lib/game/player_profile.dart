import 'package:brick_hold_em/game/player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlayerProfilePage extends StatefulWidget {
  final Player player;
  const PlayerProfilePage({super.key, required this.player});

  PlayerProfilePageState createState() => PlayerProfilePageState();
}

class PlayerProfilePageState extends State<PlayerProfilePage> {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late Stream<DocumentSnapshot> friendStatusStream;

  final TextStyle friendButtonTextStyle =
      TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold);
  final TextStyle addFriendButtonTextStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  final TextStyle reportButtonTextStyle =
      TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold);

  @override
  void initState() {
    friendStatusStream = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("friends")
        .doc(widget.player.uid)
        .snapshots();
    super.initState();
  }

  @override
  void dispose() {
    friendStatusStream.drain<dynamic>(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.player.photoURL),
                        radius: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                          child: Text(
                        widget.player.name!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // use whichever suits your need

                        children: [
                          Expanded(flex: 1, child: friendStatusOnButton()),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: () {
                                  reportPlayer();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[100]),
                                child: Text(
                                  'REPORT',
                                  style: reportButtonTextStyle,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ]),
    );
  }

  Widget friendStatusOnButton() {
    return StreamBuilder(
        stream: friendStatusStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error on stream");
          }

          if (snapshot.hasData) {
            try {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              final status = data['status'];
              if (status == globals.CF_VALUE_FRIENDS) {
                return ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100]),
                    child: Text(
                      "FRIENDS",
                      style: friendButtonTextStyle,
                    ));
              } else if (status == globals.CF_VALUE_REQUEST_RECEIVED) {
                return ElevatedButton(
                    onPressed: acceptFriendRequest,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: Text("ACCEPT REQUEST",
                        style: addFriendButtonTextStyle));
              } else if (status == globals.CF_VALUE_REQUEST_SENT) {
                return ElevatedButton(
                    onPressed: cancelFriendRequest,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: Text("CANCEL REQUEST",
                        style: addFriendButtonTextStyle));
              } else {
                return ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    child: const CircularProgressIndicator());
              }
            } catch (err) {
              return ElevatedButton(
                  onPressed: sendFriendRequest,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: Text(
                    "ADD FRIEND",
                    style: addFriendButtonTextStyle,
                  ));
            }
          } else {
            return const Text("no data");
          }
        });
  }

  void sendFriendRequest() async {
    // Create a batch write so you can update both documents of users at the same time.
    // Add to array.
    final batch = db.batch();

    // Get player's username from FSS
    const storage = FlutterSecureStorage();
    final username = await storage.read(key: globals.FSS_USERNAME);
    final fullName = FirebaseAuth.instance.currentUser!.displayName;

    final userRef = db
        .collection(globals.CF_COLLECTION_USERS)
        .doc(uid)
        .collection(globals.CF_SUBCOLLECTION_FRIENDS)
        .doc(widget.player.uid);
    var userUpdate = <String, dynamic>{
      globals.CF_KEY_USERNAME: widget.player.username,
      globals.CF_KEY_FULLNAME: widget.player.fullName,
      globals.CF_KEY_UID: widget.player.uid,
      globals.CF_KEY_PHOTOURL: widget.player.photoURL,
      globals.CF_KEY_STATUS: globals.CF_VALUE_REQUEST_SENT
    };
    batch.set(userRef, userUpdate, SetOptions(merge: true));

    final otherPlayerRef = db
        .collection(globals.CF_COLLECTION_USERS)
        .doc(widget.player.uid)
        .collection(globals.CF_SUBCOLLECTION_FRIENDS)
        .doc(uid);
    var otherPlayerUpdate = <String, dynamic>{
      globals.CF_KEY_USERNAME: username,
      globals.CF_KEY_FULLNAME: fullName,
      globals.CF_KEY_UID: uid,
      globals.CF_KEY_PHOTOURL: FirebaseAuth.instance.currentUser!.photoURL,
      globals.CF_KEY_STATUS: globals.CF_VALUE_REQUEST_RECEIVED
    };
    batch.set(otherPlayerRef, otherPlayerUpdate, SetOptions(merge: true));

    batch.commit().then((value) {}).catchError((err) {});
  }

  void cancelFriendRequest() {
    final batch = db.batch();
    final userRef = db
        .collection(globals.CF_COLLECTION_USERS)
        .doc(uid)
        .collection(globals.CF_SUBCOLLECTION_FRIENDS)
        .doc(widget.player.uid);

    batch.delete(userRef);

    final otherPlayerRef = db
        .collection(globals.CF_COLLECTION_USERS)
        .doc(widget.player.uid)
        .collection(globals.CF_SUBCOLLECTION_FRIENDS)
        .doc(uid);

    batch.delete(otherPlayerRef);

    batch.commit().then((value) {
      print("batch success");
    }).catchError((err) {
      print(err);
    });
  }

  void acceptFriendRequest() async {
    final batch = db.batch();
    final userRef = db
        .collection(globals.CF_COLLECTION_USERS)
        .doc(uid)
        .collection(globals.CF_SUBCOLLECTION_FRIENDS)
        .doc(widget.player.uid);
    var userUpdate = <String, dynamic>{
      globals.CF_KEY_STATUS: globals.CF_VALUE_FRIENDS
    };

    batch.set(userRef, userUpdate, SetOptions(merge: true));

    final otherPlayerRef = db
        .collection(globals.CF_COLLECTION_USERS)
        .doc(widget.player.uid)
        .collection(globals.CF_SUBCOLLECTION_FRIENDS)
        .doc(uid);
    var otherPlayerUpdate = <String, dynamic>{
      globals.CF_KEY_STATUS: globals.CF_VALUE_FRIENDS
    };
    batch.set(otherPlayerRef, otherPlayerUpdate, SetOptions(merge: true));

    batch.commit().then((value) {
      print("batch success");
    }).catchError((err) {
      print(err);
    });
  }

  void manageFriendship() {}

  void reportPlayer() {}
}
