import 'package:brick_hold_em/game/player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GamePlayers extends StatefulWidget {
  const GamePlayers({
    Key? key,
  }) : super(key: key);

  @override
  _GamePlayersState createState() => _GamePlayersState();
}

class _GamePlayersState extends State<GamePlayers>
    with TickerProviderStateMixin {
  double imageRadius = 30;
  TextStyle chipsText = const TextStyle(fontSize: 10, color: Colors.white);
  TextStyle playerNameStyle =
      const TextStyle(fontSize: 12, color: Colors.deepOrangeAccent);

  DatabaseReference playersRef =
      FirebaseDatabase.instance.ref('tables/1/players');

  var uid = FirebaseAuth.instance.currentUser!.uid;
  bool isPlayersTurn = false;

  late AnimationController controller;
  late Animation<Color?> colorTween;

  @override
  Widget build(BuildContext context) {
    print("game_players called");
    return Stack(
      children: [
        StreamBuilder(
            stream: playersRef.onValue,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                // TODO: apply error logic, maybe back out of game?
              }

              if (snapshot.hasData) {
                final map = Map<String, dynamic>.from(
                    (snapshot.data!).snapshot.value as Map);

                List<String> playerUids = [];
                List<Player> players = <Player>[];
                for (var element in map.keys) {
                  // add the players that are not you
                  if (element != uid) {
                    playerUids.add(element);
                  }
                }

                for (int i = 0; i < playerUids.length; i++) {
                  Player player = Player(
                      uid: playerUids[i],
                      name: map[playerUids[i]]['name'],
                      cardCount: map[playerUids[i]]['cardCount'],
                      //chips: map[playerUids[i]]['chips'],
                      photoUrl: map[playerUids[i]]['photoURL']);

                  players.add(player);
                }

                for (int i = players.length; i <= 5; i++) {
                  Player player = Player(name: "", photoUrl: "", cardCount: 0);
                  players.add(player);
                }

                return Center(
                  child: SizedBox(
                    height: 450,
                    child: Stack(
                      children: [
                        // Player 1 is the user so going counter clockwise will be Player 2,3, etc
                        // Player 2
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: player(players[0]),
                        ),
                        // Player 3
                        Positioned(
                          top: 130,
                          right: 0,
                          child: player(players[1]),
                        ),
                        // Player 4
                        Positioned(
                            top: 130, left: 0, child: player(players[2])),
                        // Player 5
                        Positioned(
                            bottom: 0, left: 0, child: player(players[3])),
                        // Player 5
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: player(players[4])),
                      ],
                    ),
                  ),
                );
              } else {
                return Text("something went wrong");
              }
            })),
        //ProgressIndicatorTurn(),
      ],
    );
  }

  Widget player(Player player) {
    bool playerDetailsVisible =
        player.name!.isNotEmpty || player.photoUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: playerDetailsVisible
                  ? NetworkImage(player.photoUrl!)
                  : const AssetImage('assets/images/poker_player.jpeg')
                      as ImageProvider,
              radius: imageRadius,
            ),
            if (playerDetailsVisible)
              Positioned(
                bottom: 0,
                left: 0,
                child: Transform(
                    transform: Matrix4.translationValues(-10, 0, 0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/backside.png',
                          height: 35,
                          width: 25,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${player.cardCount!}",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    )),
              ),
          ],
        ),
        SizedBox(
          height: 35,
          width: 100,
          child: Column(
            children: [
              const Expanded(child: SizedBox()),
              if (playerDetailsVisible)
                Text(
                  player.name!,
                  style: playerNameStyle,
                ),
              if (playerDetailsVisible)
                Text("${player.chips} ch", style: chipsText),
              if (!playerDetailsVisible)
                const Text(
                  "Waiting..",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
            ],
          ),
        ),
      ],
    );
  }
}
