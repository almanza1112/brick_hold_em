import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import 'package:brick_hold_em/game/game_cards.dart';
import 'package:brick_hold_em/game/game_players.dart';
import 'package:brick_hold_em/globals.dart' as globals;

import 'game_sidemenu.dart';
import 'game_turn_timer.dart';

class GamePage extends StatefulWidget {
  final VideoPlayerController controller;
  const GamePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    addUserToTable();
    Future.delayed(const Duration(seconds: 2)).then((val) {
     widget.controller.dispose();
    });
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Stack(
        children: [
          const GameCards(),
          const GameTurnTimer(),
          const GamePlayers(),
          GameSideMenu(),
          IgnorePointer(
            child: Hero(
              tag: 'videoPlayer',
              child: VideoPlayer(widget.controller),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  addUserToTable() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final username = await storage.read(key: globals.FSS_USERNAME);

    var body = {
      'uid': uid,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
      'username': username,
    };
    http.Response response = await http
        .post(Uri.parse("${globals.END_POINT}/table/join"), body: body);

    //Map data = jsonDecode(response.body);

    print("adduserToTable: ${response.body}");
  }
}
