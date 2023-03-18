import 'package:brick_hold_em/game/game_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// TODO: when clicking on player, information or profile shows up...apply logic
class GamePlayers extends StatefulWidget {
  const GamePlayers({
    Key? key,
    required this.game,
  }) : super(key: key);

  final GameTable game;

  _GamePlayersState createState() => _GamePlayersState();
}

class _GamePlayersState extends State<GamePlayers> {
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

  DatabaseReference players = FirebaseDatabase.instance.ref('tables/1/players');
  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    players.onValue.listen((event) async {
      final _map = Map<String, dynamic>.from(event.snapshot.value as Map);
      //List<dynamic> data = _map[FirebaseAuth.instance.currentUser!.uid];
      List<String> playerUids = [];
      for (var element in _map.keys) {
        // add the players that are not you
        if (element != uid) {
          playerUids.add(element);
        }
      }

      // TODO: need to apply dynamic logic
      if (playerUids.isNotEmpty) {
        var player1Data = _map[playerUids[0]];
        setState(() {
          player1Name = player1Data["name"];
          player1PhotoURL = player1Data["photoURL"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 140),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 650,
              height: 415,
              color: Colors.green,
              child: Stack(
                children: [
                  // Player 1 is the user so going counter clockwise will be Player 2,3, etc
                  // Player 2
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: player(player1Name, player1PhotoURL, 1000)),
                  // Player 3
                  Positioned(
                      top: 100,
                      right: 0,
                      child: player(player2Name, player2PhotoURL, 1000)),
                  // Player 4
                  Positioned(
                      top: 100,
                      left: 0,
                      child: player(player3Name, player3PhotoURL, 1000)),
                  // Player 5
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: player(player4Name, player4PhotoURL, 1000)),
                      // Player 5
                  Positioned(
                      top: -50,
                      left: 0,
                      right: 0,
                      child: player(player4Name, player4PhotoURL, 1000)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget player(String playerUsername, String playerPhotoURL, int playerChips) {
    bool playerDetailsVisible = true;
    bool waitingVisibile = false;
    if (playerUsername == "" && playerPhotoURL == "") {
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
                  ? NetworkImage(playerPhotoURL)
                  : const AssetImage('assets/images/poker_player.jpeg')
                      as ImageProvider,
              radius: imageRadius,
            ),
          ],
        ),
        Visibility(
          visible: playerDetailsVisible,
          child: Text(
            playerUsername,
            style: playerNameStyle,
          ),
        ),
        Visibility(
            visible: playerDetailsVisible,
            child: Text("$playerChips ch", style: chipsText)),
        Visibility(
            visible: waitingVisibile,
            child: const Text(
              "Waiting..",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
