import 'dart:async';

import 'package:brick_hold_em/game/player.dart';
import 'package:brick_hold_em/game/player_profile.dart';
import 'package:brick_hold_em/game/progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brick_hold_em/globals.dart' as globals;

import 'player_profile_page_builder.dart';

class GamePlayers extends StatefulWidget {
  final ValueChanged<String> onTurnChanged;
  const GamePlayers({
    Key? key,
    required this.onTurnChanged,
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

  TextStyle turnPlayerTextStyle = const TextStyle(
      color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold);

  var uid = FirebaseAuth.instance.currentUser!.uid;
  bool isPlayersTurn = false;

  DatabaseReference turnOrderListener =
      FirebaseDatabase.instance.ref('tables/1/turnOrder/turnPlayer');

  late AnimationController _profileAnimationController;
  late Animation<Offset> _profileSlideAnimation;

  Player selectedPlayer = Player(name: '', photoUrl: '', uid: '', username: '');

  @override
  void initState() {
    _profileAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _profileSlideAnimation = Tween<Offset>(
      begin: Offset(0, 2), // Slide in from the bottom
      end: Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: Curves.ease,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _profileAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("game_players called");
    return Stack(
      children: [
        turnPlayerInfo(),
        //ProgressIndicatorTurn(),

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
                      username: map[playerUids[i]][globals.RD_KEY_USERNAME],
                      //chips: map[playerUids[i]]['chips'],
                      photoUrl: map[playerUids[i]]['photoURL']);

                  players.add(player);
                }

                for (int i = players.length; i <= 5; i++) {
                  Player player = Player(name: "", photoUrl: "", cardCount: 0, username: '', uid: '');
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
        playerProfile(selectedPlayer)
      ],
    );
  }

  Widget player(Player player) {
    bool playerDetailsVisible =
        player.name!.isNotEmpty || player.photoUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (playerDetailsVisible) {
          print("object");
          Navigator.push(
            context,
            PlayerProfilePageBuilder(
              widget: PlayerProfilePage(player: player,),
            ),
          );
        }
      },
      child: Column(
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
                    player.username,
                    style: playerNameStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
      ),
    );
  }


  Widget turnPlayerInfo() {
    int countdown = 30;

    return SafeArea(
      child: Stack(children: [
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: StreamBuilder(
                stream: turnOrderListener.onValue,
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("There was an error getting turn info");
                  }

                  if (snapshot.hasData) {
                    var turnPlayerUid =
                        (snapshot.data!).snapshot.value as String;
                    widget.onTurnChanged(turnPlayerUid);
                    if (turnPlayerUid == uid) {
                      //setIsYourTurn(true);
                      return StatefulBuilder(builder: (context, setState) {
                        // Sound for the countdown
                        SystemSound.play(SystemSoundType.click);
                        // Vibration for the countdown
                        HapticFeedback.heavyImpact();

                        if (countdown > 0) {
                          Timer(Duration(seconds: 1), () {
                            setState(() {
                              countdown--;
                            });
                          });
                        } else {
                          // TODO: APPLY THIS LOGIC
                          //ranOutOfTime();
                        }

                        return Column(
                          children: [
                            Text(
                              "IT'S YOUR TURN",
                              style: turnPlayerTextStyle,
                            ),
                            Text(
                              "$countdown",
                              style: turnPlayerTextStyle,
                            )
                          ],
                        );
                      });
                    } else {
                      return Text(
                        "Waiting...",
                        style: turnPlayerTextStyle,
                      );
                    }
                  } else {
                    return const Text("Snapshot has no data!");
                  }
                })),
          ),
        ),
      ]),
    );
  }

  Widget playerProfile(Player player) {
        Player p = player;

    //print("player: ${player.toString()}");
    return StatefulBuilder(
      builder: (context, setState) {
        setState((){
          p = player;
        });
        return  SlideTransition(
        position: _profileSlideAnimation,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(p.name!)
              ],
            )),
      );
      }
    );
  }
}
