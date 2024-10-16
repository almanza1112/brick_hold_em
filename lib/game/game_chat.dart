import 'package:brick_hold_em/game/message.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:brick_hold_em/globals.dart' as globals;

class GameChat extends ConsumerStatefulWidget {
  const GameChat({Key? key}) : super(key: key);

  @override
  GameChatState createState() => GameChatState();
}

class GameChatState extends ConsumerState<GameChat> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final DatabaseReference chatRef =
      FirebaseDatabase.instance.ref('tables/1/chat');
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                        onPressed: () async { 
                          Navigator.pop(context); // Pop the chat widget after keyboard is hidden
                        },
                        icon: const Icon(Icons.close, color: Colors.white54),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream: chatRef.onValue,
                          builder: (context, snapshot) {
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

                              // Ensure that we are scrolled to the bottom without animation
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_scrollController.hasClients) {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent +10);
                                }
                              });

                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final isMe = messages[index].uid == uid;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: isMe
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: <Widget>[
                                        if (!isMe)
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                messages[index].photoURL!),
                                            radius: 16,
                                          ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: isMe
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            if (!isMe)
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
                                                color: isMe
                                                    ? Colors.white
                                                    : Colors.blue,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  messages[index].text,
                                                  style: TextStyle(
                                                      color: isMe
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
                                },
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  "No messages yet",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          }),
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
                              onSubmitted: (_) =>
                                  sendMessage(), // Send message on "Enter"
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: sendMessage,
                          icon: const Icon(Icons.send, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).viewInsets.bottom,
        ),
      ],
    );
  }

  void sendMessage() async {
    final username = await storage.read(key: globals.FSS_USERNAME);
    final messageText = _messageController.text.trim();

    if (messageText.isNotEmpty) {
      chatRef.push().set({
        'playerInfo': {
          'uid': uid,
          'username': username,
          'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
        },
        'position': ref.read(playerPositionProvider),
        'text': messageText,
        'timestamp': ServerValue.timestamp,
      });
      _messageController.clear();
    }
  }
}
