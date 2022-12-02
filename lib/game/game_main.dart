

import 'package:brick_hold_em/game/game_chat.dart';
import 'package:brick_hold_em/game/game_players.dart';
import 'package:brick_hold_em/game/game_sidemenu.dart';
import 'package:brick_hold_em/game/game_table.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
          GamePlayers(game: game),
          GameSideMenu(game: game),
          //GameChat(game: game)

        ],
      )
    );
  }
}