import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:brick_hold_em/game/game_cards.dart';
import 'package:brick_hold_em/game/game_players.dart';

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
  @override
  void initState() {
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
          // IgnorePointer(
          //   child: Hero(
          //     tag: 'videoPlayer',
          //     child: widget.controller.value.isInitialized
          //         ? VideoPlayer(widget.controller)
          //         : const SizedBox.shrink(),
          //   ),
          // ),
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
}
