import 'package:flutter/material.dart';

class GameChat extends StatefulWidget {
  const GameChat({
    Key? key,
  }) : super(key: key);


  _GameChatState createState() => _GameChatState();
}

class _GameChatState extends State<GameChat>{

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
                child: ListView(
                  children: [
                  ],
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.zero)
                          ),
                          hintText: "Send Message"),
                    ),
                  ),
                  IconButton(onPressed: sendMessage, icon: Icon(Icons.send, color: Colors.green,))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  void sendMessage() {

  }
}