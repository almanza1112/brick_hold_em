

import 'package:brick_hold_em/game/game_sidemenu.dart';
import 'package:brick_hold_em/game/game_table.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_table.dart';

class GameMain extends StatefulWidget {
  _GameMainState createState() => _GameMainState();
}

class _GameMainState extends State<GameMain> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    var game = GameTable();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(game: game),
          GameSideMenu(game: game)

        ],
      )
    );
  }
}