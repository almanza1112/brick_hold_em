import 'package:brick_hold_em/game/game_table.dart';
import 'package:brick_hold_em/game/player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'progress_indicator.dart';

// TODO: when clicking on player, information or profile shows up...apply logic
class GamePlayers extends StatefulWidget {
  GameTable? game;

  GamePlayers({
    Key? key,
  }) : super(key: key);

  _GamePlayersState createState() => _GamePlayersState();
}

class _GamePlayersState extends State<GamePlayers>
    with TickerProviderStateMixin {
  double imageRadius = 30;
  TextStyle chipsText = const TextStyle(fontSize: 10, color: Colors.white);
  TextStyle playerNameStyle =
      const TextStyle(fontSize: 12, color: Colors.deepOrangeAccent);

  String player1Name = "";
  String player2Name = "";
  String player3Name = "";
  String player4Name = "";

  late String player1Chips;
  late String player2Chips;
  late String player3Chips;
  late String player4Chips;

  String player1PhotoURL = "";
  String player2PhotoURL = "";
  String player3PhotoURL = "";
  String player4PhotoURL = "";

  DatabaseReference playersRef =
      FirebaseDatabase.instance.ref('tables/1/players');

  var uid = FirebaseAuth.instance.currentUser!.uid;
  bool isPlayersTurn = false;

  late AnimationController controller;
  late Animation<Color?> colorTween;

// TODO need to check on this logic
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    playersRef.onValue.listen((event) async {
      final _map = Map<String, dynamic>.from(event.snapshot.value as Map);
      List<String> playerUids = [];
      List<Player> players = <Player>[];
      for (var element in _map.keys) {
        // add the players that are not you
        if (element != uid) {
          playerUids.add(element);
        }
      }

      if (playerUids.isNotEmpty) {
        for (int i = 0; i < playerUids.length; i++) {
          Player player = Player(
              uid: playerUids[i],
              name: _map[playerUids[i]]['name'],
              chips: _map[playerUids[i]]['chips'],
              photoUrl: _map[playerUids[i]]['photoUrl']);

          players.add(player);
        }
      }

      // TODO: need to apply dynamic logic
      if (playerUids.isNotEmpty) {
        Player p1 = Player(
            name: _map[playerUids[0]]["name"],
            photoUrl: _map[playerUids[0]]["photoURL"]);
        var player1Data = _map[playerUids[0]];
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("uhhhh");
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
    bool playerDetailsVisible = true;
    bool waitingVisibile = false;
    if (player.name == "" && player.photoUrl == "") {
      playerDetailsVisible = false;
      waitingVisibile = true;
    }
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
            Positioned(
              bottom: 0,
              left: 0,
              child: Transform(
                alignment: Alignment.bottomLeft,
                transform: Matrix4.translationValues(-10, 0, 0),
                child: Stack(
                  children: [
                    Image.asset(
                        'assets/images/backside.png',
                        height: 35,
                        width: 25,
                      ),
                    Align(
                      alignment: Alignment.center,
                      child: Text("${player.cardCount!}", style: TextStyle(fontSize: 14, color: Colors.amberAccent, fontWeight: FontWeight.w700),),)
                  ],
                )
                
                ),
            )
          ],
        ),
        SizedBox(
          height: 35,
          width: 100,
          child: Column(
            children: [
              Expanded(child: Container()),
              Visibility(
                visible: playerDetailsVisible,
                child: Text(
                  player.name!,
                  style: playerNameStyle,
                ),
              ),
              Visibility(
                  visible: playerDetailsVisible,
                  child: Text("${player.chips} ch", style: chipsText)),
              Visibility(
                  visible: waitingVisibile,
                  child: const Text(
                    "Waiting..",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
