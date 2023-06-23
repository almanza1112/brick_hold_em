import 'dart:async';

import 'package:brick_hold_em/game/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameTurnTimer extends ConsumerStatefulWidget {
  const GameTurnTimer({super.key});

  @override
  GameTurnTimerState createState() => GameTurnTimerState();
}

class GameTurnTimerState extends ConsumerState {
  TextStyle turnPlayerTextStyle = const TextStyle(
      color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold);

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: <Widget>[
        Positioned(
            top: 40, left: 0, right: 0, child: Center(child: turnPlayerTimer()))
      ],
    ));
  }

 @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  Widget turnPlayerTimer() {
    int countdown = 30;

    final liveTurnPlayer = ref.watch(turnPlayerProvider);

    return liveTurnPlayer.when(
        data: (event) {
          final turnPlayerUid = event.snapshot.value.toString();

          if (turnPlayerUid == uid) {
            return StatefulBuilder(builder: (context, setState) {
              // Sound for the countdown
              SystemSound.play(SystemSoundType.click);
              // Vibration for the countdown
              HapticFeedback.heavyImpact();

              if (countdown > 0) {
                Timer(const Duration(seconds: 1), () {
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
            return SizedBox();
          }
        },
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () => const CircularProgressIndicator());
  }
}
