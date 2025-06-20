import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:brick_hold_em/game/chat/game_chat.dart';
import 'package:brick_hold_em/game/new/game_cards_new.dart';
import 'package:brick_hold_em/game/new/game_countdown.dart';
import 'package:brick_hold_em/game/players/player.dart';
import 'package:brick_hold_em/game/chat/table_chat.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'package:brick_hold_em/game/players/game_players.dart';

import 'new/bottom_controls/game_turn_timer.dart';

class GamePage extends ConsumerStatefulWidget {
  final VideoPlayerController controller;
  const GamePage({
    super.key,
    required this.controller,
  });

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      drawer: menu(),
      endDrawer: const GameChat(),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 35,
                child: Image.asset('assets/images/table.png', height: 650,)),
              const GameCardsNew(),
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
              _buildWinnerOverlay()
            ],
          ),
        ),
      ),
    );
  }

  /// This widget builds the winner overlay. When winnerRef reports a winner (not "none"),
  /// we display the winner's information along with a countdown from nextGameStartProvider.
  Widget _buildWinnerOverlay() {
    return StreamBuilder(
      stream: winnerRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final data = snapshot.data!.snapshot.value;
        if (data == "none") {
          // No winner, show nothing.
          return const SizedBox.shrink();
        } else {
          // There is a winner. Delay resetting the game until the countdown finishes.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(isThereAWinnerProvider.notifier).state = true;
          });
          if (data == uid) {
            // Play round-won sound if needed.
            Source roundWonSound = AssetSource("sounds/round_won.wav");
            player.play(roundWonSound);
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "YOU WON!",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                  SizedBox(height: 20),
                  GameCountdown(), // This widget shows the countdown
                ],
              ),
            );
          } else {
            // Round lost sound, and show winning player's info.
            Source roundLostSound = AssetSource("sounds/round_lost.wav");
            player.play(roundLostSound);
            final otherPlayersList = ref.read(otherPlayersInformationProvider);
            late Player winningPlayer;
            for (var p in otherPlayersList) {
              if (data == p.uid) {
                winningPlayer = p;
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
                  const SizedBox(height: 12),
                  Text(
                    "${winningPlayer.username} won",
                    style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber),
                  ),
                  const SizedBox(height: 20),
                  const GameCountdown(),
                ],
              ),
            );
          }
        }
      },
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
