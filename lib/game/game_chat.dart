import 'package:brick_hold_em/game/message.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:brick_hold_em/globals.dart' as globals;

class GameChat extends ConsumerStatefulWidget {
  const GameChat({
    Key? key,
  }) : super(key: key);

  @override
  GameChatState createState() => GameChatState();
}

class GameChatState extends ConsumerState<GameChat> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  DatabaseReference chatRef = FirebaseDatabase.instance.ref('tables/1/chat');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _messageController = TextEditingController();

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Drawer(
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
                            if (snapshot.hasData &&
                                snapshot.data!.snapshot.value != null) {
                              List<Message> messages = [];

                              Map<dynamic, dynamic> data = snapshot.data!
                                  .snapshot.value as Map<dynamic, dynamic>;

                              data.forEach((key, value) {
                                var message = Message(
                                    uid: value['playerInfo']['uid'],
                                    position: value['position'],
                                    text: value['text'],
                                    photoURL: value['playerInfo']['photoURL'],
                                    username: value['playerInfo']['username'],
                                    timestamp:
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value['timestamp']));

                                messages.add(message);
                              });

                              messages.sort(
                                  (a, b) => a.timestamp.compareTo(b.timestamp));
                                  WidgetsBinding.instance
                                  .addPostFrameCallback((_) {
                                _scrollToBottom();
                              });

                              return ListView.builder(
                                  controller: _scrollController,
                                  //shrinkWrap: true,
                                  itemCount: messages.length,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4),
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
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              Container(
                                                constraints: const BoxConstraints(
                                                    maxWidth: 200),
                                                decoration: BoxDecoration(
                                                    color:
                                                        messages[index].uid ==
                                                                uid
                                                            ? Colors.white
                                                            : Colors.blue,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    messages[index].text,
                                                    style: TextStyle(
                                                        color: messages[index]
                                                                    .uid ==
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
                                child: Text(
                                  "No messages yet",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          })),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  hintText: "Send Message"),
                            ),
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
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        )
      ],
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void sendMessage() async {
    final username = await storage.read(key: globals.FSS_USERNAME);

    if (_messageController.text.isNotEmpty) {
      chatRef.push().set({
        'playerInfo': {
          'uid': uid,
          'username': username,
          'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
        },
        'position': ref.read(playerPositionProvider),
        'text': _messageController.text,
        'timestamp': ServerValue.timestamp
      });

      _messageController.clear();
    }
  }
}
