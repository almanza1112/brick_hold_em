import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:brick_hold_em/game/game_chat.dart';
import 'package:brick_hold_em/game/player.dart';
import 'package:brick_hold_em/game/table_chat.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'package:brick_hold_em/game/game_cards.dart';
import 'package:brick_hold_em/game/game_players.dart';

import 'game_turn_timer.dart';

class GamePage extends ConsumerStatefulWidget {
  final VideoPlayerController controller;
  const GamePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends ConsumerState<GamePage> {
  DatabaseReference winnerRef =
      FirebaseDatabase.instance.ref('tables/1/winner');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final player = AudioPlayer();

  TextStyle menuTextStyle = TextStyle(color: Colors.grey[800]);

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
      backgroundColor: Colors.black,
      drawer: menu(),
      endDrawer: const GameChat(),
      body: SafeArea(
        child: Container(
          color: Colors.green[700],
          child: Stack(
            children: [
              GameCards(),
              //if (ref.read(isThereAWinnerProvider) == false)
              const GameTurnTimer(),
              const GamePlayers(),
              const TableChat(),
              drawerButton(),
              endDrawerButton(),
              // IgnorePointer(
              //   child: Hero(
              //     tag: 'videoPlayer',
              //     child: widget.controller.value.isInitialized
              //         ? VideoPlayer(widget.controller)
              //         : const SizedBox.shrink(),
              //   ),
              // ),
              Center(
                child: StreamBuilder(
                    stream: winnerRef.onValue,
                    builder: ((context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }

                      if (snapshot.hasData) {
                        final data = snapshot.data!.snapshot.value;

                        if (data == "none") {
                          // There is no winner

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref.read(isThereAWinnerProvider.notifier).state =
                                false;

                            ref.read(refreshKeyProvider.notifier).state = UniqueKey();
                            print("it hit here");

                          });


                          return const SizedBox.shrink();
                        } else {
                          // There is a winner

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref.read(isThereAWinnerProvider.notifier).state =
                                true;
                          });

                          if (data == uid) {
                             // Play valid sound
                            Source roundWonSound =
                                AssetSource("sounds/round_won.wav");
                            player.play(roundWonSound);

                            // You are the winner
                            return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: const Text(
                                  "YOU WON!",
                                  style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber),
                                ));
                          } else {
                            // Play round lost sound
                             Source roundLostSound =
                                AssetSource("sounds/round_lost.wav");
                            player.play(roundLostSound);

                            // Another player is the winner
                            final otherPlayersList =
                                ref.read(otherPlayersInformationProvider);
                            late Player winningPlayer;
                            for (var player in otherPlayersList) {
                              if (data == player.uid) {
                                winningPlayer = player;
                              }
                            }

                            return BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(winningPlayer.photoURL),
                                      radius: 60,
                                    ),
                                    const SizedBox(height: 12,),
                                    Text(
                                      "${winningPlayer.username} won",
                                      style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber),
                                    ),
                                  ],
                                ));
                          }
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget drawerButton() {
    return Builder(builder: (context) {
      return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          color: Colors.white,
          icon: const Icon(Icons.menu));
    });
  }

  Widget endDrawerButton() {
    return Positioned(
      right: 0,
      child: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(
                Icons.chat_rounded,
                color: Colors.white,
              ))),
    );
  }

  Widget menu() {
    return Drawer(
      backgroundColor: Colors.amber,
      child: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.only(left: 12, top: 4, bottom: 16),
            title: Text(
              "MENU",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Colors.grey[800]),
            ),
          ),

          // Exit Table
          ListTile(
            title: Text(
              "Exit Table",
              style: menuTextStyle,
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.grey[800],
            ),
            minLeadingWidth: 12,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),

          // Buy Chips
          ListTile(
            title: Text(
              "Buy Chips",
              style: menuTextStyle,
            ),
            leading: Icon(Icons.money, color: Colors.grey[800]),
            minLeadingWidth: 12,
            onTap: () {},
          ),

          // Invite Friends
          ListTile(
            title: Text(
              "Invite Friends",
              style: menuTextStyle,
            ),
            leading: Icon(Icons.group, color: Colors.grey[800]),
            minLeadingWidth: 12,
            onTap: () {},
          )
        ],
      ),
    );
  }

  removePlayer() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference database =
        FirebaseDatabase.instance.ref('tables/1/players/$uid');
    database.remove();
  }
}
