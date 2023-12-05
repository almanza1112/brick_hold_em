import 'package:brick_hold_em/game/message.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameChat extends ConsumerStatefulWidget {
  const GameChat({
    Key? key,
  }) : super(key: key);

  @override
  GameChatState createState() => GameChatState();
}

class GameChatState extends ConsumerState<GameChat> {
  DatabaseReference chatRef = FirebaseDatabase.instance.ref('tables/1/chat');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _messageController = TextEditingController();

  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(top: 4, bottom: 16),
                title: const Text(
                  "CHAT",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: chatRef.onValue,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> data = snapshot
                              .data!.snapshot.value as Map<dynamic, dynamic>;

                          data.forEach((key, value) {
                            String messengerUid = value['uid'];
                            int position = value['position'];
                            String text = value['text'];

                            final otherPlayersList =
                                ref.read(otherPlayersInformationProvider);

                            late String messgengerPlayerPhotoUrl;
                            late String messgengerPlayerUsername;
                            if (messengerUid == uid) {
                              messgengerPlayerPhotoUrl =
                                  FirebaseAuth.instance.currentUser!.photoURL!;
                              messgengerPlayerUsername = FirebaseAuth
                                  .instance.currentUser!.displayName!;
                            } else {
                              for (var player in otherPlayersList) {
                                if (messengerUid == player.uid) {
                                  messgengerPlayerPhotoUrl = player.photoURL;
                                  messgengerPlayerUsername = player.username;
                                }
                              }
                            }

                            var message = Message(
                                uid: messengerUid,
                                position: position,
                                text: text,
                                photoURL: messgengerPlayerPhotoUrl,
                                username: messgengerPlayerUsername);
                            messages.add(message);
                          });

                          return ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        messages[index].uid == uid
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: <Widget>[
                                      if (messages[index].uid != uid)
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              messages[index].photoURL!),
                                          radius: 20,
                                        ),
                                      Column(
                                        crossAxisAlignment:
                                            messages[index].uid == uid
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          if (messages[index].uid != uid)
                                            Text(
                                              messages[index].username!,
                                              style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    messages[index].uid == uid
                                                        ? Colors.white
                                                        : Colors.blue,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6,
                                                  right: 6,
                                                  top: 2,
                                                  bottom: 2),
                                              child: Text(
                                                messages[index].text,
                                                style: TextStyle(
                                                    color:
                                                        messages[index].uid ==
                                                                uid
                                                            ? Colors.black
                                                            : Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }));
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }))),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.zero)),
                          hintText: "Send Message"),
                    ),
                  ),
                  IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.green,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    chatRef.push().set({
      'uid': uid,
      'position': ref.read(playerPositionProvider),
      'text': _messageController.text,
      'timestamp': ServerValue.timestamp
    });

    _messageController.clear();
  }
}
