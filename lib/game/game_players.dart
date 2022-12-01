

import 'package:brick_hold_em/game/game_table.dart';
import 'package:flutter/material.dart';

class GamePlayers extends StatefulWidget {
  const GamePlayers({
    Key? key,
    required this.game,
  }) : super(key: key);

  final GameTable game; 

  _GamePlayersState createState() => _GamePlayersState();
}

class _GamePlayersState extends State<GamePlayers> {

  double imageRadius = 35;
  TextStyle chipsText = const TextStyle(fontSize: 12, color: Colors.white);

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 650,
            height: 300,
            //color: Colors.white,
            child: Stack(
              children: [
                // Player 1 is the user so going counter clockwise will be Player 2,3, etc
                // Player 2
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/TESTING.jpg'),
                            radius: imageRadius,
                          ),
                        ],
                      ),
                      Text("1,000", style: chipsText)
                    ],
                  ),
                ),
                // Player 3
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/TESTING.jpg'),
                        radius: imageRadius,
                      ),
                      Text("1,000", style: chipsText,)
                    ],
                  ),
                ),
                // Player 4
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/TESTING.jpg'),
                        radius: imageRadius,
                      ),
                      Text(
                        "1,000",
                        style: chipsText,
                      )
                    ],
                  ),
                ),
                 // Player 5
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/TESTING.jpg'),
                        radius: imageRadius,
                      ),
                      Text(
                        "1,000",
                        style: chipsText,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
    
  }
}
